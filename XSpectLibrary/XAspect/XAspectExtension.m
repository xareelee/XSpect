

//  Copyright (c) 2013 Xaree Lee. All rights reserved.

#import "XAspectExtension.h"


SEL prefixedSelector(SEL selector, NSString *prefix){
    return NSSelectorFromString([NSString stringWithFormat:@"%@_%@", prefix, NSStringFromSelector(selector)]);
}

void SwapClassMethods(NSString *aspectName, Class class, SEL classSelector, ...){
    
    va_list selector_list;
    va_start(selector_list, classSelector);
    
    for (SEL enumeratedSelector = classSelector; enumeratedSelector != nil; enumeratedSelector = va_arg(selector_list, SEL)) {
        
        SEL aspectSelector = prefixedSelector(enumeratedSelector, aspectName);
        SwapClassMethod(class, enumeratedSelector, aspectSelector);
    }
    
    va_end(selector_list);
}

void SwapInstanceMethods(NSString *aspectName, Class class, SEL classSelector, ...){
    
    va_list selector_list;
    va_start(selector_list, classSelector);
    
    for (SEL enumeratedSelector = classSelector; enumeratedSelector != nil; enumeratedSelector = va_arg(selector_list, SEL)) {
        SEL aspectSelector = prefixedSelector(enumeratedSelector, aspectName);
        SwapInstanceMethod(class, enumeratedSelector, aspectSelector);
    }
    
    va_end(selector_list);
}

