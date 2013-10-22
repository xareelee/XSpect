

//  Copyright (c) 2013 Xaree Lee. All rights reserved.


#import <objc/runtime.h>

/** Swap two class methods for the class. */
void SwapClassMethod(Class class, SEL originalSelector, SEL aspectSelctor);

/** Swap two instance methods for the class. */
void SwapInstanceMethod(Class class, SEL originalSelector, SEL aspectSelctor);
