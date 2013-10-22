//
//  XLViewController.m
//  XSpect
//
//  Created by Xaree Lee on 13/10/13.
//  Copyright (c) 2013年 Xaree Lee. All rights reserved.
//

#import "XLViewController.h"

@interface XLViewController ()

@end

@implementation XLViewController

- (IBAction)button1Pressed:(id)sender {
	// You may add `Aspect-LocalNotification.m` in the 'XAspect Demo' directory to show how to add addtional code using XAspect.
    NSLog(@"You pressed button 1.");
}

- (IBAction)button2Pressed:(id)sender {
	// You may add `Aspect-LocalNotification.m` in the 'XAspect Demo' directory to show how to add addtional code using XAspect.
    NSLog(@"You pressed button 2.");
}

- (IBAction)share:(id)sender {
	// You may add `Aspect-LocalNotification.m` and `Aspect-ShareKit.m` in the 'XAspect Demo' directory to show how to add addtional code using XAspect.
    NSLog(@"You pressed button 'share'.");
}

@end
