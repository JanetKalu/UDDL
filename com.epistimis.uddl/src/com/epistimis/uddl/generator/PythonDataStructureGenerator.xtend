package com.epistimis.uddl.generator

import com.epistimis.uddl.uddl.PlatformBoolean
import com.epistimis.uddl.uddl.PlatformBoundedString
import com.epistimis.uddl.uddl.PlatformChar
import com.epistimis.uddl.uddl.PlatformCharArray
import com.epistimis.uddl.uddl.PlatformComposableElement
import com.epistimis.uddl.uddl.PlatformComposition
import com.epistimis.uddl.uddl.PlatformDataModel
import com.epistimis.uddl.uddl.PlatformDataType
import com.epistimis.uddl.uddl.PlatformDouble
import com.epistimis.uddl.uddl.PlatformEntity
import com.epistimis.uddl.uddl.PlatformFixed
import com.epistimis.uddl.uddl.PlatformFloat
import com.epistimis.uddl.uddl.PlatformInteger
import com.epistimis.uddl.uddl.PlatformParticipant
import com.epistimis.uddl.uddl.PlatformString
import java.util.Map
import org.eclipse.emf.ecore.EObject

/**
 * NOTE: Need to handle attribute cardinality in a general way - 2 parts of this: determining cardinality and then rendering.
 * Determining cardinality should be language independent.
 */
/**
 * This is the common portion of a data structure generator. It will be the base class for every data structure
 * generator for each language.
 */
class PythonDataStructureGenerator extends CommonDataStructureGenerator {

	new(Map<PlatformComposableElement,RealizedComposableElement> ace) {
		super(ace);
	}
	
	new() {
		super();
		initialize();
	}

	override String getRootDirectory() { return "python/"; }

	override String getWriteFileExtension() { return ".py"; }
	override String getReadFileExtension() { return ".py"; }

	override String getScopeStart() 	{ return ":";} 
	override String getScopeEnd() 		{ return ""; }
	override String getStructStart() 	{ return ":"; }
	override String getStructEnd() 		{ return "";}

	/**
	 * TODO: Structured FDTs aren't currently supported 
	 */
	override String getPDTTypeString(PlatformDataType pdt) {
		switch (pdt) {
			PlatformBoundedString:  "str"
			PlatformCharArray:  "bytearray("+pdt.length +")"
			PlatformString :  	"str"
			PlatformBoolean :  	"bool"
			PlatformChar:  		"bytes"
			PlatformFloat:  	"float"
			PlatformDouble:  	"float"
			//PlatformLongDouble: "complex128"
			//PlatformShort:  	"int16"
			//PlatformLong:  		"long"
			//PlatformLongLong:  	"int64"
			//PlatformUShort:  	"uint16"
			//PlatformULong:  	"uint32"
			//PlatformULongLong:  "uint64"
			PlatformFixed:		"int"
			// These two last because they are base classes
			//PlatformUnsignedInteger:"uint" 
			PlatformInteger:  	"int"
			// TODO: Others not yet supported
			default: ""
		}
	}
	
	override String pdmHeader(PlatformDataModel pdm) {
		'''
		from typing import NewType
		# Types from «qnp.getFullyQualifiedName(pdm)»

		'''	
	}

	override defNewType(PlatformDataType pdt) {
		'''
		«pdt.genTypeName» = NewType('«pdt.genTypeName»', «pdt.getTypeString»)
		'''	
	}

	
	override  String generateImportStatement(PlatformDataModel pdm, EObject ctx) {
		return "from " + pdm.name + " import *";
	}
	
	override  String generateImportStatement(PlatformEntity entType, EObject ctx) {
		return "import " + entType.genTypeName;
	}

	
	override String getImportPrefix() { return 'import "'; }

	override String getImportSuffix() { return '"\n'; }

	override String getTypeDefPrefix() { return "class"; }

	// TODO: class defs follow the syntax
	// class cName(baseClz):
	override String getNamespaceKwd() { return "namespace";}

	override String getClazzKwd() { return "class";}

	// TODO: Python inheritance is handled by parens containing base classess
	override String getSpecializesKwd() { return "<do not use>" ;}

	override String getCompositionVisibility() { return "" ;}

	override String getFileHeader(PlatformEntity entity) {
		'''
		# from model element «entity.fullyQualifiedName»
		#
		# «entity.description» 
		#
		
		from dataclasses import dataclass
		#from typing import List
		'''
	}
	override String compositionElement(PlatformComposition composition, int ndx) {
		'''
		«nDent(1)»«composition.rolename»: «IF composition.upperBound > 1»list[«composition.type.genTypeName»]«ELSE»«composition.type.genTypeName»«ENDIF»   # «composition.description»
		'''
	}
	override String participantElement(PlatformParticipant participant, int ndx) {
		'''
		«nDent(1)»«participant.rolename»: «IF participant.upperBound > 1»list[«participant.type.genTypeName»]«ELSE»«participant.type.genTypeName»«ENDIF»   # «participant.description»
		'''
	}

	override clazzDecl(PlatformEntity entity) '''
		
		
		@dataclass
		class «entity.name.toFirstUpper»«IF entity.specializes !== null»( «entity.specializes» )«ENDIF»:
			"""«entity.description»"""	
	'''
	
	override clazzEndDecl(PlatformEntity entity)''''''
	
	override String genTypeName(PlatformComposableElement pce)'''«pce.name.toFirstUpper»'''
	
}
