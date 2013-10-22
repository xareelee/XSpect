

//  Copyright (c) 2013 Xaree Lee. All rights reserved.


#import "XLIntrospectFunctions.h"

IntrospectBlock Guard_UIShouldNotBeFirstResponder(UIView* aView){
    
    if ([aView isFirstResponder]) {
        [aView resignFirstResponder];
        return nil;
    }
    
    return ^ Matryoshka(Matryoshka innerMatryoshka){
        return innerMatryoshka;
    };
};

IntrospectBlock Guard_StringShouldContainCharacters(NSString *string, NSString *alertMessage){
    
    if (! string || [string length] == 0) {
        return ^ Matryoshka(Matryoshka innerMatryoshka){
			return ^(){
				if (alertMessage) {
					UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alertView show];
				}
			};
		};
    }
    
    return ^ Matryoshka(Matryoshka innerMatryoshka){
        return innerMatryoshka;
    };
}

IntrospectBlock Guard_StringShouldBeAnEmailAdress(NSString *string, NSString *alertMessage){
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
        
    if (! [emailTest evaluateWithObject:string]) {
        return ^ Matryoshka(Matryoshka innerMatryoshka){
			return ^(){
				if (alertMessage) {
					UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alertView show];
				}
			};
		};
    }
    
    return ^ Matryoshka(Matryoshka innerMatryoshka){
        return innerMatryoshka;
    };
}

IntrospectBlock Guard_StringShouldBeTheSame(NSString *firstString, NSString *secondString, NSString *alertMessage){
    
    if (! [firstString isEqualToString:secondString]) {
        return ^ Matryoshka(Matryoshka innerMatryoshka){
			return ^(){
				if (alertMessage) {
					UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
					[alertView show];
				}
			};
		};
    }
    
    return ^ Matryoshka(Matryoshka innerMatryoshka){
        return innerMatryoshka;
    };
}

