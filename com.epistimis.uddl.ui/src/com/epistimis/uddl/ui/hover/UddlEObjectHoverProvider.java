package com.epistimis.uddl.ui.hover;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.jface.internal.text.html.HTMLPrinter;
import org.eclipse.jface.text.IRegion;
import org.eclipse.jface.text.ITextViewer;
import org.eclipse.xtext.Keyword;
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider;
import org.eclipse.xtext.ui.editor.hover.html.XtextBrowserInformationControlInput;

import com.epistimis.uddl.uddl.UddlElement;
//import org.eclipse.xtext.xbase.ui.hover.XbaseHoverProvider;
import com.google.inject.Inject;
 
/**
 * 
 * Basic hover support: https://dietrich-it.de/xtext/2011/07/16/hover-support-in-xtext-2.0-tutorial/
 * 
 * Partially inspired in blog post
 * https://blogs.itemis.com/en/xtext-usability-hovers-on-keywords
 * 
 * Per https://www.eclipse.org/forums/index.php/t/1075252/ (or https://www.eclipse.org/forums/index.php/t/1067934/_), 
 * since I don't use XBase, I replaced references to XBase with it's base class.  
 * 
 * @author stevehickman
 */

public class UddlEObjectHoverProvider extends DefaultEObjectHoverProvider {

    /** Utility mapping keywords and hovertext. */
    @Inject UddlKeywordHovers keywordHovers;
 
    /**
     * per https://www.eclipse.org/forums/index.php/t/1067934/, Sebastian Zarkenow says to override
     * 'for that purpose you'd have to override  
     * org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider.getHoverInfo(EObject, ITextViewer, IRegion) 
     * and check the viewer and the given region to compute the hover.
     * @return 
     */
    /*
    @Override
	public IInformationControlCreatorProvider getHoverInfo(EObject obj, ITextViewer viewer, IRegion region) {
		return null;
	}
  */    
    
    @Override
    protected XtextBrowserInformationControlInput getHoverInfo(EObject obj, IRegion region, XtextBrowserInformationControlInput prev) {
        if (obj instanceof Keyword) {
            String html = getHoverInfoAsHtml(obj);
            if (html != null) {
                StringBuffer buffer = new StringBuffer(html);
                HTMLPrinter.insertPageProlog(buffer, 0, getStyleSheet());
                HTMLPrinter.addPageEpilog(buffer);
                return new XtextBrowserInformationControlInput(prev, obj, buffer.toString(), getLabelProvider());
            }
        }
        return super.getHoverInfo(obj, region, prev);
    }
 
    @Override
    protected String getHoverInfoAsHtml(EObject o){
        if (o instanceof Keyword)
            return keywordHovers.hoverText((Keyword) o);
        return super.getHoverInfoAsHtml(o);
    }
    
  
    
    @Override
    protected String getFirstLine(EObject o) {
        if (o instanceof UddlElement) {
        	return ((UddlElement)o).getName();
        }
        return super.getFirstLine(o);
    }
}
