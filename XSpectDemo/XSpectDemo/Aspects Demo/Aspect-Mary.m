
#import "XSpect.h"
#undef AtAspect
#define AtAspect Mary


// ==================
// You can change the value of `Demo_Tag_MaryGreeting` macro varialbe to choose the implementation to be compiled.
// Those implementations should be logically the same.
#define Demo_Tag_MaryGreeting 1
// ==================
#import "User.h"

// ========================================
// This is an implementation using only XAspectCore to do aspect-oriented programming.
#if Demo_Tag_MaryGreeting == 1
@implementation User (MaryGreeting)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwapInstanceMethod([self class], @selector(userName),
                           @selector(MaryGreeting_userName));
    });
}
- (NSString *) MaryGreeting_userName{
    // Add before advice here
    NSLog(@"Mary ----> Hello, what's your name?");
    // Invoke recursively
    NSString *userName = [self MaryGreeting_userName];
    // After advice
    NSLog(@"Mary ----> Greeting, %@.", userName);
    return userName;
}
@end
#endif
// ========================================


// ========================================
// This is an implementation using XAspectCore and XAspectExtension macros to do aspect-oriented programming.
// You should read the documentation to know how to use those macros.
#if Demo_Tag_MaryGreeting == 2

AspectOfClass(User)
WeaveAspectInstanceMethods(@selector(userName));

AspectImplementation
- (NSString *) Aspect(userName){
    // Add before advice here
    NSLog(@"Mary ----> Hello, what's your name?");
    // Invoke recursively
    NSString *userName = [self Aspect(userName)];
    // After advice
    NSLog(@"Mary ----> Greeting, %@.", userName);
    return userName;
}
EndAspect
#endif
// ========================================

