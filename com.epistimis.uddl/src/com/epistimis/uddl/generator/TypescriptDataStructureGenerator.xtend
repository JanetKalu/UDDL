package com.epistimis.uddl.generator

import com.epistimis.uddl.uddl.PlatformBoolean
import com.epistimis.uddl.uddl.PlatformBoundedString
import com.epistimis.uddl.uddl.PlatformChar
import com.epistimis.uddl.uddl.PlatformCharArray
import com.epistimis.uddl.uddl.PlatformComposableElement
import com.epistimis.uddl.uddl.PlatformDataType
import com.epistimis.uddl.uddl.PlatformNumber
import com.epistimis.uddl.uddl.PlatformString
import java.util.Map
import com.epistimis.uddl.uddl.PlatformDataModel
import com.epistimis.uddl.uddl.PlatformEntity
import com.epistimis.uddl.uddl.PlatformComposition
import com.epistimis.uddl.uddl.PlatformParticipant
import org.eclipse.emf.ecore.EObject

/**
 * NOTE: Need to handle attribute cardinality in a general way - 2 parts of this: determining cardinality and then rendering.
 * Determining cardinality should be language independent.
 */
/**
 * This is the common portion of a data structure generator. It will be the base class for every data structure
 * generator for each language.
 */
class TypescriptDataStructureGenerator extends CommonDataStructureGenerator {

	new(Map<PlatformComposableElement, RealizedComposableElement> ace) {
		super(ace);
	}

	new() {
		super();
		initialize();
	}

	override String getRootDirectory() { return "typescript/"; }

	override String getWriteFileExtension() { return ".ts"; }

	override String getReadFileExtension() { return ".js"; }

	/**
	 * TODO: Structured FDTs aren't currently supported 
	 */
	override String getPDTTypeString(PlatformDataType pdt) {
		switch (pdt) {
			PlatformBoundedString: "string"
			PlatformCharArray: "string"
			PlatformString: "string"
			PlatformBoolean: "boolean"
			PlatformChar: "string"
			PlatformNumber: "number"
			// TODO: Others not yet supported
			default: ""
		}
	}

	override String getImportPrefix() { return 'import "'; }

	override String getImportSuffix() { return '"\n'; }

	override String pdmHeader(PlatformDataModel pdm) {
		'''
			// Types from «qnp.getFullyQualifiedName(pdm)»
		'''
	}

	override defNewType(PlatformDataType pdt) {
		'''
			export type «pdt.name» = «pdt.getTypeString» ;
		'''
	}

	override String generateImportStatement(PlatformDataModel pdm, EObject ctx) {
		/**
		 * Note that this imports everything even if it isn't all used. This is the simple approach for now.
		 */
		val pdts = pdm.eContents.filter(PlatformDataType);
		'''
			«FOR pdt : pdts BEFORE 'import { ' SEPARATOR ', ' AFTER ' }'»«pdt.genTypeName»«ENDFOR» from "«pdm.generateRelativeReadFileName(ctx)»";
		'''
	}

	override String generateImportStatement(PlatformEntity entType, EObject ctx) {
		'''import {«entType.genTypeName»} from "«entType.generateRelativeReadFileName(ctx)»"'''
//		return getImportPrefix() + entType.generateRelativeReadFileName(ctx) + getImportSuffix();
	}

	override String getTypeDefPrefix() { return "type"; }

	override String getNamespaceKwd() { return "namespace"; }

	override String getClazzKwd() { return "interface"; }

	override String getSpecializesKwd() { return "extends"; }

	override String getCompositionVisibility() { return ""; }

	override String getFileHeader(PlatformEntity entity) {
		'''
			«multiLineCmtStart» 
			«entity.description» 
			«multiLineCmtEnd»		
		'''
	}

	override String compositionElement(PlatformComposition composition, int ndx) {
		'''
			«nDent(1)»«getCompositionVisibility» «composition.rolename»: «IF composition.upperBound > 1»«composition.type.genTypeName»[]«ELSE»«composition.type.genTypeName»«ENDIF»;   // «composition.description»
		'''
	}

	override String participantElement(PlatformParticipant participant, int ndx) {
		'''
			«nDent(1)»«getCompositionVisibility» «participant.rolename»: «IF participant.upperBound > 1»«participant.type.genTypeName»[]«ELSE»«participant.type.genTypeName»«ENDIF»;   // «participant.description»
		'''
	}

	override clazzDecl(PlatformEntity entity) '''
		«clazzKwd» «entity.name» «IF entity.specializes !== null» «specializesKwd» «entity.specializes» «ENDIF» «structStart»	
	'''

	override clazzEndDecl(PlatformEntity entity) '''
		};
	'''

	override String genTypeName(PlatformComposableElement pce) '''«pce.name»'''

}
