//
//  LogViewController.h
//  PillMinder
//
//  Created by Gemma Barlow on 7/13/13.
//
//

#import <MessageUI/MessageUI.h>

@interface LogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSString *medicationLogPath;

@end
