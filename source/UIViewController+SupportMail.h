//
//  UIViewController+SupportMail.h
//  Thrillcall
//
//  Created by Matt Jones on 9/19/13.
//  Copyright (c) 2013 Willow Tree Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface UIViewController (SupportMail) <MFMailComposeViewControllerDelegate>

/*
 @method presentModalMailComposeViewControllerAnimated:
 @abstract Presents a view controller modally for composing a mail message and handles it's lifecyle.
 @param email the support email address
 @param animated If the presentation should be animated or not
 */
- (void)presentMailComposeViewControllerToEmail:(NSString *)email
                                       animated:(BOOL)animated;

/*
 @method presentModalMailComposeViewControllerAnimated:
 @abstract Presents a view controller modally for composing a mail message and handles it's lifecyle.
 @param email the support email address
 @param subject the subject of the email
 @param animated If the presentation should be animated or not
 */
- (void)presentMailComposeViewControllerToEmail:(NSString *)email
                                    withSubject:(NSString *)subject
                                       animated:(BOOL)animated;

@end
