//
//  User.m
//  XSpect
//
//  Created by Xaree Lee on 13/10/14.
//  Copyright (c) 2013年 Xaree Lee. All rights reserved.
//

#import "User.h"

@implementation User
+ (NSArray *)users{
	NSArray *users = @[@"Xaree Lee",
					   @"Natalie Portman"];
	NSLog(@"Original users are: %@", users);
	return users;
}
- (NSString *)userName{
    NSString *userName = @"Xaree Lee";
    NSLog(@"My name? I'm %@", userName);
    return userName;
}
@end
