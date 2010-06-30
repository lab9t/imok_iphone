//
//  HTTPMessageViewController.m
//  IMOk
//
//  Created by Jason Brooks on 6/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HTTPMessageViewController.h"
#import "HTTPServerInterface.h"


@implementation HTTPMessageViewController

- (void)sendMessage:(id)sender
{
  [self startSendingStatus];
  [[HTTPServerInterface sharedInstance] sendMessage:self.message delegate:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  NSLog( @"MessageViewController connectionDidFinishLoading" );
  [self stopSendingStatus];
  [self messageDidSend:nil title:nil next:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  NSLog( @"MessageViewController connectionDidFailWithError: %@", [error localizedDescription] );
  [self stopSendingStatus];
  [self sendingDidFail:[error localizedDescription] title:nil];
}

@end
