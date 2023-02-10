package com.epistimis.uddl.generator

import com.epistimis.uddl.uddl.PlatformAssociation
import com.epistimis.uddl.uddl.PlatformBoolean
import com.epistimis.uddl.uddl.PlatformBoundedString
import com.epistimis.uddl.uddl.PlatformCharArray
import com.epistimis.uddl.uddl.PlatformComposableElement
import com.epistimis.uddl.uddl.PlatformDataModel
import com.epistimis.uddl.uddl.PlatformDataType
import com.epistimis.uddl.uddl.PlatformDouble
import com.epistimis.uddl.uddl.PlatformEntity
import com.epistimis.uddl.uddl.PlatformFixed
import com.epistimis.uddl.uddl.PlatformFloat
import com.epistimis.uddl.uddl.PlatformInteger
import com.epistimis.uddl.uddl.PlatformLong
import com.epistimis.uddl.uddl.PlatformString
import com.epistimis.uddl.uddl.PlatformULong
import com.epistimis.uddl.uddl.PlatformUnsignedInteger
import java.util.ArrayList
import java.util.List
import java.util.Map
import com.epistimis.uddl.uddl.PlatformComposition
import com.epistimis.uddl.uddl.PlatformParticipant

/**
 * NOTE: Need to handle attribute cardinality in a general way - 2 parts of this: determining cardinality and then rendering.
 * Determining cardinality should be language independent.
 */
/**
 * This is the common portion of a data structure generator. It will be the base class for every data structure
 * generator for each language.
 */
class ProtobufDataStructureGenerator extends CommonDataStructureGenerator {

	new(Map<PlatformComposableElement, RealizedComposableElement> ace) {
		super(ace);
	}

	new() {
		super();
		initialize();
	}

	override String getRootDirectory() { return "protobuf/"; }

	override String getFileExtension() { return ".proto"; }

	/**
	 * TODO: Structured FDTs aren't currently supported 
	 */
	override String getPDTTypeString(PlatformDataType pdt) {
		switch (pdt) {
			PlatformBoundedString: "string"
			PlatformCharArray: "[" + pdt.length + "]bytes"
			PlatformString: "string"
			PlatformBoolean: "bool"
			// PlatformChar:  		"Char"
			PlatformFloat: "float"
			PlatformDouble: "double"
			// PlatformLongDouble: "complex128"
			// PlatformShort:  	"Short"
			PlatformLong: "int64"
			// PlatformLongLong:  	"Long"
			// PlatformUShort:  	"uint16"
			PlatformULong: "uint64"
			// PlatformULongLong:  "uint128"
			PlatformFixed: "fixed32"
			// These two last because they are base classes
			PlatformUnsignedInteger: "uint32"
			PlatformInteger: "int32"
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
			message «pdt.getTypeString» «pdt.name» ;
		'''
	}

	override String generateImportStatement(PlatformDataModel pdm) {
		return getImportPrefix() + pdm.generateFileName + getImportSuffix();
	}

	override String generateImportStatement(PlatformEntity entType) {
		return getImportPrefix() + entType.generateFileName + getImportSuffix();
	}

	override String getTypeDefPrefix() { return "message"; }

	override String getNamespaceKwd() { return "package"; }

	override String getClazzKwd() { return "message"; }

	override String getSpecializesKwd() { return "extends"; }

	override String getCompositionVisibility() { return "private"; }

	override String getFileHeader(PlatformEntity entity) {
		'''
			syntax = "proto3";
			«multiLineCmtStart» 
			«entity.description» 
			«multiLineCmtEnd»		
		'''
	}

	override String compositionElement(PlatformComposition composition, int ndx) {
		// ndx is zero based but protobuf needs 1 based 
		'''
			«IF composition.upperBound > 1»repeated «ENDIF»«compositionVisibility» «composition.type.name» «composition.rolename» = «ndx+1»«elemEnd» «singleLineCmtStart» «composition.description»
		'''
	}

	override String participantElement(PlatformParticipant participant, int ndx) {
		// ndx is zero based but protobuf needs 1 based 
		'''
			«IF participant.upperBound > 1»repeated «ENDIF»«compositionVisibility» «participant.type.name» «participant.rolename» = «ndx+1»«elemEnd» «singleLineCmtStart» «participant.description»
		'''
	}

	override String getStructEnd() { return "}"; }

	override compile(PlatformEntity entity) {
		'''
			«entity.fileHeader»
			«var entityIncludes = new ArrayList<PlatformEntity>»
			«var List<PlatformDataModel> pdmIncludes = new ArrayList<PlatformDataModel>»
			«FOR composition : entity.composition»
				«composition.type.generateInclude(pdmIncludes, entityIncludes)»
			«ENDFOR»
			«IF entity.specializes !== null »
				«entity.specializes.generateInclude(pdmIncludes,entityIncludes)»
			«ENDIF»
			«var ndx = 0»
			«clazzKwd» «entity.name» «IF entity.specializes !== null » «specializesKwd» «entity.specializes» «ENDIF» «structStart»
				«FOR composition : entity.composition»
					«composition.compositionElement(ndx)»
					«ndx++»
				«ENDFOR»
			«structEnd»
		'''
	}

	override compile(PlatformAssociation entity) {
		'''
			«entity.fileHeader»
			«var entityIncludes = new ArrayList<PlatformEntity>»
			«var List<PlatformDataModel> pdmIncludes = new ArrayList<PlatformDataModel>»
			«FOR composition : entity.composition»
				«composition.type.generateInclude(pdmIncludes, entityIncludes)»
			«ENDFOR»
			«FOR participant : entity.participant»
				«participant.type.generateInclude(pdmIncludes, entityIncludes)»
			«ENDFOR»
			«IF entity.specializes !== null »
				«entity.specializes.generateInclude(pdmIncludes,entityIncludes)»
			«ENDIF»
			«var ndx = 0»
			«clazzKwd» «entity.name» «IF entity.specializes !== null» «specializesKwd» «entity.specializes» «ENDIF» «structStart»
				«FOR composition : entity.composition»
					«composition.compositionElement(ndx)»
					«ndx++»
				«ENDFOR»
				«FOR participant : entity.participant»
					«participant.participantElement(ndx)»
					«ndx++»
				«ENDFOR»
			
			«structEnd»
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
