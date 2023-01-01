package com.epistimis.uddl

import org.eclipse.emf.common.util.EList;

import com.epistimis.uddl.uddl.ConceptualAssociation;
import com.epistimis.uddl.uddl.ConceptualComposition;
import com.epistimis.uddl.uddl.ConceptualEntity;
import com.epistimis.uddl.uddl.ConceptualParticipant;
import com.epistimis.uddl.uddl.LogicalAssociation;
import com.epistimis.uddl.uddl.LogicalComposition;
import com.epistimis.uddl.uddl.LogicalEntity;
import com.epistimis.uddl.uddl.LogicalParticipant;
import com.epistimis.uddl.uddl.PlatformAssociation;
import com.epistimis.uddl.uddl.PlatformComposition;
import com.epistimis.uddl.uddl.PlatformEntity;
import com.epistimis.uddl.uddl.PlatformParticipant;
import com.epistimis.uddl.uddl.ConceptualQuery
import com.epistimis.uddl.uddl.LogicalQuery
import com.epistimis.uddl.uddl.PlatformQuery

/**
 * This is a set of methods that extract values from instances for use with templated methods
 * @author stevehickman
 *
 */
abstract class CLPExtractors {

	
	def dispatch static ConceptualEntity getSpecializes(ConceptualEntity ent) {
		return  ent.getSpecializes();
	}
	def dispatch static LogicalEntity getSpecializes(LogicalEntity ent) {
		return ent.getSpecializes();
	}
	def dispatch static PlatformEntity getSpecializes(PlatformEntity ent) {
		return ent.getSpecializes();
	}
	
	
	def dispatch static boolean isAssociation(ConceptualEntity ent) {
		return  (ent instanceof ConceptualAssociation);
	}
	def dispatch static boolean isAssociation(LogicalEntity ent) {
		return  (ent instanceof LogicalAssociation);
	}
	def dispatch static boolean isAssociation(PlatformEntity ent) {
		return  (ent instanceof PlatformAssociation);
	}

	def dispatch static ConceptualAssociation conv2Association(ConceptualEntity ent) {
		return ent as ConceptualAssociation;
	}	
	def dispatch static LogicalAssociation conv2Association(LogicalEntity ent) {
		return ent as LogicalAssociation;
	}
	def dispatch static PlatformAssociation conv2Association(PlatformEntity ent) {
		return  ent as PlatformAssociation;
	}

	def dispatch static EList<ConceptualComposition> getComposition(ConceptualEntity ent) {
		return ent.getComposition();
	}
	def dispatch static EList<LogicalComposition> getComposition(LogicalEntity ent) {
		return ent.getComposition();
	}
	def dispatch static EList<PlatformComposition> getComposition(PlatformEntity ent) {
		return ent.getComposition();
	}

	
	def dispatch static EList<ConceptualParticipant> getParticipant(ConceptualAssociation ent) {
		return ent.getParticipant();
	}
	def dispatch static EList<LogicalParticipant> getParticipant(LogicalAssociation ent) {
		return ent.getParticipant();
	}
	def dispatch static EList<PlatformParticipant> getParticipant(PlatformAssociation ent) {
		return ent.getParticipant();
	}

	def dispatch static String getSpecification(ConceptualQuery ent) {
		return ent.specification;
	}
	def dispatch static String getSpecification(LogicalQuery ent) {
		return ent.specification;
	}
	def dispatch static String getSpecification(PlatformQuery ent) {
		return ent.specification;
	}

	def dispatch static Class getClassForQuery(ConceptualQuery ent) {
		return typeof(ConceptualEntity);
	}
	def dispatch static Class getClassForQuery(LogicalQuery ent) {
		return typeof(LogicalEntity);
	}
	def dispatch static Class getClassForQuery(PlatformQuery ent) {
		return typeof(PlatformEntity);
	}

}
