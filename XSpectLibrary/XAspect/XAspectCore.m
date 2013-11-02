

//  Version of XSpect: 0.3
//  Copyright (c) 2013 Xaree Lee. All rights reserved.


#import "XAspectCore.h"

#pragma mark -
#pragma mark Headers of Private functions

int nullFunction(id self, SEL selector, ...);
void makeSelectorChain(Class class, SEL headSelector, SEL addedSelector);
void validateClassForSelectorChain(Class cls);


#pragma mark Implementation of Private functions

int nullFunction(id self, SEL selector, ...){
	
	return 0;
}

void makeSelectorChain(Class class, SEL headSelector, SEL addedSelector){
	
	// Try adding a null function if the implementation of selector chain dosen't exist.
	if (class_addMethod(class, headSelector, (IMP)nullFunction, "i@:")) {
		NSLog(@"XAspect injects a null function: [%@ %@]", NSStringFromClass(class), NSStringFromSelector(headSelector));
	}
	
	Method originalMethod = class_getInstanceMethod(class, headSelector);
    Method aspectMethod = class_getInstanceMethod(class, addedSelector);
	NSCAssert(originalMethod, @"The original method should exist.");
	NSCAssert(aspectMethod, @"The aspect method should exist.");
	
    method_exchangeImplementations(originalMethod, aspectMethod);
	
	return;
}

void validateClassForSelectorChain(Class class){
	
	Class metaClass = object_getClass(class);
	
	NSCAssert(!class_isMetaClass(class), @"Class <%@> should not be a meta class. Please check the class type.", NSStringFromClass(class));
	
	NSCAssert(class_isMetaClass(metaClass), @"Class <%@> should have a meta class. "
			  @"Please check the class type.", NSStringFromClass(class));
	
	NSCAssert(strcmp(class_getName(class), class_getName(metaClass)) == 0, @"Meta class of Class <%@> should have the same class name. Please check the class type.", NSStringFromClass(class));
	
	return;
}


#pragma mark -
#pragma mark Implementation of Public functions

void SwapClassMethod(Class class, SEL originalSelector, SEL aspectSelctor){
	
	#if	DEBUG
	// Check the class only in debug mode.
	validateClassForSelectorChain(class);
	#endif
	
	return makeSelectorChain(object_getClass(class), originalSelector, aspectSelctor);
}

void SwapInstanceMethod(Class class, SEL originalSelector, SEL aspectSelctor){
	
	#if	DEBUG
	// Check the class only in debug mode.
	validateClassForSelectorChain(class);
	#endif
	
	return makeSelectorChain(class, originalSelector, aspectSelctor);
}
