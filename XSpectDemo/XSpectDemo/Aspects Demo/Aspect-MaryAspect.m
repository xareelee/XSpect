
#import "XSpect.h"
#undef AtAspect
#define AtAspect MaryAspect


// ==================
// You can change the value of `Demo_Tag_MaryAspect` macro varialbe to choose the implementation to be compiled.
// Those implementations should be logically the same.
#define Demo_Tag_MaryAspect 1
// ==================
#import "User.h"

// ========================================
// This is an implementation using only XAspectCore to do aspect-oriented programming.
#if Demo_Tag_MaryAspect == 1
@implementation User (MaryAspect)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwapInstanceMethod([self class], @selector(userName),@selector(MaryAspect_userName));
		SwapClassMethod([self class], @selector(users), @selector(MaryAspect_users));
    });
}

+ (NSArray *)MaryAspect_users{
	NSArray *users = [self MaryAspect_users];
	NSString *additionalUser = @"Scarlett Johansson";
	NSLog(@"Add another user: %@ (From MaryAspect)", additionalUser);
	return [users arrayByAddingObject:additionalUser];
}

- (NSString *) MaryAspect_userName{
    // Add before advice here
    NSLog(@"Mary ----> Hello, what's your name?");
    // Invoke recursively
    NSString *userName = [self MaryAspect_userName];
    // After advice
    NSLog(@"Mary ----> Greeting, %@.", userName);
    return userName;
}
@end
#endif
// ========================================


// ========================================
// This is an implementation using XAspectCore and XAspectStyleSheet macros to do aspect-oriented programming.
// You should read the documentation to know how to use those macros.
#if Demo_Tag_MaryAspect == 2

AspectOfClass(User)
WeaveAspectInstanceMethods(@selector(userName));
WeaveAspectClassMethods(@selector(users));

AspectImplementation
+ (NSArray *)Aspect(users){
	NSArray *users = [self Aspect(users)];
	NSString *additionalUser = @"Scarlett Johansson";
	NSLog(@"Add another user: %@ (From MaryAspect)", additionalUser);
	return [users arrayByAddingObject:additionalUser];
}

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

