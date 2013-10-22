

#import "XSpect.h"
#undef AtAspect
#define AtAspect Jason


// ==================
// You can change the value of `Demo_Tag_JasonGreeting` macro varialbe to choose the implementation to be compiled.
// Those implementations should be logically the same.
#define Demo_Tag_JasonGreeting 1
// ==================
#import "User.h"

// ========================================
// This is an implementation using only XAspectCore to do aspect-oriented programming.
#if Demo_Tag_JasonGreeting == 1
@implementation User (JasonGreeting)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwapInstanceMethod([self class], @selector(userName),
                           @selector(JasonGreeting_userName));
    });
}
- (NSString *) JasonGreeting_userName{
    // Add before advice here
    NSLog(@"Jason ----> I see you before. I know you are...");
    // Invoke recursively
    NSString *userName = [self JasonGreeting_userName];
    // After advice
    NSLog(@"Jason ----> Yeah, yeah. You are %@!", userName);
    return userName;
}
@end
#endif
// ========================================


// ========================================
// This is an implementation using XAspectCore and XAspectExtension macros to do aspect-oriented programming.
// You should read the documentation to know how to use those macros.
#if Demo_Tag_JasonGreeting == 2

AspectOfClass(User)
WeaveAspectInstanceMethods(@selector(userName));

AspectImplementation
- (NSString *) Aspect(userName){
    // Add before advice here
    NSLog(@"Jason ----> I see you before. I know you are...");
    // Invoke recursively
    NSString *userName = [self Aspect(userName)];
    // After advice
    NSLog(@"Jason ----> Yeah, yeah. You are %@!", userName);
    return userName;
}
EndAspect
#endif
// ========================================

