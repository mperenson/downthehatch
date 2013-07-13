//
//  ViewController.h
//  PillMinder
//
//  Created by Melissa Perenson on 12/31/00.
//  Copyright (c) 2000 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)downTheHatchPressed:(id)sender;

@property int integerProperty;
@property BOOL boolProperty;

@property BOOL needsToEat;
@property BOOL needsToTakeMed1;

@property (strong) UILocalNotification *localNot;

@end
