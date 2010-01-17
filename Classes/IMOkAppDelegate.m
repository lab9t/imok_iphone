//
//  IMOkAppDelegate.m
//  IMOk
//
//  Created by Eric Park on 11/13/09.
//  Copyright NASA Ames Research Center 2009. All rights reserved.
//

#import "IMOkAppDelegate.h"
#import "IMOkViewController.h"

#import "LCCoreLocationDelegate.h"

@implementation IMOkAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	[[LCCoreLocationDelegate sharedInstance] setDelegate:viewController];

	NSString* gatewaynumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"gatewaynumber"];
	if ([gatewaynumber length] == 0) {
		[[NSUserDefaults standardUserDefaults] setObject:@"6504171034" forKey:@"gatewaynumber"];	// Default gateway numbers.
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[LCCoreLocationDelegate sharedInstance].locationManager stopUpdatingLocation];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
