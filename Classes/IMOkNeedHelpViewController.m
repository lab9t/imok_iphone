//
//  IMOkNeedHelpViewController.m
//  IMOk
//
//  Created by Jason Brooks on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IMOkNeedHelpViewController.h"
#import "MessageViewController.h"


@implementation IMOkNeedHelpViewController

@synthesize messageLabel, imOkButton, needHelpButton;

/*
 // The designated initializer.  Override if you create the controller 
 // programmatically and want to perform customization that is not appropriate 
 // for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, 
// typically from a nib.
- (void)viewDidLoad 
{
  [super viewDidLoad];
  self.navigationItem.backBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style: UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil]; 
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
    
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  [messageLabel release], messageLabel = nil;
  [imOkButton release], imOkButton = nil;
  [needHelpButton release], needHelpButton = nil;
}

- (void)handleImOk:(id)sender
{
  if ( sender == imOkButton )
  {
    MessageViewController *vc = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    vc.messageType = kMessageImOk;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
  }
}

- (void)handleNeedHelp:(id)sender
{
  if ( sender == needHelpButton )
  {
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"If you need immediate help, you should call your local emergency phone number, such as 911. Messages sent by this app may not reach emergency responders." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil] autorelease];
    [alertView show];

    MessageViewController *vc = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    vc.title = @"I Need Help!";
    vc.messageType = kMessageNeedHelp;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
  }
}

- (void)dealloc 
{
  [messageLabel release];
  [imOkButton release];
  [needHelpButton release];
  [super dealloc];
}


@end
