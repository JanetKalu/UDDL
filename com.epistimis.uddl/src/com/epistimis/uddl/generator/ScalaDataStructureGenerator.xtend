package com.epistimis.uddl.generator

import com.epistimis.uddl.uddl.PlatformBoolean
import com.epistimis.uddl.uddl.PlatformBoundedString
import com.epistimis.uddl.uddl.PlatformChar
import com.epistimis.uddl.uddl.PlatformCharArray
import com.epistimis.uddl.uddl.PlatformComposableElement
import com.epistimis.uddl.uddl.PlatformDataType
import com.epistimis.uddl.uddl.PlatformDouble
import com.epistimis.uddl.uddl.PlatformFloat
import com.epistimis.uddl.uddl.PlatformInteger
import com.epistimis.uddl.uddl.PlatformLong
import com.epistimis.uddl.uddl.PlatformLongLong
import com.epistimis.uddl.uddl.PlatformShort
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
class ScalaDataStructureGenerator extends CommonDataStructureGenerator {

	new(Map<PlatformComposableElement, RealizedComposableElement> ace) {
		super(ace);
	}

	new() {
		super();
		initialize();
	}

	override String getRootDirectory() { return "scala/"; }

	override String getWriteFileExtension() { return ".scala"; }
	override String getReadFileExtension() { return ".scala"; }

	/**
	 * TODO: Structured FDTs aren't currently supported 
	 */
	override String getPDTTypeString(PlatformDataType pdt) {
		switch (pdt) {
			PlatformBoundedString: "String"
			PlatformCharArray: "[" + pdt.length + "]Char"
			PlatformString: "String"
			PlatformBoolean: "Boolean"
			PlatformChar: "Char"
			PlatformFloat: "Float"
			PlatformDouble: "Double"
			// PlatformLongDouble: "complex128"
			PlatformShort: "Short"
			PlatformLong: "Int"
			PlatformLongLong: "Long"
			// PlatformUShort:  	"uint16"
			// PlatformULong:  	"uint32"
			// PlatformULongLong:  "uint64"
			// These two last because they are base classes
			// PlatformUnsignedInteger:"uint" 
			PlatformInteger: "Int"
			// TODO: Others not yet supported
			default: ""
		}
	}

	override String getImportPrefix() { return 'import '; }

	override String getImportSuffix() { return '.* \n'; }

	override String pdmHeader(PlatformDataModel pdm) {
		'''
			// Types from «qnp.getFullyQualifiedName(pdm)»
			package «qnp.getFullyQualifiedName(pdm)»:
			
		'''
	}

	override defNewType(PlatformDataType pdt) {
		'''
		«nDent(1)»opaque type «pdt.name»  = «pdt.getTypeString»
		«nDent(1)»object «pdt.name»:
		«nDent(1)»	def apply(i: «pdt.getTypeString»): «pdt.name» = i
		«nDent(1)»given Eql[«pdt.name», «pdt.name»] = Eql.derived
		
		'''
	}

	override String generateImportStatement(PlatformDataModel pdm, EObject ctx) {
		return getImportPrefix() + qnp.getFullyQualifiedName(pdm) + getImportSuffix();
	}

	override String generateImportStatement(PlatformEntity entType, EObject ctx) {
		return getImportPrefix() + qnp.getFullyQualifiedName(entType);
	}

	override String getTypeDefPrefix() { return "type"; }

	override String getNamespaceKwd() { return "object"; }

	override String getClazzKwd() { return "trait"; }

	override String getSpecializesKwd() { return "extends"; }

	override String getCompositionVisibility() { return "private"; }

	override String getFileHeader(PlatformEntity entity) {
		'''
			«multiLineCmtStart» 
			«entity.description» 
			«multiLineCmtEnd»		
		'''
	}

	override String compositionElement(PlatformComposition composition, int ndx) {
		'''
		«nDent(1)»«composition.rolename»: «IF composition.upperBound > 1»[«composition.type.genTypeName»]«ELSE»«composition.type.genTypeName»«ENDIF»   // «composition.description»
		'''
	}

	override String participantElement(PlatformParticipant participant, int ndx) {
		'''
		«nDent(1)»«participant.rolename»: «IF participant.upperBound > 1»[«participant.type.genTypeName»]«ELSE»«participant.type.genTypeName»«ENDIF»   // «participant.description»
		'''
	}

	override clazzDecl(PlatformEntity entity) '''
		«clazzKwd» «entity.name» «IF entity.specializes !== null» «specializesKwd» «entity.specializes» «ENDIF» :	
	'''

	override clazzEndDecl(PlatformEntity entity) '''

	'''

	override String genTypeName(PlatformComposableElement pce) '''«pce.name»'''

}
