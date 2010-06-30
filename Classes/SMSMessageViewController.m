//
//  SMSMessageViewController.m
//  IMOk
//
//  Created by Jason Brooks on 6/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SMSMessageViewController.h"


@implementation SMSMessageViewController

@synthesize smsGatewayNumber, smsAppUrl;


// The designated initializer.  Override if you create the controller 
// programmatically and want to perform customization that is not appropriate 
// for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
  {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"LocalSMSSettings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    self.smsGatewayNumber = [settings valueForKey:@"SmsGatewayNumber"];
    self.smsAppUrl = [settings valueForKey:@"SmsAppUrl"];
    
    NSLog( @"SMSMessageViewController initialized with smsGatewayNumber=\"%@\" and smsAppUrl=\"%@\"", self.smsGatewayNumber, self.smsAppUrl );
    
    if ( smsGatewayNumber && !smsAppUrl )
    {
      self.smsAppUrl = [NSString stringWithFormat:@"sms:%@", smsGatewayNumber];
      NSLog( @"SMSMessageViewController using smsGatewayNumber to set initial smsAppUrl to \"%@\"", self.smsAppUrl );
    }
    else if ( !smsGatewayNumber )
    {
      self.smsGatewayNumber = @"6505551234";
      self.smsAppUrl = @"sms:1-650-555-1234";
      NSLog( @"SMSMessageViewController WARN: no smsGatewayNumber specified, using \"%@\" instead.", self.smsGatewayNumber );
    }
  }
  
  return self;
}

- (void)sendMessage:(id)sender 
{
  // Cannot reference the class statically or else the linker will try
  // to resolve it at runtime
  Class mcvcClass = NSClassFromString( @"MFMessageComposeViewController" );
  if ( mcvcClass )
  {
    // MFMessageComposeViewController *mcvc = [[MFMessageComposeViewController alloc] init];
    id mcvc = [[mcvcClass alloc] init];
    [mcvc setMessageComposeDelegate:self];
    [mcvc setBody:self.message];
    [mcvc setRecipients:[NSArray arrayWithObject:self.smsGatewayNumber]];
    NSLog( @"Launching SMS Composer with gateway number: %@...", self.smsGatewayNumber );
    [self presentModalViewController:mcvc animated:YES];
    [mcvc release];
  }
  else 
  {
    NSLog( @"UNEXPECTED ERROR: unable to load MFMessageComposeViewController class" );
  }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)mcvc didFinishWithResult:(MessageComposeResult)result
{
  [self dismissModalViewControllerAnimated:YES];
  switch ( result )
  {
    case MessageComposeResultSent:
      NSLog( @"... SMS message sent" );
      [self messageDidSend:@"Your message has been sent by SMS. Touch the button below to go to the SMS app to make sure that your message has been sent successfully. We will send you a confirmation message by SMS once we receive it." title:nil next:[NSURL URLWithString:self.smsAppUrl]];
      break;
    case MessageComposeResultFailed:
      NSLog( @"... SMS message failed" );
      [self sendingDidFail:@"Your message could not be sent. Please try again." title:nil];
      break;
    default:
      NSLog( @"... SMS message cancelled." );
  }
}


@end
