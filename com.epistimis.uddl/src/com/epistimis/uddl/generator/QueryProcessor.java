package com.epistimis.uddl.generator;

import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.xtext.naming.IQualifiedNameConverter;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.resource.IEObjectDescription;
import org.eclipse.xtext.scoping.IScope;
import org.eclipse.xtext.scoping.Scopes;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.IteratorExtensions;

import com.epistimis.uddl.CLPExtractors;
import com.epistimis.uddl.query.query.QueryIdentifier;
import com.epistimis.uddl.query.query.QuerySpecification;
import com.epistimis.uddl.query.query.SelectedEntity;
import com.epistimis.uddl.scoping.IndexUtilities;
import com.epistimis.uddl.uddl.PlatformCompositeQuery;
import com.epistimis.uddl.uddl.PlatformEntity;
import com.epistimis.uddl.uddl.PlatformQuery;
import com.epistimis.uddl.uddl.PlatformQueryComposition;
import com.epistimis.uddl.uddl.PlatformView;
import com.epistimis.uddl.uddl.UddlPackage;
import com.google.common.collect.Iterables;
import com.google.inject.Inject;

public class QueryProcessor {
	// @Inject
//	private Provider<ResourceSet> resourceSetProvider;
//
//
//	@Inject
//	IResourceServiceProvider.Registry reg;
//
//	IResourceServiceProvider queryRSP;
//	IResourceFactory queryResFactory;

//	@Inject
//	ParseHelper<QuerySpecification> parseHelper;

	@Inject
	IndexUtilities ndxUtil;

	@Inject
	IQualifiedNameProvider qnp;

	@Inject
	IQualifiedNameConverter qnc;

	public QueryProcessor() {
		// this.reg = reg;
//		URI queryURI = URI.createURI(QueryPackageImpl.eNS_URI);

//		queryRSP = reg.getResourceServiceProvider(queryURI);
//		// Now register the file type so we don't need a file extension
//		reg.getContentTypeToFactoryMap().put("quddl", queryRSP);
//		queryResFactory = queryRSP.get(IResourceFactory.class);

	}

	/**
	 * Get all the Entities visible from the (C/L/P)View where the query spec was
	 * defined.
	 */

	/**
	 *
	 * @param <Entity>
	 * @param <Characteristic>
	 * @param <Association>
	 * @param <Participant>
	 * @param ent
	 * @return
	 */

//	private static <View, Entity extends UddlElement,
//	Characteristic,
//	Association extends Entity,
//	Participant extends Characteristic>
//List<Entity> 	getEntities(View v, Entity ent){
//
//		// Set up to process with correct parser
//	}
//

	public QuerySpecification processQuery(PlatformQuery query) {
		String queryText = CLPExtractors.getSpecification(query);
		QuerySpecification qspec = null;
		try {
			// See https://www.eclipse.org/forums/index.php?t=msg&th=173070/ for explanation
			ResourceSet resourceSet = new ResourceSetImpl();
			Resource resource = resourceSet.createResource(URI.createURI("temp.quddl"));
			ByteArrayInputStream bais = new ByteArrayInputStream(queryText.getBytes());
			resource.load(bais, null);
			qspec = (QuerySpecification) resource.getContents().get(0);

		} catch (Exception e) {
			// TODO: This should also check for Parse errors - like unit tests do - and print out something.
			System.out.println("Query " + qnp.getFullyQualifiedName(query).toString() + " contains a malformed query: '"
					+ queryText + "'");
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return qspec;
	}

	/**
	 * Processing a CompositeQuery just means drilling down and processing each
	 * contained individual query
	 * 
	 * @param query
	 * @return
	 */
	public List<QuerySpecification> processQuery(PlatformCompositeQuery query) {
		List<QuerySpecification> results = new ArrayList<QuerySpecification>();
		for (PlatformQueryComposition comp : query.getComposition()) {
			PlatformView v = comp.getType();
			if (v instanceof PlatformQuery) {
				results.add(processQuery((PlatformQuery) v));
			} else if (v instanceof PlatformCompositeQuery) {
				results.addAll(processQuery((PlatformCompositeQuery) v));
			}
		}
		return results;
	}

	/**
	 * To properly process a parsed query, we need to match names against UDDL
	 * objects. That means we need to determine the relative names and find a match,
	 * working from inside out. The names will be relative to the Query instance
	 * containing the parsed specification.
	 */
	public /* <Query extends UddlElement> */ List<PlatformEntity> matchQuerytoUDDL(PlatformQuery q,
			QuerySpecification qspec) {
		Resource resource = q.eResource();
		// Initially, we just get the Entity names
		List<PlatformEntity> chosenEntities = new ArrayList<PlatformEntity>();
		String queryFQN = qnp.getFullyQualifiedName(q).toString();
		final Iterable<SelectedEntity> selectedEntities = Iterables.<SelectedEntity>filter(
				IteratorExtensions.<EObject>toIterable(qspec.eAllContents()), SelectedEntity.class);
		for (SelectedEntity se : selectedEntities) {
			QueryIdentifier qid = (QueryIdentifier) se.getEntityType();
			String entityName = qid.getId();

			/**
			 * TODO: Gets a scope that is for this container hierarchy only. For imports,
			 * need to use IndexUtilities to get all visible IEObjectDescriptions and filter
			 * those. That will require RQNs processing.
			 */
			IScope searchScope = entityScope(q.eContainer());
			List<IEObjectDescription> lod = IterableExtensions.<IEObjectDescription>toList(searchScope.getElements(qnc.toQualifiedName(entityName)));
//			List<IEObjectDescription> lod = new ArrayList<IEObjectDescription>();
//			for (IEObjectDescription desc : descriptions) {
//				lod.add(desc);
//			}

			/**
			 * There should be only 1 for each entityName - otherwise, we have ambiguity
			 */
			switch (lod.size()) {
			case 0: {
					// If nothing found so far, check all visible objects
					List<IEObjectDescription> globalDescs = ndxUtil.searchAllVisibleEObjectDescriptions(q, UddlPackage.eINSTANCE.getPlatformEntity(), entityName);
					switch (globalDescs.size()) {
					case 0:
						System.out.println("No Entities found for name: " + entityName + " from Query " + queryFQN);
						break;
					case 1:
						chosenEntities.add((PlatformEntity) IndexUtilities.objectFromDescription(resource,globalDescs.get(0)));
						break;
					default:
						/** found multiple - so print out their names */
						ndxUtil.printIEObjectDescriptionNameCollisions(queryFQN,PlatformQuery.class.getName(),globalDescs);
						break;
					}
				}
				break;
			case 1:
				IEObjectDescription description = lod.get(0);
				chosenEntities.add((PlatformEntity) IndexUtilities.objectFromDescription(resource,description));
				break;
			default:
				/** found multiple - so print out their names */
				ndxUtil.printIEObjectDescriptionNameCollisions(queryFQN, PlatformQuery.class.getName(), lod);
			}
		}
		/* at this point we have identified all the entities */
		return chosenEntities;
	}
	
	// Moved to IndexUtilities
//	private void listNameCollisions(String queryFQN, String entityName, List<IEObjectDescription> descriptions) {
//		System.out.println(
//				"Query " + queryFQN + " makes ambiguous reference to " + entityName + ". It could be: ");
//		for (IEObjectDescription d : descriptions) {
//			// May need to use qnp.getFullyQualifiedName(d.getEObjectOrProxy())
//			System.out.println("\t" + d.getQualifiedName().toString());
//		}
//		
//	}

	// Moved to IndexUtilities
//	private EObject objectFromDescription(Resource res, IEObjectDescription desc) {
//		if (desc == null)
//			return null;
//		EObject o = desc.getEObjectOrProxy();
//		if (o.eIsProxy()) {
//			o = res.getResourceSet().getEObject(desc.getEObjectURI(), true);
//		}
//		return o;
//	}

	/**
	 * Taken from the book, SmallJavaLib.getSmallJavaObjectClass - and converted
	 * from XTend to Java
	 * 
	 * Additionally, this checks for RQNs instead of just leaf names, or FQNs
	 * 
	 * Also note that case doesn't matter
	 * 
	 * @param context - Check visibility to this object
	 * @param type - Filter for only for instances of this type
	 * @param name - Filter for only instances that match this RQN
	 * @return A list of matching objects
	 * 
	 * TODO: 
	 */
	protected List<IEObjectDescription> searchAllVisibleObjects(EObject context, EClass type, String name) {
		// Commented code now in IndexUtilities
//		Iterable<IEObjectDescription> descriptions = ndxUtil.getVisibleEObjectDescriptions(context, type);
//
//		final Function1<IEObjectDescription, Boolean> _function = (IEObjectDescription it) -> {
//			/**
//			 * Because the passed in name may be relative, we need to check all possible
//			 * name fragments for a match
//			 */
//			QualifiedName qn = it.getQualifiedName();
//			for (int i = qn.getSegmentCount() - 1; i >= 0; i--) {
//				String rqn = qn.skipFirst(i).toString();
//				if (name.equalsIgnoreCase(rqn)) {
//					return true;
//				}
//			}
//			/**
//			 * If we get here, there wasn't a match on this description
//			 */
//			return false;
//		};
//		Iterable<IEObjectDescription> filteredDescs = IterableExtensions.<IEObjectDescription>filter(descriptions, _function);
//		List<IEObjectDescription> lod = new ArrayList<IEObjectDescription>();
//		for (IEObjectDescription desc : filteredDescs) {
//			lod.add(desc);
//		}
		List<IEObjectDescription> lod = ndxUtil.searchAllVisibleEObjectDescriptions(context, type, name);
		return lod;
	}

	/**
	 * Find all the Entities in this hierarchy
	 * 
	 * @param q
	 * @param context
	 * @return
	 */
	protected /* <Query extends UddlElement,Entity extends UddlElement > */ IScope entityScope(EObject context) {
		/*
		 * the object will either be the original query or a containing PDM - so
		 * containers will always be a (C/L/P)DM or a DataModel
		 */
		final Iterable<PlatformEntity> entities = IterableExtensions.<PlatformEntity>filter(
				IteratorExtensions.<EObject>toIterable(context.eAllContents()), PlatformEntity.class);
		EObject container = context.eContainer();
		if (container != null) {
			return Scopes.scopeFor(entities, entityScope(container));
		} else {
			return Scopes.scopeFor(entities, IScope.NULLSCOPE);
		}
	}

	public void setupParsing() {
//
//		// obtain a resourceset from the injector
//		XtextResourceSet resourceSet = injector.getInstance(XtextResourceSet.class);
//		// load a resource by URI, in this case from the file system
//		Resource resource = resourceSet.getResource(URI.createFileURI("./mymodel.mydsl"), true);
//		//If you want to load a bunch of files that have references to each other, you should add them all to the resourceset at this point, by calling
//		resourceSet.getResource(URI.createFileURI("./anothermodel.mydsl"), true);
//
//		String t = "...";
//		Injector guiceInjector = new MyDSLStandaloneSetup().createInjectorAndDoEMFRegistration();
//		IParser parser = guiceInjector.getInstance(IAntlrParser.class);
////		IParseResult result = parser.parse(new StringInputStream(t));
////		List<SyntaxError> errors = result.getParseErrors();
////		Assert.assertTrue(errors.size() == 0);
////		EObject eRoot = result.getRootASTElement();
////		MyDSLRoot root = (MyDSLRoot) eRoot;
////
		/**
		 * Use this code to initialize the RSP
		 */

//
//
//		/**
//		 * When reading the content do this
//		 */
//		// create a resource for language 'Quddl'
//		Resource query = resourceSet.createResource(URI.createURI("string.quddl"));
//		// parse some contents
//		query.load(new StringInputStream(".."), Collections.emptyMap());
//		// After loading all the relevant resources
//		EcoreUtil.resolveAll(query);
//
//		queryRSP.get(I)
//
	}

//	protected XtextResource createResource(String content) {
//		URI tempURI = URI.createFileURI("temp.uddl");
//		XtextResource result = (XtextResource) queryResFactory.createResource(tempURI);
//		try {
//			result.load(new StringInputStream(content, result.getEncoding()), Collections.emptyMap());
//		} catch (Exception e) {
//			throw new RuntimeException(e);
//		}
//		return result;
//	}
}
