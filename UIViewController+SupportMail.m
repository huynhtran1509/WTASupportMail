//
//  UIViewController+SupportMail.m
//  Thrillcall
//
//  Created by Matt Jones on 9/19/13.
//  Copyright (c) 2013 316 Ventures. All rights reserved.
//

#import "UIViewController+SupportMail.h"


@implementation UIViewController (SupportMail)


#pragma mark - Localization String Constants

static NSString * const TABLE_NAME = @"SupportMail";

static NSString * const APP_VERSION_LABEL_KEY = @"SMLabelAppVersion";
static NSString * const APP_VERSION_LABEL_DEFAULT = @"App Version";
static NSString * const APP_VERSION_LABEL_COMMENT = @"Application version summary label";

static NSString * const APP_NAME_LABEL_KEY = @"SMLabelAppName";
static NSString * const APP_NAME_LABEL_DEFAULT = @"App Name";
static NSString * const APP_NAME_LABEL_COMMENT = @"Application name summary label";

static NSString * const DEVICE_MODEL_LABEL_KEY = @"SMLabelDeviceModel";
static NSString * const DEVICE_MODEL_LABEL_DEFAULT = @"Model";
static NSString * const DEVICE_MODEL_LABEL_COMMENT = @"Device model summary label";

static NSString * const SYSTEM_VERSION_LABEL_KEY = @"SMLabelSystemVersion";
static NSString * const SYSTEM_VERSION_LABEL_DEFAULT = @"System Version";
static NSString * const SYSTEM_VERSION_LABEL_COMMENT = @"System version summary label";

static NSString * const MAIL_SENT_ALERT_TITLE_KEY = @"SMAlertTitleMailSent";
static NSString * const MAIL_SENT_ALERT_TITLE_DEFAULT = @"Mail Sent";
static NSString * const MAIL_SENT_ALERT_TITLE_COMMENT = @"Mail sent successful alert title";

static NSString * const MAIL_SENT_ALERT_MESSAGE_KEY = @"SMAlertMessageMailSent";
static NSString * const MAIL_SENT_ALERT_MESSAGE_DEFAULT = @"Your support message was sent successfully.";
static NSString * const MAIL_SENT_ALERT_MESSAGE_COMMENT = @"Mail sent successful alert message";

static NSString * const MAIL_SENT_CANCEL_BUTTON_KEY = @"SMAlertCancelButtonTitleMailSent";
static NSString * const MAIL_SENT_CANCEL_BUTTON_DEFAULT = @"OK";
static NSString * const MAIL_SENT_CANCEL_BUTTON_COMMENT = @"Mail sent successful alert cancel button title";

static NSString * const MAIL_FAIL_ALERT_TITLE_KEY = @"SMAlertTitleMailFail";
static NSString * const MAIL_FAIL_ALERT_TITLE_DEFAULT = @"Mail Send Failed";
static NSString * const MAIL_FAIL_ALERT_TITLE_COMMENT = @"Mail failure alert title";

static NSString * const MAIL_FAIL_ALERT_MESSAGE_KEY = @"SMAlertMessageMailFail";
static NSString * const MAIL_FAIL_ALERT_MESSAGE_DEFAULT = @"An error occurred while trying to send your support message. Please try again later.";
static NSString * const MAIL_FAIL_ALERT_MESSAGE_COMMENT = @"Mail failure alert message";

static NSString * const MAIL_FAIL_CANCEL_BUTTON_KEY = @"SMAlertCancelButtonTitleMailFail";
static NSString * const MAIL_FAIL_CANCEL_BUTTON_DEFAULT = @"OK";
static NSString * const MAIL_FAIL_CANCEL_BUTTON_COMMENT = @"Mail failure alert cancel button title";

static NSString * const MAIL_UNSUPPORTED_ALERT_TITLE_KEY = @"SMAlertTitleMailUnsupported";
static NSString * const MAIL_UNSUPPORTED_ALERT_TITLE_DEFAULT = @"Unable to Email";
static NSString * const MAIL_UNSUPPORTED_ALERT_TITLE_COMMENT = @"Mail unsupported alert title";

static NSString * const MAIL_UNSUPPORTED_ALERT_MESSAGE_KEY = @"SMAlertMessageMailUnsupported";
static NSString * const MAIL_UNSUPPORTED_ALERT_MESSAGE_DEFAULT = @"It appears your device does not support email.";
static NSString * const MAIL_UNSUPPORTED_ALERT_MESSAGE_COMMENT = @"Mail unsupported alert message";

static NSString * const MAIL_UNSUPPORTED_CANCEL_BUTTON_KEY = @"SMAlertCancelButtonTitleMailUnsupported";
static NSString * const MAIL_UNSUPPORTED_CANCEL_BUTTON_DEFAULT = @"OK";
static NSString * const MAIL_UNSUPPORTED_CANCEL_BUTTON_COMMENT = @"Mail unsupported alert cancel button title";


#pragma mark - Implementation Methods

- (void)presentMailComposeViewControllerToEmail:(NSString *)email
                                       animated:(BOOL)animated {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *vc = [MFMailComposeViewController new];
        vc.mailComposeDelegate = self;
        [vc setToRecipients:@[email]];
        [vc setMessageBody:[self deviceSummaryMessage] isHTML:YES];
        [self presentViewController:vc animated:animated completion:NULL];
    } else {
        [self emailUnsupported];
    }
}


#pragma mark - Device Info

- (NSDictionary *)applicationVersion {
    NSString *label = NSLocalizedStringWithDefaultValue(APP_VERSION_LABEL_KEY,
                                                        TABLE_NAME,
                                                        [NSBundle mainBundle],
                                                        APP_VERSION_LABEL_DEFAULT,
                                                        APP_VERSION_LABEL_COMMENT);
    
    NSString *value = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    
    return [NSDictionary dictionaryWithObject:value forKey:label];
}

- (NSDictionary *)applicationBundleName {
    NSString *label = NSLocalizedStringWithDefaultValue(APP_NAME_LABEL_KEY,
                                                        TABLE_NAME,
                                                        [NSBundle mainBundle],
                                                        APP_NAME_LABEL_DEFAULT,
                                                        APP_NAME_LABEL_COMMENT);
    
    NSString *value = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    
    return [NSDictionary dictionaryWithObject:value forKey:label];
}

- (NSDictionary *)deviceModel {
    NSString *label = NSLocalizedStringWithDefaultValue(DEVICE_MODEL_LABEL_KEY,
                                                        TABLE_NAME,
                                                        [NSBundle mainBundle],
                                                        DEVICE_MODEL_LABEL_DEFAULT,
                                                        DEVICE_MODEL_LABEL_COMMENT);
    
    NSString *value = [[UIDevice currentDevice] model];
    
    return [NSDictionary dictionaryWithObject:value forKey:label];
}

- (NSDictionary *)deviceSystemVersion {
    NSString *label = NSLocalizedStringWithDefaultValue(SYSTEM_VERSION_LABEL_KEY,
                                                        TABLE_NAME,
                                                        [NSBundle mainBundle],
                                                        SYSTEM_VERSION_LABEL_DEFAULT,
                                                        SYSTEM_VERSION_LABEL_COMMENT);
    
    NSString *value = [[UIDevice currentDevice] systemVersion];
    
    return [NSDictionary dictionaryWithObject:value forKey:label];
}

- (NSDictionary *)deviceSummary {
    NSMutableDictionary *summary = [NSMutableDictionary dictionary];
    [summary addEntriesFromDictionary:[self applicationVersion]];
    [summary addEntriesFromDictionary:[self applicationBundleName]];
    [summary addEntriesFromDictionary:[self deviceModel]];
    [summary addEntriesFromDictionary:[self deviceSystemVersion]];
    
    return summary;
}

- (NSString *)deviceSummaryMessage {
    NSMutableString *string = [NSMutableString stringWithString:@"<br/><br/><hr><blockquote>"];
    
    [[self deviceSummary] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"<strong>%@:</strong> %@<br/>",key , obj];
    }];
    
    [string appendString:@"</blockquote>"];
    
    return string;
}


#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    /* Mail compose result types
     MFMailComposeResultCancelled,
     MFMailComposeResultSaved,
     MFMailComposeResultSent,
     MFMailComposeResultFailed
     */
    
    switch (result) {
        case MFMailComposeResultSent:
            [self contactSupportMailSent];
            break;
        case MFMailComposeResultFailed:
            [self contactSupportMailFailed:error];
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}


- (void)contactSupportMailSent {
    NSString *title = NSLocalizedStringWithDefaultValue(MAIL_SENT_ALERT_TITLE_KEY,
                                                        TABLE_NAME,
                                                        [NSBundle mainBundle],
                                                        MAIL_SENT_ALERT_TITLE_DEFAULT,
                                                        MAIL_SENT_ALERT_TITLE_COMMENT);
    
    NSString *message = NSLocalizedStringWithDefaultValue(MAIL_SENT_ALERT_MESSAGE_KEY,
                                                          TABLE_NAME,
                                                          [NSBundle mainBundle],
                                                          MAIL_SENT_ALERT_MESSAGE_DEFAULT,
                                                          MAIL_SENT_ALERT_MESSAGE_COMMENT);
    
    NSString *cancelButton = NSLocalizedStringWithDefaultValue(MAIL_SENT_CANCEL_BUTTON_KEY,
                                                               TABLE_NAME,
                                                               [NSBundle mainBundle],
                                                               MAIL_SENT_CANCEL_BUTTON_DEFAULT,
                                                               MAIL_SENT_CANCEL_BUTTON_COMMENT);
    
    [self showAlertWithTitle:title message:message cancelButton:cancelButton];
}

- (void)contactSupportMailFailed:(NSError *)error {
    NSString *title = NSLocalizedStringWithDefaultValue(MAIL_FAIL_ALERT_TITLE_KEY,
                                                        TABLE_NAME,
                                                        [NSBundle mainBundle],
                                                        MAIL_FAIL_ALERT_TITLE_DEFAULT,
                                                        MAIL_FAIL_ALERT_TITLE_COMMENT);
    
    NSString *message = NSLocalizedStringWithDefaultValue(MAIL_FAIL_ALERT_MESSAGE_KEY,
                                                          TABLE_NAME,
                                                          [NSBundle mainBundle],
                                                          MAIL_FAIL_ALERT_MESSAGE_DEFAULT,
                                                          MAIL_FAIL_ALERT_MESSAGE_COMMENT);
    
    NSString *cancelButton = NSLocalizedStringWithDefaultValue(MAIL_FAIL_CANCEL_BUTTON_KEY,
                                                               TABLE_NAME,
                                                               [NSBundle mainBundle],
                                                               MAIL_FAIL_CANCEL_BUTTON_DEFAULT,
                                                               MAIL_FAIL_CANCEL_BUTTON_COMMENT);
    
    [self showAlertWithTitle:title message:message cancelButton:cancelButton];
}

- (void)emailUnsupported {
    NSString *title = NSLocalizedStringWithDefaultValue(MAIL_UNSUPPORTED_ALERT_TITLE_KEY,
                                                        TABLE_NAME,
                                                        [NSBundle mainBundle],
                                                        MAIL_UNSUPPORTED_ALERT_TITLE_DEFAULT,
                                                        MAIL_UNSUPPORTED_ALERT_TITLE_COMMENT);
    
    NSString *message = NSLocalizedStringWithDefaultValue(MAIL_UNSUPPORTED_ALERT_MESSAGE_KEY,
                                                          TABLE_NAME,
                                                          [NSBundle mainBundle],
                                                          MAIL_UNSUPPORTED_ALERT_MESSAGE_DEFAULT,
                                                          MAIL_UNSUPPORTED_ALERT_MESSAGE_COMMENT);
    
    NSString *cancelButton = NSLocalizedStringWithDefaultValue(MAIL_UNSUPPORTED_CANCEL_BUTTON_KEY,
                                                               TABLE_NAME,
                                                               [NSBundle mainBundle],
                                                               MAIL_UNSUPPORTED_CANCEL_BUTTON_DEFAULT,
                                                               MAIL_UNSUPPORTED_CANCEL_BUTTON_COMMENT);
    
    [self showAlertWithTitle:title message:message cancelButton:cancelButton];
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
              cancelButton:(NSString *)cancel {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:nil];
    [alert show];
}

@end
