

//  Copyright (c) 2013 Xaree Lee. All rights reserved.

#import <UIKit/UIKit.h>
#import "XSpect.h"


IntrospectBlock Guard_UIShouldNotBeFirstResponder(UIView* aView);
IntrospectBlock Guard_StringShouldContainCharacters(NSString *string, NSString *alertMessage);
IntrospectBlock Guard_StringShouldBeAnEmailAdress(NSString *string, NSString *alertMessage);
IntrospectBlock Guard_StringShouldBeTheSame(NSString *firstString, NSString *secondString, NSString *alertMessage);
