//
//  IMOkAppDelegate.h
//  IMOk
//
//  Created by Eric Park on 11/13/09.
//  Copyright NASA Ames Research Center 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMOkNeedHelpViewController;

@interface IMOkAppDelegate : NSObject <UIApplicationDelegate> {
  UINavigationController *navController;
  UIWindow *window;
  IMOkNeedHelpViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) IBOutlet IMOkNeedHelpViewController *viewController;

@end

