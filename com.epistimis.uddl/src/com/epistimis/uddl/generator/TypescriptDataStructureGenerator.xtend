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

/**
 * NOTE: Need to handle attribute cardinality in a general way - 2 parts of this: determining cardinality and then rendering.
 * Determining cardinality should be language independent.
 */
/**
 * This is the common portion of a data structure generator. It will be the base class for every data structure
 * generator for each language.
 */
class TypescriptDataStructureGenerator extends CommonDataStructureGenerator {

	new(Map<PlatformComposableElement,RealizedComposableElement> ace) {
		super(ace);
	}
	
	new() {
		super();
		initialize();
	}

	override String getRootDirectory() { return "typescript/"; }

	override String getFileExtension() { return ".ts"; }

	/**
	 * TODO: Structured FDTs aren't currently supported 
	 */
	override String getPDTTypeString(PlatformDataType pdt) {
		switch (pdt) {
			PlatformBoundedString:  "string"
			PlatformCharArray:  "string"
			PlatformString :  	"string"
			PlatformBoolean :  	"boolean"
			PlatformChar:  		"string"
			PlatformNumber: 	"number"
			// TODO: Others not yet supported
			default: ""
		}
	}
	
	override String getImportPrefix() { return 'import "'; }

	override String getImportSuffix() { return '"\n'; }

	override String getTypeDefPrefix() { return "type"; }

	override String getNamespaceKwd() { return "namespace";}

	override String getClazzKwd() { return "class";}

	override String getSpecializesKwd() { return "extends" ;}

	override String getCompositionVisibility() { return "private" ;}

}
