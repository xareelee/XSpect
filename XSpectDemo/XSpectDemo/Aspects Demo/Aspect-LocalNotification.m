


#import "XSpect.h"
#undef AtAspect
#define AtAspect LocalNotification

/*
 This shows you how to use XAspect to add advices across classes and methods in the same file.
 */

// ----------------------------------------
#import "AppDelegate.h"

AspectOfClass(AppDelegate)
WeaveAspectInstanceMethods(@selector(application:didReceiveLocalNotification:));

/**
 @warning Make sure that there should be an implementatoin of `-application:didReceiveLocalNotification:` in the original class before swapping implementation. Especially the target method is an opetional delegate method.
 */
AspectImplementation
- (void)Aspect(application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification){
    
    [self Aspect(application:application didReceiveLocalNotification:notification)];
    
    NSLog(@"%@", notification.userInfo[@"message"]);
    printf("\n");
}
EndAspect


// ----------------------------------------
#import "XLViewController.h"

AspectOfClass(XLViewController)
WeaveAspectInstanceMethods(@selector(button1Pressed:),
                           @selector(button2Pressed:),
                           @selector(share:));


AspectImplementation
- (void) Aspect( button1Pressed:(id)sender){
    
	NSLog(@"==> send a local notification (1) for the aspect");
	
    // Create 一個 local notfication 並發出
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
    localNotification.userInfo = @{@"message":@"==> Two seconds ago, you did press the button 1."};
	
	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
	
    [self Aspect(button1Pressed:sender)];
    printf("\n");
}

- (void) Aspect( button2Pressed:(id)sender){
    
	NSLog(@"==> send a local notification (2) for the aspect");
	
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
    localNotification.userInfo = @{@"message":@"==> Two seconds ago, you did press the button 2."};
	
	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
	
    [self Aspect(button2Pressed:sender)];
    printf("\n");
}

- (void) Aspect(share:(id)sender){
    
	NSLog(@"==> send a local notification (share) for the aspect");
	
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
    localNotification.userInfo = @{@"message":@"==> Two seconds ago, you did press the button 'share'."};
	
	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
	
    [self Aspect(share:sender)];
    printf("\n");
}

EndAspect
// ----------------------------------------



#import "XLFormatViewController.h"
AspectOfClass(XLFormatViewController)

WeaveAspectInstanceMethods(@selector(remind:));

AspectImplementation

- (IBAction)Aspect(remind:(id)sender){
	
	NSLog(@"==> send a local notification (remind me 5 sec later) for the aspect");
	
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.userInfo = @{@"message":@"==> Five seconds ago, you did press the button 'remind me 5 sec later'."};
	
	[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

	
	[self Aspect(remind:sender)];
	printf("\n");
}


EndAspect
