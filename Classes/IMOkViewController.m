//
//  IMOkViewController.m
//  IMOk
//
//  Created by Eric Park on 11/13/09.
//  Copyright NASA Ames Research Center 2009. All rights reserved.
//

#import "IMOkViewController.h"
#import "HTTPServerInterface.h"
#import "LCCoreLocationDelegate.h"
#import "JSON.h"

@implementation IMOkViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
  [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[[LCCoreLocationDelegate sharedInstance].locationManager startUpdatingLocation];
	[spinner startAnimating];
	[statusField setText:@"Obtaining location..."];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[ageViewController release]; ageViewController = nil;
	[configViewController release]; configViewController = nil;

  [super dealloc];
}

#pragma mark Actual code stuff
//
//-(IBAction)call911:(id)sender {
//	// Okay, so it doesn't actually call 911. In fact, it calls your cell phone's customer service line. :P
//	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:611"]];
//}
//
//- (void)sendMessage:(CLLocation*)location {
//	
//	/*
//	 IMOk:
//	 http://imok.jeztek.com/data/imok/<user id>/?lat=0.0&lon=0.0
//	 
//	 Response:
//	 {"result" : True}
//	 {"result" : False}
//	 */
//	
//	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://imok.jeztek.com/data/imok/%@/?lat=%f&lon=%f",
//									   [[NSUserDefaults standardUserDefaults] valueForKey:@"userKey"],
//									   location.coordinate.latitude,
//									   location.coordinate.longitude]];
//	
//	NSLog(@"url: %@", url);
//	NSString* returnText = [[HTTPServerInterface sharedInstance] sendHTTPPost:url withStringBody:@""];
//	
//	
//	id jsonValue = [returnText JSONValue];
//	NSLog(@"jsonString: %@", jsonValue);
//	
//	if ([jsonValue boolForKey:@"result"]) {
//		// Success!		
//		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Notification to I'm Ok sent!"
//															message:[NSString stringWithFormat:@"Thanks, %@!", [[NSUserDefaults standardUserDefaults] valueForKey:@"firstName"]]
//														   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//		[alertView show];
//		[alertView release];
//	}
//	else {
//		// Fail :(
//		[[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userKey"];
//		
//		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Oops!"
//															message:@"Sorry, something went wrong communicating with I'm Ok. Please try again."
//														   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//		[alertView show];
//		[alertView release];
//	}	
//}
//
-(IBAction)iAmOkayButton:(id)sender {
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"gatewaynumber"]]];
	[[UIApplication sharedApplication] openURL:url];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//	[spinner stopAnimating];
//}

-(IBAction)runSetup:(id)sender {
	if (configViewController == nil) {
		configViewController = [[ConfigViewController alloc] init];
	}
	[self presentModalViewController:configViewController animated:YES];
}


-(void)newLocationUpdate:(CLLocation *)location {
	NSLog(@"newLocationUpdate: %@", location);
	NSString* locationString = [NSString stringWithFormat:@"Latitude:%f Long:%f",
								location.coordinate.latitude, location.coordinate.longitude];
	
	
	if ([spinner isAnimating]) {
		// Note: sometimes we get back a empty location, try going through the check again.
		[statusField setText:@"Location acquired: sent to pasteboard"];
		
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		pasteboard.string = [NSString stringWithFormat:@"I'm at %@", locationString];

		if ([spinner isAnimating]) {
			[spinner stopAnimating];
		}
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if ([error code] == kCLErrorDenied) {
		[statusField setText:@"Location denied by user..."];
		if ([spinner isAnimating]) {
			[spinner stopAnimating];
		}
		[[LCCoreLocationDelegate sharedInstance].locationManager stopUpdatingLocation];
	}
	else {
		[statusField setText:@"Could not get location..."];
	}
}

@end
