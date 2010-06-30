//
//  SMSMessageViewController.h
//  IMOk
//
//  Created by Jason Brooks on 6/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "MessageViewController.h"

/*
 The SMSMessageViewController looks for settings in LocalSMSSettings.plist:
 
 - SmsGatewayNumber : Phone Number of the SMS Gateway    (ex. 6505551234)
 - SmsAppUrl        : Phone Number of the Sender's Phone (ex. sms:1-650-555-1234)
 */
@interface SMSMessageViewController : MessageViewController 
  <MFMessageComposeViewControllerDelegate> 
{
  NSString *smsGatewayNumber;
  NSString *smsAppUrl;
}

@property (nonatomic, retain) NSString *smsGatewayNumber;
@property (nonatomic, retain) NSString *smsAppUrl;

@end
