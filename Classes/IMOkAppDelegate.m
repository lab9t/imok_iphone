//
//  IMOkAppDelegate.m
//  IMOk
//
//  Created by Eric Park on 11/13/09.
//  Copyright NASA Ames Research Center 2009. All rights reserved.
//

#import "IMOkAppDelegate.h"
#import "IMOkNeedHelpViewController.h"
#import "LCCoreLocationDelegate.h"


@implementation IMOkAppDelegate

@synthesize window;
@synthesize viewController, navController;


#pragma mark -
#pragma mark Application Lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{      
  UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:viewController];
  nc.delegate = self;
  self.navController = nc;
  viewController.title = @"I'm OK!";
  [nc release];
  
  [application setStatusBarHidden:NO];
  [window addSubview:navController.view];
  [window makeKeyAndVisible];
	
	NSString* gatewaynumber = [[NSUserDefaults standardUserDefaults] stringForKey:@"gatewaynumber"];
	if ([gatewaynumber length] == 0) {
		[[NSUserDefaults standardUserDefaults] setObject:@"6504171034" forKey:@"gatewaynumber"];	// Default gateway numbers.
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[LCCoreLocationDelegate sharedInstance].locationManager stopUpdatingLocation];
}

- (void)dealloc 
{
  [viewController release];
  [window release];
  [super dealloc];
}


#pragma mark -
#pragma mark UINavigationController Callbacks

// Hide the navigation bar for the root view controller; show it for all others
- (void)navigationController:(UINavigationController *)nc 
      willShowViewController:(UIViewController *)vc animated:(BOOL)animated
{
  [nc setNavigationBarHidden:(vc == viewController) animated:animated];
}

- (void)navigationController:(UINavigationController *)nc 
       didShowViewController:(UIViewController *)vc animated:(BOOL)animated
{
  // nothing to do
}


@end
