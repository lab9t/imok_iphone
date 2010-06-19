//
//  HTTPServerInterface.h
//  IMOk
//
//  Created by Hansel Chung on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The HTTP Server Interface looks for settings in HTTPLocalSettings.plist:
 
 - SmsGatewayUrl     : URL of the SMS Gateway Server
 - SmsGatewayNumber  : Phone Number of the SMS Gateway
 - SmsSenderNumber   : Phone Number of the Sender's Phone
 - AccountSid        : 34 character MD5 sum
 - SmsId             : 34 character MD5 sum
 - X-Twilio_Signature: Magic signature string for X-Twilio
 */
@interface HTTPServerInterface : NSObject 
{
  NSDictionary *localSettings;
}

+ (HTTPServerInterface*)sharedInstance;

- (NSString *)sendMessage:(NSString *)message;
- (void)sendMessage:(NSString *)message delegate:(id)delegate;

- (NSString *)sendHTTPPost:(NSURL *)url withStringBody:(NSString *)body;
- (void)sendHTTPPost:(NSURL *)url withStringBody:(NSString *)body delegate:(id)delegate;

@end
