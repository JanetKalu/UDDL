package com.epistimis.uddl.generator;

import com.epistimis.uddl.uddl.PlatformComposition;

public class RealizedComposition extends RealizedCharacteristic {

	/**
	 * The max precision - use this to define a rounding function for this composition?
	 */
	private float precision;


	public RealizedComposition(String rolename) {
		super(rolename);
		// TODO Auto-generated constructor stub
		this.precision = 1;

	}

	public RealizedComposition(PlatformComposition pc, RealizedComposableElement rce) {
		super(pc, rce);
		// TODO Auto-generated constructor stub
		this.precision = pc.getPrecision();

	}

	public void update(PlatformComposition pc, RealizedComposableElement rce) {
		super.update(pc, rce);


		if (pc.getPrecision()  > this.precision) {
			this.precision = pc.getPrecision();
		}

	}


}
