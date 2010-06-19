//
//  IMOkNeedHelpViewController.h
//  IMOk
//
//  Created by Jason Brooks on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IMOkNeedHelpViewController : UIViewController
{
  UILabel *messageLabel;
  UIButton *imOkButton;
  UIButton *needHelpButton;
}

@property (nonatomic, retain, readonly) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain, readonly) IBOutlet UIButton *imOkButton;
@property (nonatomic, retain, readonly) IBOutlet UIButton *needHelpButton;

- (IBAction) handleImOk:(id)sender;
- (IBAction) handleNeedHelp:(id)sender;


@end
