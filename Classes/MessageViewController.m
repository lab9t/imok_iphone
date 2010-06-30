//
//  MessageViewController.m
//  IMOk
//
//  Created by Hansel Chung on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MessageSentViewController.h"
#import "MessageViewController.h"
#import "LCCoreLocationDelegate.h"


NSInteger const kMaxMessageLength = 160;

@interface MessageViewController()
- (void)updateCharsRemaining;
- (void)startLocationUpdateStatus;
- (void)stopLocationUpdateStatus;
- (void)locationDidUpdate:(CLLocation *)location;
- (void)locationUpdateDidFail:(NSString *)errorMessage;
@end

@implementation MessageViewController

@synthesize messageType, message;

#pragma mark -
#pragma mark Initialization

// The designated initializer.  Override if you create the controller 
// programmatically and want to perform customization that is not appropriate 
// for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
  {
    self.messageType = kMessageImOk;
    
    updatingLocation = NO;
    sending = NO;
  }
  return self;
}

// Implement viewDidLoad to do additional setup after loading the view, 
// typically from a nib.
- (void)viewDidLoad 
{
  [super viewDidLoad];

  if ( messageType == kMessageImOk )
  {
    self.title = @"I'm OK!";
    locationPromptLabel.text = @"Your location (optional)";
    messagePromptLabel.text = @"Your message (optional)";
  }
  else if ( messageType == kMessageNeedHelp )
  {
    self.title = @"I Need Help!";
    locationPromptLabel.text = @"Your location";
    messagePromptLabel.text = @"Your emergency (hurt? trapped?)";
  }
  
  UIScrollView *scrollView = (UIScrollView *) self.view;
  // TODO: should be calculating the content size dynamically
  scrollView.contentSize = CGSizeMake( 320, 460 );

  sendingDimmer.hidden = YES;
  sendingDimmer.alpha = 0.0;
  
  // Register for LC notifications
  [[NSNotificationCenter defaultCenter] addObserver:self 
    selector:@selector( didReceiveLocationNotification: ) 
    name:LCCoreLocationUpdateAvailable object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self 
    selector:@selector( didReceiveLocationNotification: ) 
    name:LCCoreLocationUpdateFailed object:nil];
  
  [self updateMessage:nil];
  [self updateCharsRemaining];
  [self updateLocation:nil];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
  // titleLabel = nil;
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
  charsRemainingLabel = nil;
  
  locationPromptLabel = nil;
  locationSpinner = nil;
  locationUpdateButton = nil;
  locationTextView = nil;
  
  messagePromptLabel = nil;
  messageTextView = nil;
  
  sendButton = nil;
  sendingDimmer = nil;
  sendingSpinner = nil;
  sendingStatusLabel = nil;

  contentView = nil;

  self.message = nil;
}


- (void)dealloc 
{
  [charsRemainingLabel release];
  
  [locationPromptLabel release];
  [locationSpinner release];
  [locationUpdateButton release];
  [locationTextView release];
  
  [messagePromptLabel release];
  [messageTextView release];
  
  [sendButton release];
  [sendingDimmer release];
  [sendingSpinner release];
  [sendingStatusLabel release];

  [contentView release];

  [message release];

  [super dealloc];
}

#pragma mark -
#pragma mark TextView Callbacks

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
  return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  // Look for a newline as an indicator to dismiss the keyboard
  // (and make sure to reject the newline as a text change)
  if ( [text isEqualToString:@"\n"] )
  {
    [textView resignFirstResponder];
    return NO;
  }
  
  return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
  [self updateMessage:nil];
}

- (void)doSetTextView:(UITextView *)textView text:(NSString *)text
{
  textView.text = text;
  [self textViewDidChange:textView];
}

- (BOOL)doHasText:(UITextView *)textView
{
  return [textView hasText] || textView.text.length > 0;
}

- (void)updateCharsRemaining
{
  NSInteger remaining = kMaxMessageLength - message.length;
  charsRemainingLabel.text = 
    [NSString stringWithFormat:@"Characters remaining: %@", 
      ( remaining < 0 ) ? @"TOO LONG" : [NSString stringWithFormat:@"%i", remaining]];
}


#pragma mark -
#pragma mark Actions

- (IBAction)updateMessage:(id)sender
{
  if ( ![NSThread isMainThread] )
  {
    [self performSelectorOnMainThread:@selector(updateMessage:) withObject:sender waitUntilDone:NO];
    return;
  }
  
  // TODO: create a more robust message builder?
  self.message = [NSString stringWithFormat:@"%@ %@ %@",
                  [self doHasText:messageTextView] ? messageTextView.text : @"",
                  ( messageType == kMessageImOk ) ? @"#imok" : @"#needhelp",
                  [self doHasText:locationTextView] ? [NSString stringWithFormat:@"#loc %@", locationTextView.text] : @""];
  
  NSLog( @"Built message: \"%@\"", message );
  
  [self updateCharsRemaining];
                  
  if ( self.message.length > kMaxMessageLength )
    sendButton.enabled = NO;
  else
    sendButton.enabled = YES;
}

- (IBAction)updateLocation:(id)sender 
{
  [self startLocationUpdateStatus];
  [[LCCoreLocationDelegate sharedInstance].locationManager startUpdatingLocation];  
}


#pragma mark -
#pragma mark Message Sending

- (IBAction)sendMessage:(id)sender
{
  // do nothing -- this will be handled by the subclasses
}

- (void)messageDidSend:(NSString *)result title:(NSString *)resultTitle next:(NSURL *)next
{
  MessageSentViewController *vc = [[MessageSentViewController alloc] initWithNibName:@"MessageSentViewController" bundle:nil];
  vc.titleText = resultTitle;
  vc.messageText = result;
  vc.redirectUrl = next;
  
  NSArray *controllers = [NSArray arrayWithObjects:[self.navigationController.viewControllers objectAtIndex:0], vc, nil];
  [vc release];
  [self.navigationController setViewControllers:controllers animated:YES];
}

- (void)sendingDidFail:(NSString *)errorMessage title:(NSString *)errorTitle
{
  if ( !errorTitle )
    errorTitle = @"Sending Failed";
  UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil] autorelease];
  [alert show];  
}

- (void)startSendingStatus
{
  if ( !sending )
  {
    sending = YES;
    sendingDimmer.hidden = NO;
    [sendingSpinner startAnimating];
    [UIView beginAnimations:@"StartSendingStatus" context:nil];
    [UIView setAnimationDuration:0.5];
    sendingDimmer.alpha = 1.0;
    [UIView commitAnimations];
  }
}

- (void)stopSendingStatus
{
  if ( sending )
  {
    sending = NO;
    [sendingSpinner stopAnimating];
    [UIView beginAnimations:@"StopSendingStatus" context:nil];
    [UIView setAnimationDuration:0.5];
    sendingDimmer.alpha = 0.0;
    sendingDimmer.hidden = YES;
    [UIView commitAnimations];
  }
}


#pragma mark -
#pragma mark Location Updates

- (void)didReceiveLocationNotification:(NSNotification *)notification
{
  // Make sure to do the updates on the Main Thread
  if ( ![NSThread isMainThread] )
  {
    [self performSelectorOnMainThread:@selector(handleLocationNotification:) withObject:notification waitUntilDone:NO];
    return;
  }

  NSString *type = [notification name];
  NSDictionary *info = [notification userInfo];
  if ( [type isEqualToString:LCCoreLocationUpdateAvailable] )
  {
    CLLocation *location = [info valueForKey:kLCNewLocation];
    [self locationDidUpdate:location];
  }
  else if ( [type isEqualToString:LCCoreLocationUpdateFailed] )
  {
    NSString *errorMessage = [info valueForKey:kLCLocationError];
    [self locationUpdateDidFail:errorMessage];
  }
}

- (void)locationDidUpdate:(CLLocation *)location 
{
	NSLog( @"locationDidUpdate: %@", location );
  if ( updatingLocation )
  {
    [self stopLocationUpdateStatus];
    // locationTextView.text = [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];   
    // hack because UITextView does NOT fire events when setting text programmatically
    [self doSetTextView:locationTextView text:[NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude]];
    [self updateMessage:nil];
  }
}

- (void)locationUpdateDidFail:(NSString *)errorMessage
{
  NSLog( @"locationUpdateDidFail: %@", errorMessage );
  if ( updatingLocation )
  {
    [self stopLocationUpdateStatus];
  }
}

- (void)startLocationUpdateStatus
{
  if ( !updatingLocation )
  {
    updatingLocation = YES;
    [locationSpinner startAnimating];
    locationUpdateButton.userInteractionEnabled = NO;
    locationUpdateButton.hidden = YES;
  }    
}

- (void)stopLocationUpdateStatus
{
  if ( updatingLocation )
  {
    updatingLocation = NO;
    locationUpdateButton.userInteractionEnabled = YES;
    locationUpdateButton.hidden = NO;
    [locationSpinner stopAnimating];
  }
}

@end
