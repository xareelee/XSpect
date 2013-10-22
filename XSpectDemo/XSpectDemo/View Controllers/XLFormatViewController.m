//
//  XLFormatViewController.m
//  XSpect
//
//  Created by Xaree Lee on 13/10/16.
//  Copyright (c) 2013年 Xaree Lee. All rights reserved.
//

#import "XLFormatViewController.h"
#import "XSpect.h"

@interface XLFormatViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *aliasField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmedPasswordField;

@end


@implementation XLFormatViewController

- (IBAction)registerAnAccount:(id)sender {
    
	
	// ==================
	// You can change the value of `Demo_Tag_Block_in_Block` macro varialbe to choose the implementation to be compiled.
	// Those implementations should be logically the same.
	
	// 1: the original implementation you might do.
	// 2: the implementation implemented in XIntrospect way.
	#define Demo_Tag_Block_in_Block 1 
	// ==================

    
#if Demo_Tag_Block_in_Block == 1
    
    NSLog(@"Demo_Tag_Block_in_Block (1)");
    
    // 1. Make sure keyborad is inactive.
    if ([self.nameField isFirstResponder]) {
        [self.nameField resignFirstResponder];
        return;
    }
    if ([self.aliasField isFirstResponder]) {
        [self.aliasField resignFirstResponder];
        return;
    }
    if ([self.emailAddressField isFirstResponder]) {
        [self.emailAddressField resignFirstResponder];
        return;
    }
    if ([self.passwordField isFirstResponder]) {
        [self.passwordField resignFirstResponder];
        return;
    }
    if ([self.confirmedPasswordField isFirstResponder]) {
        [self.confirmedPasswordField resignFirstResponder];
        return;
    }
    
    // 2. Make sure the user fills up all the format.
    if (! self.nameField.text ||
        [self.nameField.text length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill up the name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (! self.aliasField.text ||
        [self.aliasField.text length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill up the alias" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (! self.emailAddressField.text ||
        [self.emailAddressField.text length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill up the email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (! self.passwordField.text ||
        [self.passwordField.text length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill up the password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (! self.confirmedPasswordField.text ||
        [self.confirmedPasswordField.text length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill up the password again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // 3. Validate the email format.
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    if (! [emailTest evaluateWithObject:self.emailAddressField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"invalid email format" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
	// 4. Validate the two passwords should be the same.
    if (! [self.passwordField.text isEqualToString:self.confirmedPasswordField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"passwords don't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    // 5. Main task.
    
    [self registerWithName:self.nameField.text alias:self.aliasField.text email:self.emailAddressField.text password:self.passwordField.text confirmedPassword:self.confirmedPasswordField.text];
    
    NSLog(@"Did finish registration");
    [self.navigationController popViewControllerAnimated:YES];
    
    return;
	
#endif
	
	
#if Demo_Tag_Block_in_Block == 2
    
    NSLog(@"Demo_Tag_Block_in_Block (2)");
	
	Introspect		// the C macro to start describing your introspection.
    Guard_UIShouldNotBeFirstResponder(self.nameField),
    Guard_UIShouldNotBeFirstResponder(self.aliasField),
    Guard_UIShouldNotBeFirstResponder(self.emailAddressField),
    Guard_UIShouldNotBeFirstResponder(self.passwordField),
    Guard_UIShouldNotBeFirstResponder(self.confirmedPasswordField),
    
    Guard_StringShouldContainCharacters(self.nameField.text,				@"Please fill up the name"),
    Guard_StringShouldContainCharacters(self.aliasField.text,				@"Please fill up the alias"),
    Guard_StringShouldContainCharacters(self.emailAddressField.text,		@"Please fill up the email"),
    Guard_StringShouldContainCharacters(self.passwordField.text,			@"Please fill up the password"),
    Guard_StringShouldContainCharacters(self.confirmedPasswordField.text,	@"Please fill up the password again"),
    
    Guard_StringShouldBeAnEmailAdress(self.emailAddressField.text,			@"invalid email format"),
    Guard_StringShouldBeTheSame(self.passwordField.text,
								self.confirmedPasswordField.text, @"passwords don't match"),
    
    MainTask		// the C macro to start describing your main task.
    
    [self registerWithName:self.nameField.text alias:self.aliasField.text email:self.emailAddressField.text password:self.passwordField.text confirmedPassword:self.confirmedPasswordField.text];
    
	NSLog(@"Did finish registration using XIntrospect");
    [self.navigationController popViewControllerAnimated:YES];
    EndIntrospection		// the C macro to end using the instrospection.
	
#endif
}

- (void)viewDidLoad{
	[super viewDidLoad];
	printf("\n\n");
}

#pragma mark 
- (BOOL) registerWithName:(NSString*)name alias:(NSString*)alias email:(NSString*)email password:(NSString*)password confirmedPassword:(NSString*)confirmedPassword{
	// Mock implementation
    return YES;
}

#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 

- (IBAction)remind:(id)sender {
	NSLog(@"Do nothing in the method `-remind:`");
}

@end
