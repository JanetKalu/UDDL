package com.epistimis.uddl.generator;

import java.util.HashMap;
import java.util.Map;

import com.epistimis.uddl.uddl.PlatformComposition;
import com.epistimis.uddl.uddl.PlatformEntity;
import com.epistimis.uddl.uddl.PlatformParticipant;
import com.epistimis.uddl.uddl.PlatformAssociation;

public class RealizedAssociation extends RealizedEntity {

	/**
	 * The key will be the rolename of the participant. If a specialization results in a change in rolename, then the entry will be
	 * removed from the old rolename and reinserted using the new rolename.
	 */
	private Map<String, RealizedParticipant> participant;

	public RealizedAssociation(PlatformAssociation pa) {
		super(pa);

		participant = processSpecializationForParticipants(pa);

	}

	protected Map<String, RealizedParticipant> processSpecializationForParticipants(PlatformAssociation pa) {
		Map<String, RealizedParticipant> participantsSoFar;
		/**
		 * First recurse if this is also specialized, the process locally. That allows locals to override anything
		 * inherited via specialization
		 */
		PlatformEntity specializedEntity = pa.getSpecializes();
		if ((specializedEntity != null) && (specializedEntity instanceof PlatformAssociation)) {
			/**
			 * This assumes that once we inherit from PlatformAssociation, everything down the specialization hierarchy
			 * must also be a PlatformAssociation.
			 */
			participantsSoFar = processSpecializationForParticipants((PlatformAssociation)specializedEntity);
		} else {
			participantsSoFar = new HashMap<String, RealizedParticipant>();
		}
		return processLocalParticipants(pa,participantsSoFar);
	}

	protected Map<String, RealizedParticipant> processLocalParticipants(PlatformAssociation pe, Map<String, RealizedParticipant> participantsSoFar) {

		Map<String,RealizedParticipant> results = new HashMap<String, RealizedParticipant>();
		for (PlatformParticipant pc: pe.getParticipant()) {
			RealizedParticipant rp = null;
			PlatformComposition specializedComp = (PlatformComposition) pc.getSpecializes();
			if (specializedComp != null) {
				/** this is already in the map, find it by the rolename */
				 rp = participantsSoFar.remove(specializedComp.getRolename());
				/**
				 * By removing from the first list under the original rolename and inserting in the
				 * new results by the new rolename, we also address any change to the rolename that might
				 * occur as part of specialization.
				 */
					rp.update(pc, null);

			}
			else {
				/**
				 * It wasn't specializing anything, so create a new one
				 */
				rp = new RealizedParticipant(pc,null);
  			}
			results.put(pc.getRolename(), rp);

		}

		return results;
	}

	public Map<String, RealizedParticipant> getParticipant() {
		return participant;
	}

}
