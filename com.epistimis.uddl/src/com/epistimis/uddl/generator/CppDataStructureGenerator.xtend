package com.epistimis.uddl.generator

import com.epistimis.uddl.uddl.PlatformAssociation
import com.epistimis.uddl.uddl.PlatformComposableElement
import com.epistimis.uddl.uddl.PlatformEntity
import java.util.Map
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGenerator2
import org.eclipse.xtext.generator.IGeneratorContext
import java.util.HashMap

class CppDataStructureGenerator implements IGenerator2 {

	Map<PlatformComposableElement,RealizedComposableElement> allComposableElements;

	new(Map<PlatformComposableElement,RealizedComposableElement> ace) {
		allComposableElements = ace;
	}
	
	new() {
		allComposableElements = new HashMap();
	}

	override afterGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context) {
	//	throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override beforeGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context) {
	//	throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override doGenerate(Resource input, IFileSystemAccess2 fsa, IGeneratorContext context) {
		for (PlatformComposableElement rce: allComposableElements.keySet) {
			if (rce instanceof PlatformEntity) {
				val re = rce as PlatformEntity;
				fsa.generateFile("cpp/" + re.name + ".cpp",re.compile)
			}
		}

	}

/**
 * NOTE: Need to handle attribute cardinality in a general way - 2 parts of this: determining cardinality and then rendering.
 * Determining cardinality should be language independent.
 */

	def compile(PlatformEntity entity) {
		'''
		/* «entity.description» */
		class «entity.name» «IF entity.specializes !== null » : «entity.specializes» «ENDIF» {
			«FOR composition: entity.composition»
			private «composition.type.name» «composition.rolename»«IF composition.upperBound > 1»[«composition.upperBound»]«ENDIF»; // «composition.description»
			«ENDFOR»
		};
		'''
	}

	def compile(PlatformAssociation entity) {
		'''
		/* «entity.description» */
		class «entity.name» «IF entity.specializes !== null» : «entity.specializes» «ENDIF» {
			«FOR composition: entity.composition»
			private «composition.type.name» «composition.rolename»«IF composition.upperBound > 1»[«composition.upperBound»]«ENDIF»; // «composition.description»
			«ENDFOR»
			«FOR participant: entity.participant»
			private «participant.type.name» «participant.rolename»«IF participant.upperBound > 1»[«participant.upperBound»]«ENDIF»; // «participant.description»
			«ENDFOR»

		};
		'''
	}

}