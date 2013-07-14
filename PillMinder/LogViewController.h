//
//  LogViewController.h
//  PillMinder
//
//  Created by Gemma Barlow on 7/13/13.
//
//

#import <UIKit/UIKit.h>

@interface LogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *medicationLogPath;

@end
