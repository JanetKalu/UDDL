package com.epistimis.uddl.generator;

import com.epistimis.uddl.uddl.PlatformCharacteristic;
import com.epistimis.uddl.uddl.PlatformComposableElement;

public class RealizedCharacteristic {
	/**
	 * NOTE: (P/L/C) Composition element specialization is interpreted as follows:
	 * If a (P/L/C) Composition element specializes, it must specialize a Composition element from an Entity at the same (P/L/C)
	 * level.  Only realization can bring Compositions from C->L  or L->P.  Specialization also means that the specialized element
	 * is not inherited 'as is' - rather, the specialization overrides whatever would have been inherited.
	 */

	/**
	 * Use the lowest level rolename (Platform)
	 */
	private String rolename;

	/**
	 * The description
	 */
	private String description;
	/**
	 * The lower bound cardinality
	 */
	private int lowerBound;
	/**
	 * The upper bound cardinality. -1 means unbounded.
	 */
	private int upperBound;

	/**
	 * Track the original type because we need this later to do linkage
	 */
	private PlatformComposableElement type;

	/**
	 * The realizedType of this composition Element
	 */
	private RealizedComposableElement realizedType;

	public RealizedCharacteristic(String rolename) {
		this.rolename = rolename;
		this.lowerBound = 1;
		this.upperBound = 1;
	}

	public RealizedCharacteristic(PlatformCharacteristic pc, RealizedComposableElement rce) {
		this.rolename = pc.getRolename();
		this.description= pc.getDescription();
		this.lowerBound = pc.getLowerBound();
		this.upperBound = pc.getUpperBound();
		this.realizedType = rce;
	}

	/**
	 * Call this method to update this instance based on information from the passed in
	 * PlatformComposition
	 * @param pc
	 */
	public void update(PlatformCharacteristic pc, RealizedComposableElement rce) {
		/**
		 * Allowed updates:
		 * 1) rolename can change - but can't become empty
		 * 2) description: can change - but can't be emptied if it was previously nonempty
		 * 3) bounds can be no looser - but they can be more restricted
		 * 4) precision cannot be made better?
		 */
		if (pc.getRolename().trim().length() > 0) {
			this.rolename = pc.getRolename();
		}
		if (pc.getDescription().trim().length() > 0) {
			this.description = pc.getDescription();
		}
		if (pc.getLowerBound() > this.lowerBound) {
			this.lowerBound = pc.getLowerBound();
		}
		/**
		 * If the updating upper bound is unbounded, then it can't narrow the
		 * existing definition, so go no further
		 */
		if (pc.getUpperBound() != -1) {
			if ((this.upperBound == -1) || (pc.getUpperBound() < this.upperBound)) {
				this.upperBound = pc.getUpperBound();
			}
		}

		if (rce != null) {
			this.realizedType = rce;
		}

	}

	public PlatformComposableElement getType() {
		return this.type;
	}

	public RealizedComposableElement getRealizeType() {
		return this.realizedType;
	}

	public void setRealizedType(RealizedComposableElement rce) {
		this.realizedType = rce;
	}

	public String getDescription() {
		return description;
	}

	public String getRolename() {
		return rolename;
	}
}
/*
 * ConceptualComposition:
	realizedType=[ConceptualComposableElement|QN]  rolename=ID '[' (lowerBound=INT)? ':' (upperBound=INT)? ']' (description=STRING)? ':' (specializes=[ConceptualCharacteristic|QN])? ';'
;
 */
/*
 *
LogicalComposition:
	realizedType=[LogicalComposableElement|QN]  rolename=ID '[' lowerBound=INT ':' upperBound=INT ']' (description=STRING)? (':' specializes=[LogicalCharacteristic|QN])?  '->' realizes=[ConceptualComposition|QN]
;
 */
/*
PlatformComposition:
realizedType=[PlatformComposableElement|QN]  rolename=ID '[' lowerBound=INT ':' upperBound=INT ']' (description=STRING)? (':' specializes=[PlatformCharacteristic|QN])?  '->' realizes=[LogicalComposition|QN]
	'{'
		'prec:' precision=FLOAT
	'}'';'
;
*/