package com.epistimis.uddl.constraints.standalone;

//Cloned from FACE 3.1 Conformance Test Suite DMVT

import java.nio.file.CopyOption;
import java.io.IOException;
import java.nio.file.Path;
import org.w3c.dom.Node;
import java.io.File;
import org.w3c.dom.Document;
import javax.xml.parsers.DocumentBuilder;
import org.eclipse.ocl.pivot.utilities.EnvironmentFactory;
import java.io.InputStream;
import org.eclipse.ocl.xtext.completeocl.validation.CompleteOCLEObjectValidator;
//import face.v31.face.traceability.TraceabilityPackage;
//import face.v31.face.integration.IntegrationPackage;
//import face.v31.face.uop.UopPackage;
//import uddl.v10.datamodel.platform.PlatformPackage;
//import uddl.v10.datamodel.logical.LogicalPackage;
//import uddl.v10.datamodel.conceptual.ConceptualPackage;
//import uddl.v10.datamodel.DatamodelPackage;
//import face.v31.face.FacePackage;
import com.epistimis.uddl.uddl.UddlPackage;
import org.eclipse.emf.common.util.URI;
import org.w3c.dom.Element;
import java.nio.file.Files;
import java.nio.file.attribute.FileAttribute;
import org.xml.sax.EntityResolver;
import org.xml.sax.helpers.DefaultHandler;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.ocl.pivot.resource.ProjectManager;
import org.eclipse.ocl.pivot.internal.utilities.PivotEnvironmentFactory;
import org.eclipse.ocl.pivot.internal.resource.StandaloneProjectMap;
import javax.xml.parsers.DocumentBuilderFactory;
import org.eclipse.ocl.pivot.model.OCLstdlib;
import org.eclipse.ocl.xtext.completeocl.CompleteOCLStandaloneSetup;
import org.eclipse.ocl.pivot.internal.validation.PivotEObjectValidator;
import org.eclipse.emf.ecore.EPackage;
import java.util.HashMap;

public class StandAloneOCLConstraints
{
    private static HashMap<EPackage, PivotEObjectValidator> validators;
    private static final StandAloneOCLConstraints Instance;

    public static HashMap<EPackage, PivotEObjectValidator> initializeStandAloneData(final boolean validateEntityUniqueness, final boolean validateObservableUniqueness) throws IOException {
        if (StandAloneOCLConstraints.validators == null) {
            CompleteOCLStandaloneSetup.doSetup();
            OCLstdlib.install();
            StandAloneOCLConstraints.validators = new HashMap<EPackage, PivotEObjectValidator>();
            final InputStream pluginXmlStream = StandAloneOCLConstraints.Instance.getClass().getResourceAsStream("/standalone.xml");
            final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setIgnoringElementContentWhitespace(true);
            factory.setIgnoringComments(true);
            try {
                final EnvironmentFactory environmentFactory = (EnvironmentFactory)new PivotEnvironmentFactory((ProjectManager)new StandaloneProjectMap(true), (ResourceSet)null);
                final DocumentBuilder builder = factory.newDocumentBuilder();
                builder.setEntityResolver(new DefaultHandler());
                final Document doc = builder.parse(pluginXmlStream);
                doc.getDocumentElement().normalize();
                final File tempOclResourceFolder = Files.createTempDirectory("UddlDataModelOcl", (FileAttribute<?>[])new FileAttribute[0]).toFile();
                tempOclResourceFolder.deleteOnExit();
                for (Node node = doc.getFirstChild(); node != null; node = node.getNextSibling()) {
                    if (node.getNodeType() == 1) {
                        if (node.getNodeName() == "plugin") {
                            for (Node childNode = node.getFirstChild(); childNode != null; childNode = childNode.getNextSibling()) {
                                if (childNode.getNodeType() == 1) {
                                    if (childNode.getNodeName() == "extension") {
                                        for (Node extChildNode = childNode.getFirstChild(); extChildNode != null; extChildNode = extChildNode.getNextSibling()) {
                                            if (extChildNode.getNodeType() == 1) {
                                                if (extChildNode.getNodeName() == "constraintProvider") {
                                                    for (Node conChildNode = extChildNode.getFirstChild(); conChildNode != null; conChildNode = conChildNode.getNextSibling()) {
                                                        if (conChildNode.getNodeType() == 1) {
                                                            if (conChildNode.getNodeName() == "ocl") {
                                                                final Element oclElem = (Element)conChildNode;
                                                                String ocl = oclElem.getAttribute("path");
                                                                if (!ocl.startsWith("/")) {
                                                                    ocl = "/" + ocl;
                                                                }
                                                                Path constraintFile;
                                                                if (ocl.contains("conceptual.ocl")) {
                                                                    String oclInputStreamName = ocl;
                                                                    if (validateEntityUniqueness) {
                                                                        oclInputStreamName = oclInputStreamName.replace("conceptual.ocl", "entityUniqueness.conceptual.ocl");
                                                                    }
                                                                    if (validateObservableUniqueness) {
                                                                        oclInputStreamName = oclInputStreamName.replace("conceptual.ocl", "observableUniqueness.conceptual.ocl");
                                                                    }
                                                                    constraintFile = copyFileToWorkingDirectory(tempOclResourceFolder, ocl, oclInputStreamName);
                                                                }
                                                                else {
                                                                    constraintFile = copyFileToWorkingDirectory(tempOclResourceFolder, ocl);
                                                                }
                                                                final URI oclUri = URI.createFileURI(constraintFile.toString());
                                                                EPackage pkg = null;
                                                                if (ocl.contains("face.ocl")) {
                                                                    //pkg = (EPackage)FacePackage.eINSTANCE;
                                                                }
                                                                else if (ocl.contains("datamodel.ocl")) {
                                                                    //pkg = (EPackage)DatamodelPackage.eINSTANCE;
                                                                    pkg = (EPackage)UddlPackage.eINSTANCE;
                                                                }
                                                                else if (ocl.contains("conceptual.ocl")) {
                                                                    //pkg = (EPackage)ConceptualPackage.eINSTANCE;
                                                                    pkg = (EPackage)UddlPackage.eINSTANCE;
                                                                }
                                                                else if (ocl.contains("logical.ocl")) {
                                                                    //pkg = (EPackage)LogicalPackage.eINSTANCE;
                                                                    pkg = (EPackage)UddlPackage.eINSTANCE;
                                                                }
                                                                else if (ocl.contains("platform.ocl")) {
                                                                    //pkg = (EPackage)PlatformPackage.eINSTANCE;
                                                                    pkg = (EPackage)UddlPackage.eINSTANCE;
                                                                }
// IN FACE - at a different level
//                                                                else if (ocl.contains("uop.ocl")) {
//                                                                    pkg = (EPackage)UopPackage.eINSTANCE;
//                                                                }
//                                                                else if (ocl.contains("integration.ocl")) {
//                                                                    pkg = (EPackage)IntegrationPackage.eINSTANCE;
//                                                                                                                                       pkg = (EPackage)IntegrationPackage.eINSTANCE;
//                                                                }
//                                                                else if (ocl.contains("traceability.ocl")) {
//                                                                    pkg = (EPackage)TraceabilityPackage.eINSTANCE;
//                                                                }
                                                                if (pkg == null) {
                                                                    System.out.println("No EPackage assigned for " + ocl);
                                                                }
                                                                else {
                                                                    final CompleteOCLEObjectValidator val = new CompleteOCLEObjectValidator(pkg, oclUri, environmentFactory);
                                                                    StandAloneOCLConstraints.validators.put(pkg, (PivotEObjectValidator)val);
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception e) {
                e.printStackTrace();
                pluginXmlStream.close();
            }
            pluginXmlStream.close();
        }
        System.out.println("Number of OCL Validators: " + Integer.toString(StandAloneOCLConstraints.validators.size()));
        return StandAloneOCLConstraints.validators;
    }

    static Path copyFileToWorkingDirectory(final File destDir, final String oclFileName) throws IOException, IllegalStateException {
        return copyFileToWorkingDirectory(destDir, oclFileName, oclFileName);
    }

    static Path copyFileToWorkingDirectory(final File destDir, final String destFileName, final String inputStreamName) throws IOException, IllegalStateException {
        if (!destDir.isDirectory()) {
            throw new IllegalStateException("java.io.File is not Directory: " + destDir.getName());
        }
        final Path constraintFile = new File(destDir, destFileName).toPath();
        final Path constraintsDir = Files.createDirectories(constraintFile.getParent(), (FileAttribute<?>[])new FileAttribute[0]);
        final InputStream input = StandAloneOCLConstraints.Instance.getClass().getResourceAsStream(inputStreamName);
        if (constraintsDir == null) {
            throw new IllegalStateException("Could not create temporary constraint directory: " + constraintFile);
        }
        if (input == null) {
            throw new IllegalStateException("Missing OCL resource: " + inputStreamName);
        }
        try {
            Files.copy(input, constraintFile, new CopyOption[0]);
        }
        finally {
            try {
                input.close();
            }
            catch (IOException ex) {}
        }
        return constraintFile;
    }

    static {
        StandAloneOCLConstraints.validators = null;
        Instance = new StandAloneOCLConstraints();
    }

}
