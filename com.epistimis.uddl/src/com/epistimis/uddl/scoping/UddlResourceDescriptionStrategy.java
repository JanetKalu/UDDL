package com.epistimis.uddl.scoping;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.resource.IEObjectDescription;
import org.eclipse.xtext.resource.impl.DefaultResourceDescriptionStrategy;
import org.eclipse.xtext.util.IAcceptor;

import com.epistimis.uddl.uddl.ConceptualPathNode;
import com.epistimis.uddl.uddl.LogicalConstraint;
import com.epistimis.uddl.uddl.LogicalPathNode;
import com.epistimis.uddl.uddl.PlatformPathNode;
import com.google.inject.Singleton;

@Singleton
public class UddlResourceDescriptionStrategy extends DefaultResourceDescriptionStrategy {

	public UddlResourceDescriptionStrategy() {
		// TODO Auto-generated constructor stub
	}

	@Override 
	public boolean createEObjectDescriptions(EObject eObject, IAcceptor<IEObjectDescription> acceptor) {
		if ((eObject instanceof ConceptualPathNode) ||
				(eObject instanceof LogicalPathNode) ||
				(eObject instanceof PlatformPathNode) ||
				(eObject instanceof LogicalConstraint)  // ??
				)
		{
			// don't index contents of a block
			return false;
		} else
			return super.createEObjectDescriptions(eObject, acceptor);
	}
}
