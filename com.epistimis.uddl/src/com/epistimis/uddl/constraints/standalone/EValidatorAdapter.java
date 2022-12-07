package com.epistimis.uddl.constraints.standalone;


// Cloned from FACE 3.1 Conformance Test Suite DMVT

import org.eclipse.emf.common.util.Diagnostic;
import org.eclipse.emf.common.util.BasicDiagnostic;
import org.eclipse.emf.validation.model.IConstraintStatus;
import org.eclipse.emf.ecore.EDataType;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.core.runtime.Status;
import org.eclipse.emf.ecore.EClass;
import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.validation.model.EvaluationMode;
import org.eclipse.emf.validation.service.ModelValidationService;
import org.eclipse.emf.validation.service.IBatchValidator;
import org.eclipse.emf.ecore.util.EObjectValidator;

public class EValidatorAdapter extends EObjectValidator
{
    private final IBatchValidator batchValidator;
    
    public EValidatorAdapter() {
        (this.batchValidator = (IBatchValidator)ModelValidationService.getInstance().newValidator(EvaluationMode.BATCH)).setIncludeLiveConstraints(true);
        this.batchValidator.setReportSuccesses(false);
    }
    
    public boolean validate(final EObject eObject, final DiagnosticChain diagnostics, final Map<Object, Object> context) {
        return this.validate(eObject.eClass(), eObject, diagnostics, context);
    }
    
    public boolean validate(final EClass eClass, final EObject eObject, final DiagnosticChain diagnostics, final Map<Object, Object> context) {
        super.validate(eClass, eObject, diagnostics, (Map<Object, Object>)context);
        IStatus status = Status.OK_STATUS;
        if (diagnostics != null && !this.hasProcessed(eObject, context)) {
            status = this.batchValidator.validate(eObject, (IProgressMonitor)new NullProgressMonitor());
            this.processed(eObject, context, status);
            this.appendDiagnostics(status, diagnostics);
        }
        return status.isOK();
    }
    
    public boolean validate(final EDataType eDataType, final Object value, final DiagnosticChain diagnostics, final Map<Object, Object> context) {
        return super.validate(eDataType, value, diagnostics, (Map<Object, Object>)context);
    }
    
    private void processed(final EObject eObject, final Map<Object, Object> context, final IStatus status) {
        if (context != null) {
            context.put(eObject, status);
        }
    }
    
    private boolean hasProcessed(EObject eObject, final Map<Object, Object> context) {
        boolean result = false;
        if (context != null) {
            while (eObject != null) {
                if (context.containsKey(eObject)) {
                    result = true;
                    eObject = null;
                }
                else {
                    eObject = eObject.eContainer();
                }
            }
        }
        return result;
    }
    
    private void appendDiagnostics(final IStatus status, final DiagnosticChain diagnostics) {
        if (status.isMultiStatus()) {
            final IStatus[] children =  status.getChildren();
            for (final IStatus element : children) {
                this.appendDiagnostics(element, diagnostics);
            }
        }
        else if (status instanceof IConstraintStatus) {
            diagnostics.add((Diagnostic)new BasicDiagnostic(status.getSeverity(), status.getPlugin(), status.getCode(), status.getMessage(), ((IConstraintStatus)status).getResultLocus().toArray()));
        }
    }
}