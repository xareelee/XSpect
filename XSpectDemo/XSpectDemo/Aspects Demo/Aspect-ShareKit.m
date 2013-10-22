


#import "XSpect.h"
#undef AtAspect
#define AtAspect ShareKitAspect

/*******************************************************************************
 
 This demonstrates how to encapsulate all changes for an aspect in a file.
 
 You can reuse this file in any project you use ShareKit.
 
 If you want to reuse this file, make sure you reset the configuration 
 and change the class-methods (like target-actions) you want to trigger the share 
 event.
 
 *******************************************************************************/

// ----------------------------------------
#import "ShareKit.h"
#import "DefaultSHKConfigurator.h"
@interface ShareKitConfigurator : DefaultSHKConfigurator
@end

@implementation ShareKitConfigurator
#pragma mark - App Description
/*
- (NSString*)appName{
    return @"XSpect demo";
}
- (NSString*)appURL{
    return @"https://github.com/xareelee/XSpect";
}
 */

#pragma mark - Other Settings
- (NSNumber *)isUsingCocoaPods {
    return @YES;
}

#pragma mark - UI Settings
- (NSNumber*)showActionSheetMoreButton{
    return @NO;
}
- (NSNumber*)shareMenuAlphabeticalOrder{
    return @NO;
}
- (NSNumber*)autoOrderFavoriteSharers{
    return @NO;
}
- (NSArray*)defaultFavoriteURLSharers {
    return @[@"SHKFacebook", @"SHKTwitter", @"SHKMail"];
}
- (NSArray*)defaultFavoriteImageSharers {
    return @[@"SHKFacebook", @"SHKTwitter", @"SHKMail"];
}
- (NSArray*)defaultFavoriteTextSharers {
    return @[@"SHKFacebook", @"SHKTwitter", @"SHKMail"];
}

#pragma mark - Service and API Keys Settings

#pragma mark Facebook
- (NSString*)facebookAppId{
    return @"219622978198425";
}

#pragma mark Twitter
- (NSString*)twitterConsumerKey{
    return @"86nruvaF3cg2LY812kLm2g";
}
- (NSString*)twitterSecret{
    return @"x6rhLAR1R2f4tbrV7Wav08Ikbgzwo6VwFesByDAhsw";
}

#pragma mark Mail
- (NSNumber*)sharedWithSignature {
	return @YES;
}

@end
// ----------------------------------------

// ----------------------------------------
#import "SHKConfiguration.h"
#import "AppDelegate.h"

AspectOfClass(AppDelegate)
WeaveAspectInstanceMethods(@selector(application:didFinishLaunchingWithOptions:));

AspectImplementation
- (BOOL)Aspect(application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions){
    
    // //////////////////////////////////////////// //
    // Set the configurator to ShareKit:
    [SHKConfiguration sharedInstanceWithConfigurator:[[ShareKitConfigurator alloc] init]];
    // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ //
    
    return [self Aspect(application:application didFinishLaunchingWithOptions:launchOptions)];
}
EndAspect
// ----------------------------------------


/*******************************************************************************
 
 This is Target-Action like. The class name is the target class, and the method name is the action name.
 
 You may add as many share events across classes as you want.
 
*******************************************************************************/

// ----------------------------------------
#import "XLViewController.h"

AspectOfClass(XLViewController)
WeaveAspectInstanceMethods(@selector(share:));

AspectImplementation
- (void)Aspect(share:(id)sender){
    
    SHKItem *item = [SHKItem text:@"XSpect is awesome!"];
    
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [SHK setRootViewController:self];
    [actionSheet showInView:self.view];

    [self Aspect(share:sender)];
}

EndAspect
// ----------------------------------------





