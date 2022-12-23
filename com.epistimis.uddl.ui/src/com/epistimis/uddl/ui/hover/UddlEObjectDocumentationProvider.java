package com.epistimis.uddl.ui.hover;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider;

import com.epistimis.uddl.uddl.UddlElement;

/**
 * Basic hover: https://dietrich-it.de/xtext/2011/07/16/hover-support-in-xtext-2.0-tutorial/
 * @author stevehickman
 *
 */
public class UddlEObjectDocumentationProvider implements IEObjectDocumentationProvider {

	public UddlEObjectDocumentationProvider() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public String getDocumentation(EObject o) {
		if (o instanceof UddlElement) {
			return ((UddlElement)o).getDescription();
		}
		return null;
	}

}
