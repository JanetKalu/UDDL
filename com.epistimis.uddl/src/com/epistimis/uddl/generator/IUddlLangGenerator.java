package com.epistimis.uddl.generator;

import java.util.Collection;

import org.eclipse.xtext.generator.IFileSystemAccess2;
import org.eclipse.xtext.generator.IGenerator2;
import org.eclipse.xtext.generator.IGeneratorContext;

import com.epistimis.uddl.uddl.PlatformEntity;

public interface IUddlLangGenerator extends IGenerator2 {

	void processEntities(Collection<PlatformEntity> entities, IFileSystemAccess2 fsa,IGeneratorContext context);

}
