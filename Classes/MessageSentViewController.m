//
//  MessageSentViewController.m
//  IMOk
//
//  Created by Jason Brooks on 6/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessageSentViewController.h"


@interface MessageSentViewController()
- (void)updateUI;
@end


NSString * const DefaultMessageTitle = @"Your message has been sent.";
NSString * const DefaultMessageText = @"We will send you a confirmation message by SMS once we receive it.";


@implementation MessageSentViewController

@synthesize titleLabel, messageTextView, redirectButton;
@synthesize titleText, messageText, redirectUrl;

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
  [self updateUI];
  [super viewDidLoad];
}

// Overridden to update the titleLabel text
- (void)setTitleText:(NSString *)text
{
  if ( ![titleText isEqual:text] )
  {
    [titleText release];
    titleText = [text retain];
    [self updateUI];
  }
}

// Overridden to update the messageView text
- (void)setMessageText:(NSString *)text
{
  if ( ![messageText isEqual:text] )
  {
    [messageText release];
    messageText = [text retain];
    [self updateUI];
  }
}

// Overridden to set the hidden state of the redirectButton
- (void)setRedirectUrl:(NSURL *)url
{
  if ( ![redirectUrl isEqual:url] )
  {
    [redirectUrl release];
    redirectUrl = [url retain];
    [self updateUI];
  }
}

- (void)updateUI
{
  self.titleLabel.text = titleText ? titleText : DefaultMessageTitle;
  self.messageTextView.text = messageText ? messageText : DefaultMessageText;
  self.redirectButton.hidden = ( self.redirectUrl == nil ) ? YES : NO;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)handleRedirect:(id)sender
{
  if ( sender == redirectButton )
    if ( self.redirectUrl )
      [[UIApplication sharedApplication] openURL:redirectUrl];
}

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
  self.titleLabel = nil;
  self.messageTextView = nil;
  self.redirectButton = nil;
}


- (void)dealloc 
{
  [titleLabel release];
  [messageTextView release];
  [redirectButton release];
  
  [titleText release];
  [messageText release];
  [redirectUrl release];
  
  [super dealloc];
}


@end
