package com.epistimis.uddl.generator;

import com.epistimis.uddl.uddl.PlatformParticipant;

public class RealizedParticipant extends RealizedCharacteristic {

	private int sourceLowerBound;

	private int sourceUpperBound;

	public RealizedParticipant(String rolename) {
		super(rolename);
		// TODO Auto-generated constructor stub
		sourceLowerBound = 1;
		sourceUpperBound = 1;
	}
	public RealizedParticipant(PlatformParticipant pp, RealizedComposableElement rce) {
		super(pp,rce);
		sourceLowerBound = pp.getSourceLowerBound();
		sourceUpperBound = pp.getSourceUpperBound();
	}
	public int getSourceLowerBound() {
		return sourceLowerBound;
	}
	public int getSourceUpperBound() {
		return sourceUpperBound;
	}

}
