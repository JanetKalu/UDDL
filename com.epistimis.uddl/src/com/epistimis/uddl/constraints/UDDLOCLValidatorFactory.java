package com.epistimis.uddl.constraints;

//Cloned from FACE 3.1 Conformance Test Suite DMVT

import com.epistimis.uddl.constraints.standalone.EValidatorAdapter;
import org.eclipse.emf.ecore.EValidator;

public class UDDLOCLValidatorFactory
{
    public static EValidator createFaceOclValidator() {
        return (EValidator)new EValidatorAdapter();
    }
}