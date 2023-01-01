package com.epistimis.uddl;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;

/**
 * Some general utilities from the Advanced XText Manual PDF
 * @author stevehickman
 *
 */
class ResourceUtils {
	public static EObject resourceToEObject(Resource resource) {
		if (resource == null)
			return null;
		else if (resource.getAllContents() == null)
			return null;
		else
			return resource.getAllContents().next();
	}

	public static Resource openImport(Resource currentResource, String importedURIAsString) {

		URI currentURI = currentResource == null? null : currentResource.getURI();
		URI importedURI = URI.createURI(importedURIAsString); 
		URI resolvedURI = importedURI == null? null: importedURI.resolve(currentURI);
		ResourceSet currentResourceSet = currentResource == null? null: currentResource.getResourceSet(); 
		Resource resource = currentResourceSet == null? null : currentResourceSet.getResource(resolvedURI,true);

		return resource;
	}
}
