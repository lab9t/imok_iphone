//
//  MessageViewController.h
//  IMOk
//
//  Created by Hansel Chung on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


extern const NSInteger kMaxMessageLength;
typedef enum {
  kMessageImOk,
  kMessageNeedHelp,
} MessageType;

@interface MessageViewController : UIViewController <UITextViewDelegate>
{
  IBOutlet UIView *contentView;
  
  IBOutlet UILabel *charsRemainingLabel;
  
  IBOutlet UILabel *locationPromptLabel;
  IBOutlet UIActivityIndicatorView *locationSpinner;
  IBOutlet UIButton *locationUpdateButton;
  IBOutlet UITextView *locationTextView;
  
  IBOutlet UILabel *messagePromptLabel;
  IBOutlet UITextView *messageTextView;
  
  IBOutlet UIButton *sendButton;
  IBOutlet UIView *sendingDimmer;
  IBOutlet UIActivityIndicatorView *sendingSpinner;
  IBOutlet UILabel *sendingStatusLabel;

  MessageType messageType;
  NSString *message;
  
  BOOL updatingLocation;
  BOOL sending;
}

@property (nonatomic, assign) MessageType messageType;
@property (nonatomic, retain) NSString *message;

-(IBAction)sendMessage:(id)sender;
-(IBAction)updateLocation:(id)sender;
-(IBAction)updateMessage:(id)sender;

- (void)startSendingStatus;
- (void)stopSendingStatus;
- (void)messageDidSend:(NSString *)result title:(NSString *)resultTitle next:(NSURL *)next;
- (void)sendingDidFail:(NSString *)errorMessage title:(NSString *)errorTitle;


@end
