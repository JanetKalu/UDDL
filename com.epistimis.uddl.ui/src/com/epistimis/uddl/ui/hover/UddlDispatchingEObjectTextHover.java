package com.epistimis.uddl.ui.hover;
/**
 * From blog post
 * https://blogs.itemis.com/en/xtext-usability-hovers-on-keywords
 * 
 * Per https://www.eclipse.org/forums/index.php/t/1075252/ , since I don't use XBase, I replaced references to XBase
 * with it's base class
 */
import org.eclipse.xtext.ui.editor.hover.DispatchingEObjectTextHover;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.jface.text.IInformationControlCreator;
import org.eclipse.jface.text.IRegion;
import org.eclipse.jface.text.ITextViewer;
import org.eclipse.xtext.Keyword;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.ui.editor.hover.IEObjectHoverProvider;
import org.eclipse.xtext.ui.editor.hover.IEObjectHoverProvider.IInformationControlCreatorProvider;
import org.eclipse.xtext.util.Pair;
//import org.eclipse.xtext.xbase.ui.hover.XbaseDispatchingEObjectTextHover;
 
import com.google.inject.Inject;
 

public class UddlDispatchingEObjectTextHover extends DispatchingEObjectTextHover {
//public class MyXbaseDispatchingEObjectTextHover extends XbaseDispatchingEObjectTextHover {
 
    @Inject
    KeywordAtOffsetHelper keywordAtOffsetHelper;
 
    @Inject
    IEObjectHoverProvider hoverProvider;
 
    IInformationControlCreatorProvider lastCreatorProvider = null;
 
    @Override
    public Object getHoverInfo(EObject first, ITextViewer textViewer, IRegion hoverRegion) {
        if (first instanceof Keyword) {
            lastCreatorProvider = hoverProvider.getHoverInfo(first, textViewer, hoverRegion);
            return lastCreatorProvider == null ? null : lastCreatorProvider.getInfo();
        }
        lastCreatorProvider = null;
        return super.getHoverInfo(first, textViewer, hoverRegion);
    }
 
    @Override
    public IInformationControlCreator getHoverControlCreator() {
        return this.lastCreatorProvider == null ? super.getHoverControlCreator() : lastCreatorProvider.getHoverControlCreator();
    }
 
    @Override
    protected Pair<EObject, IRegion> getXtextElementAt(XtextResource resource, final int offset) {
        Pair<EObject, IRegion> result = super.getXtextElementAt(resource, offset);
        if (result == null) {
            result = keywordAtOffsetHelper.resolveKeywordAt(resource, offset);
        }
        return result;
    }
}
