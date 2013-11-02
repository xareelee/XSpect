

#import "XSpect.h"
#undef AtAspect
#define AtAspect JasonAspect


// ==================
// You can change the value of `Demo_Tag_JasonAspect` macro varialbe to choose the implementation to be compiled.
// Those implementations should be logically the same.
#define Demo_Tag_JasonAspect 1
// ==================
#import "User.h"

// ========================================
// This is an implementation using only XAspectCore to do aspect-oriented programming.
#if Demo_Tag_JasonAspect == 1
@implementation User (JasonAspect)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwapInstanceMethod([self class], @selector(userName), @selector(JasonAspect_userName));
		SwapClassMethod([self class], @selector(users), @selector(JasonAspect_users));
    });
}

+ (NSArray *)JasonAspect_users{
	NSArray *users = [self JasonAspect_users];
	NSString *additionalUser = @"Monica Bellucci";
	NSLog(@"Add another user: %@ (From JasonAspect)", additionalUser);
	return [users arrayByAddingObject:additionalUser];
}

- (NSString *) JasonAspect_userName{
    // Add before advice here
    NSLog(@"Jason ----> I see you before. I know you are...");
    // Invoke recursively
    NSString *userName = [self JasonAspect_userName];
    // After advice
    NSLog(@"Jason ----> Yeah, yeah. You are %@!", userName);
    return userName;
}
@end
#endif
// ========================================


// ========================================
// This is an implementation using XAspectCore and XAspectStyleSheet macros to do aspect-oriented programming.
// You should read the documentation to know how to use those macros.
#if Demo_Tag_JasonAspect == 2

AspectOfClass(User)
WeaveAspectInstanceMethods(@selector(userName));
WeaveAspectClassMethods(@selector(users));

AspectImplementation
+ (NSArray *)Aspect(users){
	NSArray *users = [self Aspect(users)];
	NSString *additionalUser = @"Monica Bellucci";
	NSLog(@"Add another user: %@ (From JasonAspect)", additionalUser);
	return [users arrayByAddingObject:additionalUser];
}

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

