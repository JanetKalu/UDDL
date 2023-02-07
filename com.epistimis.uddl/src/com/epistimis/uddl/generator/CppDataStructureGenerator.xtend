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
import java.util.Map
import com.epistimis.uddl.uddl.PlatformComposableElement

/**
 * NOTE: Need to handle attribute cardinality in a general way - 2 parts of this: determining cardinality and then rendering.
 * Determining cardinality should be language independent.
 */
/**
 * This is the common portion of a data structure generator. It will be the base class for every data structure
 * generator for each language.
 */
class CppDataStructureGenerator extends CommonDataStructureGenerator {

	new(Map<PlatformComposableElement,RealizedComposableElement> ace) {
		super(ace);
	}
	
	new() {
		super();
		initialize();
	}

	override String getRootDirectory() { return "cpp/"; }

	override String getFileExtension() { return ".hpp"; }

	/**
	 * TODO: Structured FDTs aren't currently supported 
	 * dispatch methods can't be abstract - so force override
	 */
	override String getPDTTypeString(PlatformDataType pdt) {
		switch (pdt) {
			PlatformBoundedString: "string"
			PlatformCharArray: "char[" + pdt.length + "]"
			PlatformString: "string"
			PlatformBoolean: "bool"
			PlatformChar: "char"
			PlatformFloat: "float"
			PlatformDouble: "double"
			PlatformLongDouble: "long double"
			PlatformShort: "short"
			PlatformLong: "long"
			PlatformLongLong: "long long"
			PlatformUShort: "unsigned short"
			PlatformULong: "unsigned long"
			PlatformULongLong: "unsigned long long"
			// These two last because they are base classes
			PlatformUnsignedInteger: "unsigned int"
			PlatformInteger: "int"
			// TODO: Others not yet supported
			default: ""
		}
	}

	override String getImportPrefix() { return "#include '"; }

	override String getImportSuffix() { return "'\n"; }

	override String getTypeDefPrefix() { return "typedef"; }

	override String getNamespaceKwd() { return "namespace";}

	override String getClazzKwd() { return "class";}

	override String getSpecializesKwd() { return ":" ;}

	override String getCompositionVisibility() { return "private" ;}


	
}
