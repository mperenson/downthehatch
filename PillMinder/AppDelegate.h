//
//  AppDelegate.h
//  PillMinder
//
//  Created by Melissa Perenson on 12/31/00.
//  Copyright (c) 2000 Flight of Fancy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

- (void) scheduleNotification:(NSInteger)minutesValue alertBody:(NSString*)alertBody;

@end
