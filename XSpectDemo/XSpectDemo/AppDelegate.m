//
//  XLAppDelegate.m
//  XSpect
//
//  Created by Xaree Lee on 13/10/13.
//  Copyright (c) 2013 Xaree Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
#import "XSpect.h"

#import "XLIntrospectDemoCode.h"
#import "MatryoshkaDemo.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
	NSLog(@"========== Demo XAspect (class method) ==========");
	NSArray *users = [User users];
	NSLog(@"There are %d users on the list: %@", [users count], users);
	
	
	printf("\n\n");
    NSLog(@"========== Demo XAspect (instance method) ==========");
	User *user = [User new];
    NSLog(@"The user is: %@", [user userName]);
	
	
	printf("\n\n");
    NSLog(@"========== Demo XIntrospect ==========");
	
	// please check the `+introspectDemo` method
	[MatryoshkaDemo introspectDemo];
	
	printf("\n\n");
	NSLog(@"========== Application Did Finish Launch ==========");
    printf("\n\n");
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
	NSLog(@"XLAppDelegate did receive local notification");
}

@end

