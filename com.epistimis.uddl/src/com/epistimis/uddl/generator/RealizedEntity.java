package com.epistimis.uddl.generator;

import java.util.HashMap;
import java.util.Map;

import com.epistimis.uddl.uddl.PlatformComposition;
import com.epistimis.uddl.uddl.PlatformEntity;

public class RealizedEntity extends RealizedComposableElement {

	/**
	 * NOTE: (P/L/C) Composition element specialization is interpreted as follows:
	 * If a (P/L/C) Composition element specializes, it must specialize a Composition element from an Entity at the same (P/L/C)
	 * level.  Only realization can bring Compositions from C->L  or L->P.  Specialization also means that the specialized element
	 * is not inherited 'as is' - rather, the specialization overrides whatever would have been inherited.
	 *
	 * That means that the RealizedEntity must account for this when working through the hierarchy. To do that:
	 *
	 * 1) recursively walk up the realizes/specializes chains. These should be self consistent - a realizes-specializes path should arrive at the
	 * same place as a specializes-realizes path (e.g. Given PlatformEntity PE2 that specializes PlatformEntity PE1 and realizes LogicalEntity LE2,
	 * then LE2 must specialize LE1, and PE1 must realize LE1. ) If they are not self consistent, this is an error (these errors should be caught by
	 * the OCL - see logical.ocl and platform.ocl)
	 *
	 * 2) Once reaching the root PlatformEntity (the one that does not specialize anything), then realize all of its Composition elements.
	 *
	 * 3) Then recursively pop out of /work down the PlatformEntity specializes hierarchy. At each new level, override any Composition element
	 * realizations we already have if they are specialized at this level. Then add any new Composition elements found at this level that do not
	 * specialize.
	 *
	 * Once all the recursion is done, the PlatformEntity should be fully realized - except for the type.
	 *
	 * 4) Once all the PlatformEntities are realized, we can go back and link the type for each. This requires that we keep track of the
	 * original relationship between PlatformEntity and RealizedEntity.
	 */

	private String name;

	private String description;

	/**
	 * The key will be the rolename of the composition. If a specialization results in a change in rolename, then the entry will be
	 * removed from the old rolename and reinserted using the new rolename.
	 */
	private Map<String, RealizedComposition> composition;

	public static void realize(PlatformEntity pe) {
		new RealizedEntity(pe);
	}

	public RealizedEntity(PlatformEntity pe) {
		super(pe);
		composition = processSpecializationForCompositions(pe);
		this.name = pe.getName(); // Always has to have a name, so just do that
	}

	protected Map<String, RealizedComposition> processSpecializationForCompositions(PlatformEntity pe) {
		Map<String, RealizedComposition> compositionSoFar;
		/**
		 * First recurse if this is also specialized, the process locally. That allows locals to override anything
		 * inherited via specialization
		 */
		PlatformEntity specializedEntity = pe.getSpecializes();
		if (specializedEntity != null) {
			compositionSoFar = processSpecializationForCompositions(specializedEntity);
		} else {
			compositionSoFar = new HashMap<String, RealizedComposition>();
		}
		// Set the description here because it might not always have a value
		if (pe.getDescription().trim().length() > 0) {
			this.description = pe.getDescription();
		}
		return processLocalCompositions(pe,compositionSoFar);
	}

	protected Map<String, RealizedComposition> processLocalCompositions(PlatformEntity pe, Map<String, RealizedComposition> compositionSoFar) {

		Map<String,RealizedComposition> results = new HashMap<String, RealizedComposition>();
		for (PlatformComposition pc: pe.getComposition()) {
			RealizedComposition rc = null;
			PlatformComposition specializedComp = (PlatformComposition) pc.getSpecializes();
			if (specializedComp != null) {
				/** this is already in the map, find it by the rolename */
				 rc = compositionSoFar.remove(specializedComp.getRolename());
				/**
				 * By removing from the first list under the original rolename and inserting in the
				 * new results by the new rolename, we also address any change to the rolename that might
				 * occur as part of specialization.
				 */
					rc.update(pc, null);
			}
			else {
				/**
				 * It wasn't specializing anything, so create a new one
				 */
				 rc = new RealizedComposition(pc,null);
  			}
			results.put(pc.getRolename(), rc);

		}

		return results;
	}

	public Map<String, RealizedComposition> getComposition() {
		return composition;
	}

	public String getName() {
		return name;
	}

	public String getDescription() {
		return description;
	}

}
