package com.epistimis.uddl.generator

import com.epistimis.uddl.UddlQNP
import com.epistimis.uddl.uddl.PlatformAssociation
import com.epistimis.uddl.uddl.PlatformComposableElement
import com.epistimis.uddl.uddl.PlatformComposition
import com.epistimis.uddl.uddl.PlatformDataModel
import com.epistimis.uddl.uddl.PlatformDataType
import com.epistimis.uddl.uddl.PlatformEntity
import com.epistimis.uddl.uddl.PlatformParticipant
import com.epistimis.uddl.uddl.UddlElement
import com.google.inject.Inject
import java.util.ArrayList
import java.util.Collection
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGenerator2
import org.eclipse.xtext.generator.IGeneratorContext
import org.eclipse.xtext.naming.IQualifiedNameProvider

/**
 * NOTE: Need to handle attribute cardinality in a general way - 2 parts of this: determining cardinality and then rendering.
 * Determining cardinality should be language independent.
 */


/**
 * This is the common portion of a data structure generator. It will be the base class for every data structure
 * generator for each language.
 */
abstract class CommonDataStructureGenerator implements IGenerator2 {
	
	
	@Inject
	extension protected IQualifiedNameProvider qnp;


	List<PlatformEntity> processedEntities;
	List<PlatformDataModel> processedPDMs;
	
	protected Map<PlatformComposableElement,RealizedComposableElement> allComposableElements;

	new(Map<PlatformComposableElement,RealizedComposableElement> ace) {
		allComposableElements = ace;
	}
	
	new() {
		initialize();
	}

	def void initialize() {
		if (allComposableElements === null) {
			allComposableElements = new HashMap();
		}
		if (processedEntities === null) {
			processedEntities = new ArrayList<PlatformEntity>();		
		}
		if (processedPDMs === null) {
			processedPDMs = new ArrayList<PlatformDataModel>();
		}
		if (qnp === null) {
			qnp = new UddlQNP();
		}
		
	}
	
	def void cleanup() {
		allComposableElements.clear();
		processedEntities.clear();
		processedPDMs.clear();
	}

	override beforeGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context) {
		initialize();
	}

	override afterGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context) {
		cleanup();
	}

	override doGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context) {
		initialize();
		for (PlatformComposableElement rce: allComposableElements.keySet) {
			if (rce instanceof PlatformEntity) {
				val re = rce as PlatformEntity;
				processAnEntity(re,fsa,context);
			}
		}
		cleanup();
	}

	def getDirDelimiter() {
		return System.getProperty("file.separator");
	}
	def String getRootDirectory() // You must override this method");
	
	def String getFileExtension() // You must override this method");

	def String getFileHeader() { return "";}
	/* These are common across many languages so put them in the base class */
	def String getMultiLineCmtStart() { return "/*"; }				
	def	String getMultiLineCmtEnd()   { return "*/";} 
	def String getSingleLineCmtStart() { return "//";}
	
	def String getStmtEnd() 	{ return ";";}
	def String getScopeStart() 	{ return "{";} 
	def String getScopeEnd() 	{ return "}"; }
	def String getStructStart() { return "{"; }
	def String getStructEnd() 	{ return "};";}
	def String getElemEnd() 	{ return ";"}
	def String getArrStart() 	{ return "[";}
	def String getArrEnd() 		{ return "]" ;}
	
	def String getImportPrefix() // You must override this method");		
	def String getImportSuffix() // You must override this method");
				
	def String getTypeDefPrefix() // You must override this method");		

	def String getNamespaceKwd()
	def String getClazzKwd()
	
	def String getSpecializesKwd()
	
	def String getCompositionVisibility()
	
	/** This method gets around a problem with inheritance and dispatch methods */
	def String getPDTTypeString(PlatformDataType pdt);
	
	/**
	 * TODO: Structured FDTs aren't currently supported 
	 * dispatch methods can't be abstract - so force override
	 */
	def dispatch String getTypeString(PlatformDataType pdt) {
		return pdt.PDTTypeString;
	} 
	def dispatch String getTypeString(PlatformEntity ent) {
		return ent.name;
	}
	

	

	
	

	/**
	 * We replace the standard delimiter with a directory delimiter as a way to generate all the directories we want
	 */
	def String generateDirectories(EObject obj) {
		return generateDirectories(obj,0);
	}
	def String generateDirectories(EObject obj,int skipCnt) {
		return qnp.getFullyQualifiedName(obj).skipLast(skipCnt).toString(getDirDelimiter());
	}
	def String generateFileName(UddlElement obj) {
		return generateDirectories(obj)+ getDirDelimiter() + obj.name + getFileExtension();
	}

	
	/** When you only want to process selected Entities (rather than all of them) call this.
	 * This will be called from the FaceGenerator. We should have 1 of these in each language specific generator
	 * */
	def processEntities(Collection<PlatformEntity> entities, IFileSystemAccess2 fsa,IGeneratorContext context) {
		initialize();
		for (PlatformEntity entity: entities) {
			processAnEntity(entity, fsa, context);
		}
		cleanup();
	}
	
	/**
	 * Processing an Entity requires both generating the file(s) for this Entity (which will require references to the headers for any referenced
	 * types) as well as generating the files for any referenced types. This requires recursion.
	 * In this original version, we assume that all PlatformDataTypes will be defined in a header file identified by the PDM container hierarchy.
	 * There will be a directory for each PDM - and a header file with the same name as the PDM containing all the PlatformDataTypes defined at that level.
	 * 
	 * NOTE: processing an Entity or PDT means 2 things: 1) Has a header file been created for this? 2) Has the header for this type been included for 
	 * current Entity (the Entity whose header is being generated)?  #1 requires a global list; #2 requires a list localized to this recursion level only
	 */
	def processAnEntity(PlatformEntity entity, IFileSystemAccess2 fsa, IGeneratorContext context) {
		if (!processedEntities.contains(entity)) {
			processedEntities.add(entity);
			fsa.generateFile(getRootDirectory() + generateDirectories(entity) + getFileExtension(),entity.compile)			
			for (PlatformComposition comp: entity.composition) {
				val PlatformComposableElement pce = comp.type;
				if (pce instanceof PlatformDataType) {
					// find the container (PDM) and process that
					val PlatformDataModel pdtContainer = pce.eContainer as PlatformDataModel;
					if (!processedPDMs.contains(pdtContainer)) {
						processedPDMs.add(pdtContainer);
						fsa.generateFile(getRootDirectory() + generateFileName(pdtContainer),pdtContainer.compile)
					}
				}
			}
			if (entity instanceof PlatformAssociation) {
				val PlatformAssociation assoc = entity as PlatformAssociation;
				for (PlatformParticipant part: assoc.participant) {
					
				}
			}
		}
		
	}


	/**
	 * When creating a PDM header file, only include PlatformDataTypes. PlatformEntity gets a header per entity
	 */
	def compile(PlatformDataModel pdm) {
		'''
		«val pdts = pdm.eContents.filter(PlatformDataType)»
		«FOR pdt: pdts»
		«typeDefPrefix» «pdt.getTypeString» «pdt.name» «stmtEnd»
		«ENDFOR»
		'''
	}
	
	/**
	 * Generate the include reference to the appropriate header file if it hasn't already been included.
	 */
	def String generateInclude(PlatformComposableElement type, List<PlatformDataModel> pdmIncludes, List<PlatformEntity> entityIncludes ) {
	  if (type instanceof PlatformDataType) {
    	val pdm = type.eContainer as PlatformDataModel;
		if ( !pdmIncludes.contains(pdm)) {
	  		pdmIncludes.add(pdm);
			return getImportPrefix() + pdm.generateFileName + getImportSuffix();
		}
	  }
	  else {
		val PlatformEntity entType = type as PlatformEntity;
		if ( !entityIncludes.contains(entType)) {
			  entityIncludes.add(entType);	
			return getImportPrefix() + entType.generateFileName + getImportSuffix();
		}
		
	  }
	  /** If we get here, then it was already included */
	  return "";		
	}
	
	def compile(PlatformEntity entity) {
		'''
		«fileHeader»
		«multiLineCmtStart» «entity.description» «multiLineCmtEnd»
		«var entityIncludes = new ArrayList<PlatformEntity>»
		«var List<PlatformDataModel> pdmIncludes = new ArrayList<PlatformDataModel>»
		«FOR composition: entity.composition»
			«composition.type.generateInclude(pdmIncludes, entityIncludes)»
		«ENDFOR»
		«IF entity.specializes !== null »
			«entity.specializes.generateInclude(pdmIncludes,entityIncludes)»
		«ENDIF»
		«clazzKwd» «entity.name» «IF entity.specializes !== null » «specializesKwd» «entity.specializes» «ENDIF» «structStart»
			«FOR composition: entity.composition»
			«compositionVisibility» «composition.type.name» «composition.rolename»«IF composition.upperBound > 1»«arrStart»«composition.upperBound»«arrEnd»«ENDIF»«elemEnd» «singleLineCmtStart» «composition.description»
			«ENDFOR»
		«structEnd»
		'''
	}

	def compile(PlatformAssociation entity) {
		'''
		«fileHeader»
		«multiLineCmtStart» «entity.description» «multiLineCmtEnd»
		«var entityIncludes = new ArrayList<PlatformEntity>»
		«var List<PlatformDataModel> pdmIncludes = new ArrayList<PlatformDataModel>»
		«FOR composition: entity.composition»
			«composition.type.generateInclude(pdmIncludes, entityIncludes)»
		«ENDFOR»
		«FOR participant: entity.participant»
			«participant.type.generateInclude(pdmIncludes, entityIncludes)»
		«ENDFOR»
		«IF entity.specializes !== null »
			«entity.specializes.generateInclude(pdmIncludes,entityIncludes)»
		«ENDIF»
		«clazzKwd» «entity.name» «IF entity.specializes !== null» «specializesKwd» «entity.specializes» «ENDIF» «structStart»
			«FOR composition: entity.composition»
			«compositionVisibility» «composition.type.name» «composition.rolename»«IF composition.upperBound > 1»«arrStart»«composition.upperBound»«arrEnd»«ENDIF»«elemEnd» «singleLineCmtStart» «composition.description»
			«ENDFOR»
			«FOR participant: entity.participant»
			«compositionVisibility» «participant.type.name» «participant.rolename»«IF participant.upperBound > 1»«arrStart»«participant.upperBound»«arrEnd»«ENDIF»«elemEnd» «singleLineCmtStart» «participant.description»
			«ENDFOR»

		«structEnd»
		'''
	}

}