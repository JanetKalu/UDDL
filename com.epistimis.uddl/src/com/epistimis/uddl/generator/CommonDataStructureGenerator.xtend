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
import com.epistimis.uddl.uddl.PlatformCharacteristic

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

	protected Map<PlatformComposableElement, RealizedComposableElement> allComposableElements;

	new(Map<PlatformComposableElement, RealizedComposableElement> ace) {
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
		for (PlatformComposableElement rce : allComposableElements.keySet) {
			if (rce instanceof PlatformEntity) {
				val re = rce as PlatformEntity;
				processAnEntity(re, fsa, context);
			}
		}
		cleanup();
	}

	def getDirDelimiter() {
		return System.getProperty("file.separator");
	}

	def String getRootDirectory() // You must override this method");

	/**
	 * In most cases, the write and read extensions will be the same. However, in some cases, 
	 * they won't. Examples include Typescript (starts as .ts and is converted to .js), and 
	 * XTend (starts as .xtend and is converted to .java).
	 * By having different extensions, we support the need to read from a different file extension
	 * than was originally written.
	 */
	def String getWriteFileExtension() // extension to use when writing files
	def String getReadFileExtension() // extension to use when reading files 

	def String getFileHeader(PlatformEntity entity);

	/* These are common across many languages so put them in the base class */
	def String getMultiLineCmtStart() { return "/*"; }

	def String getMultiLineCmtEnd() { return "*/"; }

	def String getSingleLineCmtStart() { return "//"; }

	def String getStmtEnd() { return ";"; }

	def String getScopeStart() { return "{"; }

	def String getScopeEnd() { return "}"; }

	def String getStructStart() { return "{"; }

	def String getStructEnd() { return "};"; }

	def String getElemEnd() { return ";" }

	def String getArrStart() { return "["; }

	def String getArrEnd() { return "]"; }

	def String getImportPrefix() // You must override this method");		

	def String getImportSuffix() // You must override this method");

	def String pdmHeader(PlatformDataModel pdm)

	def String defNewType(PlatformDataType pdt)

	def String getTypeDefPrefix() // You must override this method");		

	def String getNamespaceKwd()

	def String getClazzKwd()

	def String getSpecializesKwd()
	
	def String getCompositionVisibility()

	/** This method gets around a problem with inheritance and dispatch methods */
	def String getPDTTypeString(PlatformDataType pdt);

	def String clazzDecl(PlatformEntity entity);

	def String clazzEndDecl(PlatformEntity entity)

	/**
	 * TODO: Structured FDTs aren't currently supported 
	 * dispatch methods can't be abstract - so force override
	 */
	def dispatch String getTypeString(PlatformDataType pdt) {
		return pdt.PDTTypeString;
	}

	def dispatch String getTypeString(PlatformEntity ent) {
		return genTypeName(ent);
	}

	/**
	 * We replace the standard delimiter with a directory delimiter as a way to generate all the directories we want
	 */
	def String generateDirectories(EObject obj) {
		return generateDirectories(obj, 0);
	}

	def String generateDirectories(EObject obj, int skipCnt) {
		return qnp.getFullyQualifiedName(obj).skipLast(skipCnt).toString(getDirDelimiter());
	}
	/**
	 * Generate a relative path under the assumption that qualified names also describe the
	 * directory hierarchy
	 */
	def String generateRelativePath(EObject obj, EObject ctx, int skipCnt) {
		val UddlQNP uqnp = this.qnp as UddlQNP;
		/**
		 *  Here we want to find the path from the ctx to the obj. That means potentially going up
		 * and down directories. Must insert dir up for each 		  
		 */
		val downRQN = uqnp.relativeQualifiedName(obj,ctx);
		val upRQN = uqnp.relativeQualifiedName(ctx,obj);
		var String result = "";
		for (var i = 2; i < upRQN.segmentCount; i++) {
			result += ".."+ getDirDelimiter();
		}
		// strip off extra delimiter at the end of the result
		return result + downRQN.skipFirst(1).skipLast(skipCnt).toString(getDirDelimiter());
	}

	def String setTrailingDirDelimiter(String path) {
		if ((path.length > 0 ) && (path.charAt(path.length-1) != getDirDelimiter().charAt(0))) {
			return path + getDirDelimiter();
		}
		else {
			return path;
		}
		
	}
	/**
	 * Generate a read file name of obj relative to context.  
	 */
	def String generateRelativeReadFileName(UddlElement obj, EObject context) {
		
		var name = obj.name
		if (obj instanceof PlatformComposableElement) {
			// For those cases where we are dealing with types, make sure the file name 
			// matches the format of the type defined within it
			name =  obj.genTypeName;
		}
		var relPath = generateRelativePath(obj,context,1).setTrailingDirDelimiter;

		return  relPath  + name + getReadFileExtension();
	}

	/**
	 * Generate the name of the file to write relative to the root directory 
	 */
	def String generateWriteFileName(UddlElement obj) {
		
		var name = obj.name
		if (obj instanceof PlatformComposableElement) {
			// For those cases where we are dealing with types, make sure the file name 
			// matches the format of the type defined within it
			name =  obj.genTypeName;
		}
		var path = getRootDirectory() + generateDirectories(obj,1).setTrailingDirDelimiter;

		return  path  + name + getWriteFileExtension();
	}

	/** When you only want to process selected Entities (rather than all of them) call this.
	 * This will be called from the FaceGenerator. We should have 1 of these in each language specific generator
	 * */
	def processEntities(Collection<PlatformEntity> entities, IFileSystemAccess2 fsa, IGeneratorContext context) {
		initialize();
		for (PlatformEntity entity : entities) {
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
	def void processAnEntity(PlatformEntity entity, IFileSystemAccess2 fsa, IGeneratorContext context) {
		if (!processedEntities.contains(entity)) {
			processedEntities.add(entity);
			fsa.generateFile(generateWriteFileName(entity), entity.compile)
			for (PlatformComposition comp : entity.composition) {
				val PlatformComposableElement pce = comp.type;
				processCompositionElement(pce, fsa, context)
			}
			if (entity instanceof PlatformAssociation) {
				val PlatformAssociation assoc = entity as PlatformAssociation;
				for (PlatformParticipant part : assoc.participant) {
					val PlatformComposableElement pce = part.type;
					processCompositionElement(pce, fsa, context)
				}
			}
		}

	}

	def processCompositionElement(PlatformComposableElement pce, IFileSystemAccess2 fsa, IGeneratorContext context) {
		if (pce instanceof PlatformDataType) {
			// find the container (PDM) and process that
			val PlatformDataModel pdtContainer = pce.eContainer as PlatformDataModel;
			if (!processedPDMs.contains(pdtContainer)) {
				processedPDMs.add(pdtContainer);
				fsa.generateFile(generateWriteFileName(pdtContainer), pdtContainer.compile)
			}
		} else if (pce instanceof PlatformEntity) {
			val PlatformEntity pEnt = pce as PlatformEntity;
			if (!processedEntities.contains(pEnt)) {
				// recursively call and generate for this Entity
				processAnEntity(pEnt, fsa, context);
			}
		} else {
			System.out.println("Cannot process unsupported Entity type: " + pce.toString);
		}

	}

	/**
	 * When creating a PDM header file, only include PlatformDataTypes. PlatformEntity gets a header per entity
	 */
	def compile(PlatformDataModel pdm) {
		'''
			«pdm.pdmHeader»
			«val pdts = pdm.eContents.filter(PlatformDataType)»
			«FOR pdt : pdts»
				«pdt.defNewType»
			«ENDFOR»
		'''
	}

	def String genTypeName(PlatformComposableElement pce);

	def String generateImportStatement(PlatformDataModel pdm, EObject ctx);

	def String generateImportStatement(PlatformEntity entType, EObject ctx) ;

	/**
	 * Generate the include reference to the appropriate header file if it hasn't already been included.
	 * 
	 * TODO: Everything that is included must also be generated in this language.
	 */
	def String generateInclude(PlatformComposableElement type, EObject ctx, List<PlatformDataModel> pdmIncludes,
		List<PlatformEntity> entityIncludes) {
		if (type instanceof PlatformDataType) {
			val pdm = type.eContainer as PlatformDataModel;
			if (!pdmIncludes.contains(pdm)) {
				pdmIncludes.add(pdm);
				return generateImportStatement(pdm,ctx);
			}
		} else {
			val PlatformEntity entType = type as PlatformEntity;
			if (!entityIncludes.contains(entType)) {
				entityIncludes.add(entType);
				return generateImportStatement(entType,ctx);
			}
		}
		/** If we get here, then it was already included */
		return "";
	}

	def String nDent(int tabCnt) {
		if (tabCnt == 0) {
			return "";
		} else {
			return "	" + nDent(tabCnt - 1)
		}
	}

	/**
	 * @param comp the composition element to generate a member for
	 * @param ndx the zero based index of this element in the structure
	 */
	def String compositionElement(PlatformComposition comp, int ndx);

	/**
	 * @param participant the participant element to generate a member for
	 * @param ndx the zero based index of this element in the structure
	 */
	def String participantElement(PlatformParticipant participant, int ndx);

	def compile(PlatformEntity entity) {
		var entityIncludes = new ArrayList<PlatformEntity>
		// Do not include the entity we're processing - treat it like it has already been processed
		entityIncludes.add(entity)
		var List<PlatformDataModel> pdmIncludes = new ArrayList<PlatformDataModel>
		var ndx = 0

		// Now generate the return value (the last value generated)
		'''
			«entity.fileHeader»
			«FOR composition : entity.composition»
				«composition.type.generateInclude(entity,pdmIncludes, entityIncludes)»
			«ENDFOR»
			«IF entity.specializes !== null »
				«entity.specializes.generateInclude(entity,pdmIncludes,entityIncludes)»
			«ENDIF»
			«entity.clazzDecl» 
			«FOR composition : entity.composition»
				«composition.compositionElement(ndx++)»
			«ENDFOR»
			«entity.clazzEndDecl»
		'''
	}

	def compile(PlatformAssociation entity) {
		var entityIncludes = new ArrayList<PlatformEntity>
		// Do not include the entity we're processing - treat it like it has already been processed
		entityIncludes.add(entity)
		var List<PlatformDataModel> pdmIncludes = new ArrayList<PlatformDataModel>
		var ndx = 0

		// Now generate the return value (the last value generated)
		'''
			«entity.fileHeader»
			«FOR composition : entity.composition»
				«composition.type.generateInclude(entity,pdmIncludes, entityIncludes)»
			«ENDFOR»
			«FOR participant : entity.participant»
				«participant.type.generateInclude(entity,pdmIncludes, entityIncludes)»
			«ENDFOR»
			«IF entity.specializes !== null »
				«entity.specializes.generateInclude(entity,pdmIncludes,entityIncludes)»
			«ENDIF»
			«entity.clazzDecl» 
			«FOR composition : entity.composition»
				«composition.compositionElement(ndx++)»
				«ndx = ndx+1»
			«ENDFOR»
			«FOR participant : entity.participant»
				«participant.participantElement(ndx++)»
				«ndx = ndx+1»
			«ENDFOR»
			
			«entity.clazzEndDecl»
		'''
	}

}
