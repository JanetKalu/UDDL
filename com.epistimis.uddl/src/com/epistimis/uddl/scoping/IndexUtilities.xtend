package com.epistimis.uddl.scoping

import com.google.inject.Inject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.resource.IContainer
import org.eclipse.xtext.resource.impl.ResourceDescriptionsProvider
import com.epistimis.uddl.uddl.UddlPackage

/**
 * This is modified from the book (See https://github.com/LorenzoBettini/packtpub-xtext-book-2nd-examples)
 * Smalljava = SmallJavaIndex.xtend
 */

class IndexUtilities {
	@Inject ResourceDescriptionsProvider rdp
	@Inject IContainer.Manager cm


	def getVisibleEObjectDescriptions(EObject o, EClass type) {
		o.getVisibleContainers.map [ container |
			container.getExportedObjectsByType(type)
		].flatten
	}

	def getVisibleContainers(EObject o) {
		val index = rdp.getResourceDescriptions(o.eResource)
		val rd = index.getResourceDescription(o.eResource.URI)
		cm.getVisibleContainers(rd, index)
	}

	def getResourceDescription(EObject o) {
		val index = rdp.getResourceDescriptions(o.eResource)
		index.getResourceDescription(o.eResource.URI)
	}

	def getExportedEObjectDescriptions(EObject o) {
		o.getResourceDescription.getExportedObjects
	}

	def getExportedEObjectDescriptionsByType(EObject o, EClass type) {
		o.getResourceDescription.getExportedObjectsByType(type)
	}

	def getVisibleExternalEObjectDescriptionsByType(EObject o, EClass type) {
		val allVisibleEObjectDescriptions =
			o.getVisibleEObjectDescriptions(type)
		val allExportedEObjectDescriptions =
			o.getExportedEObjectDescriptionsByType(type)
		val difference = allVisibleEObjectDescriptions.toSet
		difference.removeAll(allExportedEObjectDescriptions.toSet)
		return difference.toMap[qualifiedName]
	}
	
	
	
	/**
	 * These methods are specific to this package
	 */
	def getVisibleDataModelDescriptions(EObject o) {
		o.getVisibleEObjectDescriptions(UddlPackage.eINSTANCE.dataModel)
	}

	def getExportedDataModelEObjectDescriptions(EObject o) {
		o.getResourceDescription.getExportedObjectsByType(UddlPackage.eINSTANCE.dataModel)
	}
	def getVisibleExternalDataModelDescriptions(EObject o) {
		o.getVisibleExternalEObjectDescriptionsByType(UddlPackage.eINSTANCE.dataModel)
	}
/*	
 * The original version of this method is below. This was recoded to use the general
 * implementation to make any maintenance simpler.
 */
 
 /*
	def getVisibleExternalClassesDescriptions(EObject o) {
		val allVisibleClasses =
			o.getVisibleClassesDescriptions
		val allExportedClasses =
			o.getExportedClassesEObjectDescriptions
		val difference = allVisibleClasses.toSet
		difference.removeAll(allExportedClasses.toSet)
		return difference.toMap[qualifiedName]
	}
 */	

}
