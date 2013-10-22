

//  Copyright (c) 2013 Xaree Lee. All rights reserved.


#import "XAspectCore.h"

void SwapClassMethod(Class class, SEL originalSelector, SEL aspectSelctor){
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method aspectMethod = class_getClassMethod(class, aspectSelctor);
    method_exchangeImplementations(originalMethod, aspectMethod);
}

void SwapInstanceMethod(Class class, SEL originalSelector, SEL aspectSelctor){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method aspectMethod = class_getInstanceMethod(class, aspectSelctor);
    method_exchangeImplementations(originalMethod, aspectMethod);
}
