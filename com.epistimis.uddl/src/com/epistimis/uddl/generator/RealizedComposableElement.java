package com.epistimis.uddl.generator;


import java.util.HashMap;
import java.util.Map;

import com.epistimis.uddl.uddl.PlatformComposableElement;
import com.epistimis.uddl.uddl.PlatformComposition;
import com.epistimis.uddl.uddl.PlatformEntity;


public class RealizedComposableElement {

	private static Map<PlatformComposableElement,RealizedComposableElement> allComposableElements = new HashMap();

	public RealizedComposableElement(PlatformComposableElement pce) {
		allComposableElements.put(pce, this);
	}

	public static void linkTypes() {
		for (Map.Entry<PlatformComposableElement, RealizedComposableElement> entry: allComposableElements.entrySet()) {
			PlatformComposableElement pce = entry.getKey();
			RealizedComposableElement rce = entry.getValue();
			if (rce instanceof RealizedEntity) {
				RealizedEntity re = (RealizedEntity) rce;
				for (RealizedComposition rc: re.getComposition().values()) {
					PlatformComposableElement type = rc.getType();
					RealizedComposableElement realizedType = allComposableElements.get(type);
					if (realizedType == null) {
						System.out.println("Could not find realization for " + type.getName());
					}
					rc.setRealizedType(realizedType);
				}
			}
		}
	}
}
