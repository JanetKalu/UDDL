package com.epistimis.uddl.generator

import com.epistimis.uddl.uddl.PlatformBoolean
import com.epistimis.uddl.uddl.PlatformBoundedString
import com.epistimis.uddl.uddl.PlatformChar
import com.epistimis.uddl.uddl.PlatformCharArray
import com.epistimis.uddl.uddl.PlatformDataType
import com.epistimis.uddl.uddl.PlatformDouble
import com.epistimis.uddl.uddl.PlatformFloat
import com.epistimis.uddl.uddl.PlatformInteger
import com.epistimis.uddl.uddl.PlatformLong
import com.epistimis.uddl.uddl.PlatformLongDouble
import com.epistimis.uddl.uddl.PlatformLongLong
import com.epistimis.uddl.uddl.PlatformShort
import com.epistimis.uddl.uddl.PlatformString
import com.epistimis.uddl.uddl.PlatformULong
import com.epistimis.uddl.uddl.PlatformULongLong
import com.epistimis.uddl.uddl.PlatformUShort
import com.epistimis.uddl.uddl.PlatformUnsignedInteger

/**
 * NOTE: Need to handle attribute cardinality in a general way - 2 parts of this: determining cardinality and then rendering.
 * Determining cardinality should be language independent.
 */
/**
 * This is the common portion of a data structure generator. It will be the base class for every data structure
 * generator for each language.
 */
class GoDataStructureGenerator extends CommonDataStructureGenerator {

	override String getRootDirectory() { return "go/"; }

	override String getFileExtension() { return ".go"; }

	/**
	 * TODO: Structured FDTs aren't currently supported 
	 */
	override dispatch String getTypeString(PlatformDataType pdt) {
		switch (pdt) {
			PlatformBoundedString:  "string"
			PlatformCharArray:  "["+pdt.length + "]byte"
			PlatformString :  	"string"
			PlatformBoolean :  	"bool"
			PlatformChar:  		"byte"
			PlatformFloat:  	"float32"
			PlatformDouble:  	"float64"
			PlatformLongDouble: "complex128"
			PlatformShort:  	"int16"
			PlatformLong:  		"int32"
			PlatformLongLong:  	"int64"
			PlatformUShort:  	"uint16"
			PlatformULong:  	"uint32"
			PlatformULongLong:  "uint64"
			// These two last because they are base classes
			PlatformUnsignedInteger:"uint" 
			PlatformInteger:  	"int"
			// TODO: Others not yet supported
			default: ""
		}
	}
	
	override String getImportPrefix() { return 'import "'; }

	override String getImportSuffix() { return '"\n'; }

	override String getTypeDefPrefix() { return "type"; }

	override String getNamespaceKwd() { return "namespace";}

	override String getClazzKwd() { return "type";}

	override String getSpecializesKwd() { return ":" ;}

	override String getCompositionVisibility() { return "private" ;}

}
