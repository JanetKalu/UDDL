/*
 * generated by Xtext 2.28.0
 */
package com.epistimis.uddl.formatting2;

import com.epistimis.uddl.uddl.ConceptualDataModel;
import com.epistimis.uddl.uddl.ConceptualElement;
import com.epistimis.uddl.uddl.DataModel;
import com.epistimis.uddl.uddl.LogicalDataModel;
import com.epistimis.uddl.uddl.PlatformDataModel;
import org.eclipse.xtext.formatting2.AbstractJavaFormatter;
import org.eclipse.xtext.formatting2.IFormattableDocument;

public class UddlFormatter extends AbstractJavaFormatter {
	
	/**
	 * Several standard methods needed for formatting
	 * 1) All objects will have 
	 * 		A) '{' and '};' on a newline. 
	 * 		B) All content inside the '{' and '}' will be indented one tab
	 * 
	 * NOTES: Because we don't know the structure of the object, we don't know how to format its
	 * content. So we format the open and close separately
	 * 
	 * 2) '{' and '}' for scoping means
	 * 		A) all content indented one tab further
	 * 		B) '{' on newline after name/description of scope
	 * 
	 * 3) '[' and ']' for lists means
	 * 		A) all list content have 1 space between
	 * 		B) '[', ']' and content all on the same line
	 * 
	 * 
	 */
	protected <O> void formatObjOpen(O obj, IFormattableDocument doc) {
		
	}
	protected <O> void formatObjClose(O obj, IFormattableDocument doc) {
		
	}
	
	protected <L> void formatList(L list, IFormattableDocument doc) {
		
	}

	protected  <C> void formatContainer(C container, IFormattableDocument doc) {
		
	}
	
	protected void format(DataModel dataModel, IFormattableDocument doc) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		for (ConceptualDataModel conceptualDataModel : dataModel.getCdm()) {
			doc.format(conceptualDataModel);
		}
		for (LogicalDataModel logicalDataModel : dataModel.getLdm()) {
			doc.format(logicalDataModel);
		}
		for (PlatformDataModel platformDataModel : dataModel.getPdm()) {
			doc.format(platformDataModel);
		}
	}

	protected void format(ConceptualDataModel conceptualDataModel, IFormattableDocument doc) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		for (ConceptualElement conceptualElement : conceptualDataModel.getElement()) {
			doc.format(conceptualElement);
		}
		for (ConceptualDataModel _conceptualDataModel : conceptualDataModel.getCdm()) {
			doc.format(_conceptualDataModel);
		}
	}
	
	// TODO: implement for LogicalDataModel, PlatformDataModel, ConceptualEntity, ConceptualAssociation, ConceptualParticipant, ConceptualParticipantPathNode, ConceptualCharacteristicPathNode, ConceptualCompositeQuery, LogicalMeasurementSystem, LogicalMeasurementSystemAxis, LogicalReferencePoint, LogicalValueTypeUnit, LogicalMeasurement, LogicalEntity, LogicalAssociation, LogicalParticipant, LogicalParticipantPathNode, LogicalCharacteristicPathNode, LogicalCompositeQuery, PlatformStruct, PlatformEntity, PlatformAssociation, PlatformParticipant, PlatformParticipantPathNode, PlatformCharacteristicPathNode, PlatformCompositeQuery
}
