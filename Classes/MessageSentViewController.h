//
//  MessageSentViewController.h
//  IMOk
//
//  Created by Jason Brooks on 6/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageSentViewController : UIViewController {
  UILabel *titleLabel;
  UITextView *messageTextView;
  UIButton *redirectButton;
  
  NSString *titleText;
  NSString *messageText;
  NSURL *redirectUrl;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UITextView *messageTextView;
@property (nonatomic, retain) IBOutlet UIButton *redirectButton;

@property (nonatomic, retain) NSString *titleText;
@property (nonatomic, retain) NSString *messageText;
@property (nonatomic, retain) NSURL *redirectUrl;

- (IBAction)handleRedirect:(id)sender;

@end
