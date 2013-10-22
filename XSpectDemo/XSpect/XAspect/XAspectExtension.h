

//  Copyright (c) 2013 Xaree Lee. All rights reserved.


#import "XAspectCore.h"



#pragma mark - Functions to help swap methods for a class category with category name (as the prefix)

/** Return the selector with a prefix (separated by a underscore `_`). */
SEL prefixedSelector(SEL selector, NSString *prefix);

/** Swap multiple class methods with prefixed methods within the same class. */
void SwapClassMethods(NSString *aspectName, Class class, SEL classSelector, ...);

/** Swap multiple instance methods with prefixed methods within the same class. */
void SwapInstanceMethods(NSString *aspectName, Class class, SEL classSelector, ...);



#pragma mark - Macros to help implement the aspect for objects easily
/**
 
 Must Read –– About `AtAspect` Macro Variable
 ==============================================
 
 `AtAspect` is a macro variable which isn't defined in XAspect library, but is used for many macros in XAspect. You should define/redefine `AtAspect` whenever you want to use XAspectExtension macros to define a category of the aspect.
 
 It will be used for the Obj-C category name and the prefix of the aspect methods.
 
 
 About the Following Macros
 ==========================
 
 **Caution:** you should **ALWAYS REDEFINE** the keyword `AtAspect` by using `#undef` and `#define` macros **JUST BEFORE** using any following macros. Those following macros will automatically use this keyword (`AtAspect`, macro vairable) to resolve it's definition.
 
 To use the following macros, read the documentation attached to them.
 
 The following macros introduce and substitute the `AtAspect` keyword for the name redefined by you. There are 3 levels of macros to accomplish this goal (interface macro -> prototype macro -> resolved macro):
 
 * interface macro: the macro for use. It will invoke the prototype macro and introduce the macro vairables (e.g. `AtAspect`) which were defined in other place.
 * prototype macro: the macro defining an interface of th resolved macro. It will invoke the resolved macro and substitute the macro vairables to the defined value.
 * resolved macro: the macro using those variables to invoke a function or to define a structured format.
 
 @see Here's the explanation about [why it needs two more levels of macro to introduce macro variables and concatenation]( http://stackoverflow.com/questions/1489932/c-preprocessor-and-concatenation )
 */


#pragma mark Macros to define a structured format to implement category for aspect easily
/** 
 
 Use the following macro structure to declare a category for aspect
 
     // Redefine the `AtAspect` macro varaible
     #undef AtAspect
     #define AtAspect
 
     AspectOfClass(className) // Start to describe an aspect for the class
     // Set the configuration for this aspect here
     // ...
 
     AspectImplementation
     // Implement the method for the aspect here
     // ...
 
     EndAspect  // Finish describing the aspect
 
 */
#define AspectOfClass(className) PrototypeAspectCategory(className, AtAspect)

#define PrototypeAspectCategory(className, categoryName) ResolvedAspectCategory(className, categoryName)

#define ResolvedAspectCategory(className, categoryName) \
@implementation className (categoryName)    \
+ (void) load{                              \
static dispatch_once_t onceToken;           \
dispatch_once(&onceToken, ^{


#define AspectImplementation                \
});                                         \
}

#define EndAspect @end



#pragma mark Macros to help set the configuration of the aspect.

/**
 `WeaveAspectOfClassMethods(classSelector, ...)` macro will swap multiple selectors of class methods for the class using it. It will use the `AtAspect` as the prefix for the aspect methods (separated by a underscore).
 
 You should use this macro in the `+load` method or the configuration block in the `AspectOfClass(className) ... AspectImplementation ... EndAspect` format.
 
 @param classSelector The selectors of the original class method (without aspect prefix).
 
 */
#define WeaveAspectOfClassMethods(classSelector, ...)  \
PrototypeWeaveAspectOfClassMethods(AtAspect, [self class], (classSelector), ##__VA_ARGS__, nil)

#define PrototypeWeaveAspectOfClassMethods(aspectName, class, classSelector, ...) \
ResolvedWeaveAspectOfClassMethods(aspectName, class, (classSelector), ##__VA_ARGS__)

#define ResolvedWeaveAspectOfClassMethods(aspectName, class, classSelector, ...) \
SwapClassMethods(@#aspectName, class, (classSelector), ##__VA_ARGS__)


/**
 
 `WeaveAspectInstanceMethods(instanceSelector, ...)` macro will swap multiple selectors of instance methods for the class using it. It will use the `AtAspect` as the prefix for the aspect methods (separated by a underscore).
 
 You should use this macro in the `+load` method or the configuration block in the `AspectOfClass(className) ... AspectImplementation ... EndAspect` format.
 
 @param instanceSelector The selectors of the original instance method (without aspect prefix).
 
 */
#define WeaveAspectInstanceMethods(instanceSelector, ...)  \
PrototypeWeaveAspectInstanceMethods(AtAspect, [self class], (instanceSelector), ##__VA_ARGS__, nil)

#define PrototypeWeaveAspectInstanceMethods(aspectName, class, instanceSelector, ...) \
ResolvedWeaveAspectInstanceMethods(aspectName, class, (instanceSelector), ##__VA_ARGS__)

#define ResolvedWeaveAspectInstanceMethods(aspectName, class, instanceSelector, ...) \
SwapInstanceMethods(@#aspectName, class, (instanceSelector), ##__VA_ARGS__)



#pragma mark Macros to help compose aspect method name from original method name.

/**
 This macro will concatenate into a prefixed method with a defined name (the keyword `AtAspect` you defined). It will use the `AtAspect` as the prefix for the aspect methods (separated by a underscore).
 
 This macro may not be useful because the automatic method completion won't be introduced.
 */
#define Aspect(method, ...) ProtypePrefixedMethod(AtAspect, method, ##__VA_ARGS__)
#define ProtypePrefixedMethod(prefix, method, ...) MethodConcatenate(prefix, method, ##__VA_ARGS__)
#define MethodConcatenate(head, tail, ...) head ## _ ## tail, ##__VA_ARGS__

/**
 A convenient macro to invoke the aspect method. This macro may not be useful because the automatic method completion won't be introduced.
 */
#define AspectInvoke(method) [self Aspect(method)]


