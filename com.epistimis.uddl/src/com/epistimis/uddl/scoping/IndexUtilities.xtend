package com.epistimis.uddl.scoping

import com.epistimis.uddl.uddl.UddlPackage
import com.google.inject.Inject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.resource.IContainer
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.resource.IEObjectDescription
import java.util.List
import org.eclipse.xtext.naming.IQualifiedNameProvider
import java.text.MessageFormat

/**
 * This is modified from the book (See https://github.com/LorenzoBettini/packtpub-xtext-book-2nd-examples)
 * Smalljava = SmallJavaIndex.xtend
 */
class IndexUtilities {
	@Inject ResourceDescriptionsProvider rdp
	@Inject IContainer.Manager cm
	@Inject IQualifiedNameProvider qnp

	def getVisibleEObjectDescriptions(EObject o, EClass type) {
		o.getVisibleContainers.map [ container |
			container.getExportedObjectsByType(type)
		].flatten
	}

	def getVisibleContainers(EObject o) {
		val index = rdp.getResourceDescriptions(o.eResource)
		val rd = index.getResourceDescription(o.eResource.URI)
		cm.getVisibleContainers(rd, index)
	}

	def getResourceDescription(EObject o) {
		val index = rdp.getResourceDescriptions(o.eResource)
		index.getResourceDescription(o.eResource.URI)
	}

	def getExportedEObjectDescriptions(EObject o) {
		o.getResourceDescription.getExportedObjects
	}

	def getExportedEObjectDescriptionsByType(EObject o, EClass type) {
		o.getResourceDescription.getExportedObjectsByType(type)
	}

	def getVisibleExternalEObjectDescriptionsByType(EObject o, EClass type) {
		val allVisibleEObjectDescriptions = o.getVisibleEObjectDescriptions(type)
		val allExportedEObjectDescriptions = o.getExportedEObjectDescriptionsByType(type)
		val difference = allVisibleEObjectDescriptions.toSet
		difference.removeAll(allExportedEObjectDescriptions.toSet)
		return difference.toMap[qualifiedName]
	}

	/**
	 * Find all visible EObjects that match this type and name. The name may be 
	 * a leaf, RQN, or FQN
	 */
	def searchAllVisibleEObjectDescriptions(EObject context, EClass type, String name) {

		context.getVisibleEObjectDescriptions(type).filter [
			val QualifiedName qn = it.getQualifiedName();
			for (var i = qn.getSegmentCount() - 1; i >= 0; i--) {
				val rqn = qn.skipFirst(i).toString();
				if (name.equalsIgnoreCase(rqn)) {
					return true;
				}
			}
			/**
			 * If we get here, there wasn't a match on this description
			 */
			return false;
		].toList;
	}

	/**
	 * 
	 */
	def searchAllVisibleObjects(EObject context, EClass type, String name) {
		context.searchAllVisibleEObjectDescriptions(type, name).map([
			context.eResource.objectFromDescription(it)
		]);
	}

	def static objectFromDescription(Resource res, IEObjectDescription desc) {
		if (desc === null)
			return null;
		var EObject o = desc.getEObjectOrProxy();
		if (o.eIsProxy()) {
			o = res.getResourceSet().getEObject(desc.getEObjectURI(), true);
		}
		return o;
	}

	/**
	 * Find a unique object of the specified type and name. Log errors if none or more
	 * than one is found.
	 */
	def getUniqueObjectForName(EObject context, EClass type, String name) {
		val List<EObject> objList = searchAllVisibleObjects(context, type, name);
		switch objList.size() {
			case 0: {
				System.out.println(MessageFormat.format("No instance found with name {0}", name));
				return null;
			}
			case 1:
				objList.get(0)
			default: {
				printEObjectNameCollisions(name, type.getName(), objList);
				return null;
			}
		}
	}

	/**
	 * It is possible that there are name collisions from searches. This is a standard way to list them.
	 * @param qn A string version of a possibly qualified name
	 * @param typeName The type we were looking for
	 * @param descriptions What we found
	 */
	def printIEObjectDescriptionNameCollisions(String qn, String typeName, List<IEObjectDescription> descriptions) {
		System.out.println(qn + " makes ambiguous reference to instances of type" + typeName + ". It could be: ");
		for (IEObjectDescription d : descriptions) {
			// May need to use qnp.getFullyQualifiedName(d.getEObjectOrProxy())
			System.out.println("\t" + d.getQualifiedName().toString());
		}

	}

	/**
	 * It is possible that there are name collisions from searches. This is a standard way to list them.
	 * @param qn A string version of a possibly qualified name
	 * @param typeName The type we were looking for
	 * @param objects What we found
	 */
	def printEObjectNameCollisions(String qn, String typeName, List<EObject> objects) {
		System.out.println(qn + " makes ambiguous reference to instances of type" + typeName + ". It could be: ");
		for (EObject o : objects) {
			System.out.println("\t" + qnp.getFullyQualifiedName(o).toString());
		}

	}

	/**
	 * These methods are specific to this package
	 */
	def getVisibleDataModelDescriptions(EObject o) {
		o.getVisibleEObjectDescriptions(UddlPackage.eINSTANCE.dataModel)
	}

	def getExportedDataModelEObjectDescriptions(EObject o) {
		o.getResourceDescription.getExportedObjectsByType(UddlPackage.eINSTANCE.dataModel)
	}

	def getVisibleExternalDataModelDescriptions(EObject o) {
		o.getVisibleExternalEObjectDescriptionsByType(UddlPackage.eINSTANCE.dataModel)
	}
/*	
 * The original version of this method is below. This was recoded to use the general
 * implementation to make any maintenance simpler.
 */
/*
 * 	def getVisibleExternalClassesDescriptions(EObject o) {
 * 		val allVisibleClasses =
 * 			o.getVisibleClassesDescriptions
 * 		val allExportedClasses =
 * 			o.getExportedClassesEObjectDescriptions
 * 		val difference = allVisibleClasses.toSet
 * 		difference.removeAll(allExportedClasses.toSet)
 * 		return difference.toMap[qualifiedName]
 * 	}
 */
}
