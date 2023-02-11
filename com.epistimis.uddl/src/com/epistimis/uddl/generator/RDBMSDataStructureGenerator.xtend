package com.epistimis.uddl.generator

import com.epistimis.uddl.uddl.PlatformBoolean
import com.epistimis.uddl.uddl.PlatformBoundedString
import com.epistimis.uddl.uddl.PlatformChar
import com.epistimis.uddl.uddl.PlatformCharArray
import com.epistimis.uddl.uddl.PlatformDataType
import com.epistimis.uddl.uddl.PlatformDouble
import com.epistimis.uddl.uddl.PlatformFixed
import com.epistimis.uddl.uddl.PlatformFloat
import com.epistimis.uddl.uddl.PlatformInteger
import com.epistimis.uddl.uddl.PlatformShort
import com.epistimis.uddl.uddl.PlatformComposableElement
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
class RDBMSDataStructureGenerator extends CommonDataStructureGenerator {

	new(Map<PlatformComposableElement, RealizedComposableElement> ace) {
		super(ace);
	}

	new() {
		super();
		initialize();
	}

	override String getRootDirectory() { return "rdbms/"; }

	override String getWriteFileExtension() { return ".ddl"; }
	override String getReadFileExtension() { return ".ddl"; }

	/**
	 * TODO: Structured FDTs aren't currently supported 
	 */
	override String getPDTTypeString(PlatformDataType pdt) {
		switch (pdt) {
			PlatformBoundedString: "VARCHAR(" + pdt.maxLength + ")"
			PlatformCharArray: "VARCHAR(" + pdt.length + ")"
			// PlatformString :  	"string"
			PlatformBoolean: "BIT"
			PlatformChar: "CHAR"
			PlatformFloat: "FLOAT"
			PlatformDouble: "DOUBLE PRECISION"
			// PlatformLongDouble: "complex128"
			PlatformShort: "SMALLINT"
			// PlatformLong:  		"int32"
			// PlatformLongLong:  	"int64"
			// PlatformUShort:  	"uint16"
			// PlatformULong:  	"uint32"
			// PlatformULongLong:  "uint64"
			PlatformFixed: "DEC"
			// These two last because they are base classes
			// PlatformUnsignedInteger:"uint" 
			PlatformInteger: "INTEGER"
			// TODO: Others not yet supported
			default: ""
		}
	}

	override String getImportPrefix() { return '<import ">'; }

	override String getImportSuffix() { return '<"\n>'; }

	override String pdmHeader(PlatformDataModel pdm) {
		'''
			// Types from «qnp.getFullyQualifiedName(pdm)»
		'''
	}

	override defNewType(PlatformDataType pdt) {
		'''
			<type> «pdt.getTypeString» «pdt.name» ;
		'''
	}

	override String generateImportStatement(PlatformDataModel pdm, EObject ctx) {
		return getImportPrefix() + pdm.generateWriteFileName + getImportSuffix();
	}

	override String generateImportStatement(PlatformEntity entType, EObject ctx) {
		return getImportPrefix() + entType.generateWriteFileName + getImportSuffix();
	}

	override String getTypeDefPrefix() { return "<type>"; }

	override String getNamespaceKwd() { return "<namespace>"; }

	override String getClazzKwd() { return "CREATE TABLE"; }

	override String getSpecializesKwd() { return "<:>"; }

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
			«compositionVisibility» «composition.type.name» «composition.rolename»«IF composition.upperBound > 1»«arrStart»«composition.upperBound»«arrEnd»«ENDIF»«elemEnd» «singleLineCmtStart» «composition.description»
		'''
	}

	override String participantElement(PlatformParticipant participant, int ndx) {
		'''
			«compositionVisibility» «participant.type.name» «participant.rolename»«IF participant.upperBound > 1»«arrStart»«participant.upperBound»«arrEnd»«ENDIF»«elemEnd» «singleLineCmtStart» «participant.description»
		'''
	}

	override clazzDecl(PlatformEntity entity) '''
		«clazzKwd» «entity.name» «IF entity.specializes !== null» «specializesKwd» «entity.specializes» «ENDIF» «structStart»	
	'''

	override clazzEndDecl(PlatformEntity entity) '''
		};
	'''

	override String genTypeName(PlatformComposableElement pce) '''«pce.name»'''

	override String getStructStart() { return "("; }

	override String getStructEnd() { return ");"; }

}
