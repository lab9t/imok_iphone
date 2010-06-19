//
//  HTTPServerInterface.m
//  IMOk
//
//  Created by Hansel Chung on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HTTPServerInterface.h"

#pragma mark -
#pragma mark Private Interface
@interface HTTPServerInterface()
- (NSString *)settingForKey:(NSString *)key;
- (NSString *)settingForKey:(NSString *)key defaultValue:(NSString *)value;
@end


#pragma mark -
#pragma mark Implementation
static HTTPServerInterface* sharedInstance = nil;

@implementation HTTPServerInterface

#pragma mark -
#pragma mark Object Lifecycle

+ (HTTPServerInterface*)sharedInstance {
	if (sharedInstance == nil)
		sharedInstance = [[HTTPServerInterface alloc] init];
	return sharedInstance;
}

- (id)init 
{
	self = [super init];
	if (self != nil) 
  {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"LocalHTTPSettings" ofType:@"plist"];
    localSettings = [[NSDictionary alloc] initWithContentsOfFile:path];
	}
	return self;
}

- (void)dealloc 
{
  [localSettings release];
	[super dealloc];
}

#pragma mark -
#pragma mark HTTP Interface (Synchronous)

- (NSString *)sendMessage:(NSString *)message
{
  NSURL *url = [NSURL URLWithString:[self settingForKey:@"SmsGatewayUrl" defaultValue:@"http://www.example.com"]];
  
  NSString *content = 
    [NSString stringWithFormat:@"To=%@&From=%@&Body=%@&AccountSid=%@&SmsId=%@", 
     [self settingForKey:@"SmsGatewayNumber" defaultValue:@"6505554321"],
     [self settingForKey:@"SmsSenderNumber" defaultValue:@"6505551234"],
     message,
     [self settingForKey:@"AccountSid" defaultValue:@"AA23352c470dae78a287969f02d5c93f73"],
     [self settingForKey:@"SmsId" defaultValue:@"AA96f5f104829da933e862ef7e4db4c732"]];
  
  return [self sendHTTPPost:url withStringBody:content];
}


- (NSString *)sendHTTPPost:(NSURL *)url withStringBody:(NSString *)body 
{
	NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setValue:[self settingForKey:@"X-Twilio_Signature" defaultValue:@"foo"] forHTTPHeaderField:@"X-Twilio_Signature"];
	[request setHTTPBody:postData];
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *urlReturnData = [[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] retain];
	NSString* result = nil;
	if ( urlReturnData == nil ) 
  {
		NSLog( @"HTTPServerInterface: No return data from URL." );
	}
	else {
    NSLog( @"HTTPServerInterface: Received return data from URL." );
		result = [[[NSString alloc] initWithData:urlReturnData encoding:NSUTF8StringEncoding] autorelease];
	}
  
	[urlReturnData release];
	[request release];
  
	return result;
}


#pragma mark -
#pragma mark HTTP Interface (Asynchronous)

- (void)sendMessage:(NSString *)message delegate:(id)delegate
{
  NSURL *url = [NSURL URLWithString:[self settingForKey:@"SmsGatewayUrl" defaultValue:@"http://www.example.com"]];
  
  NSString *content = 
  [NSString stringWithFormat:@"To=%@&From=%@&Body=%@&AccountSid=%@&SmsId=%@", 
   [self settingForKey:@"SmsGatewayNumber" defaultValue:@"6505554321"],
   [self settingForKey:@"SmsSenderNumber" defaultValue:@"6505551234"],
   message,
   [self settingForKey:@"AccountSid" defaultValue:@"AA23352c470dae78a287969f02d5c93f73"],
   [self settingForKey:@"SmsId" defaultValue:@"AA96f5f104829da933e862ef7e4db4c732"]];
  
  return [self sendHTTPPost:url withStringBody:content delegate:delegate];
}

- (void)sendHTTPPost:(NSURL *)url withStringBody:(NSString *)body delegate:(id)delegate
{  
  NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setValue:[self settingForKey:@"X-Twilio_Signature" defaultValue:@"foo"] forHTTPHeaderField:@"X-Twilio_Signature"];
	[request setHTTPBody:postData];
  
  [NSURLConnection connectionWithRequest:request delegate:delegate];
  [request release];
}


#pragma mark -
#pragma mark Settings Methods
- (NSString *)settingForKey:(NSString *)key
{
  return (NSString *) [localSettings valueForKey:key];
}

- (NSString *)settingForKey:(NSString *)key defaultValue:(NSString *)value
{
  NSString *setting = [self settingForKey:key];
  return setting ? setting : value;
}


#pragma mark ---- singleton object methods ----

// See "Creating a Singleton Instance" in the Cocoa Fundamentals Guide for more info
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
