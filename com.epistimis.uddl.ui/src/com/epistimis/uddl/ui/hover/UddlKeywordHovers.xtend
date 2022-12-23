package com.epistimis.uddl.ui.hover

/**
 * From blog post
 * https://blogs.itemis.com/en/xtext-usability-hovers-on-keywords
 * 
 * Just update this file with keyword hover text. 
 */
import com.google.inject.Inject
import com.epistimis.uddl.services.UddlGrammarAccess
import org.eclipse.xtext.Keyword

class UddlKeywordHovers {
	@Inject UddlGrammarAccess ga;
	
	def hoverText(Keyword k) {
		
		val result = switch(k) {
			case ga.dataModelAccess.dmKeyword_0: '''
				A DataModel is a container for ConceptualDataModels, LogicalDataModels, and PlatformDataModels
				'''
			case ga.conceptualDataModelAccess.cdmKeyword_0: '''
				A ConceptualDataModel is a container for CDM Elements (including nested CDMs).
				'''
			case ga.logicalDataModelAccess.ldmKeyword_0: '''
				A LogicalDataModel is a container for LDM Elements (including nested LDMs).
				'''
			case ga.platformDataModelAccess.pdmKeyword_0: '''
				A PlatformDataModel is a container for PDM Elements (including nested PDMs).
				'''
		}
		
		result.toString;
	}
}