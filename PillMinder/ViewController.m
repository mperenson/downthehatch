//
//  ViewController.m
//  PillMinder
//
//  Created by Melissa Perenson on 12/31/00.
//  Copyright (c) 2000 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIButton *setAlarm;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.stepper.alpha = 0.0f;
    self.valueLabel.alpha = 0.0f;
    self.instructionLabel.alpha = 0.0f;
    self.setAlarm.alpha = 0.0f;
    
    
    [self setValueFromStepper];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)downTheHatchPressed:(id)sender 
{
    [UIView animateWithDuration:0.7f animations:^{
        self.stepper.alpha = 1.0f;
        self.valueLabel.alpha = 1.0f;
        self.instructionLabel.alpha = 1.0f;
        self.setAlarm.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}


- (IBAction)stepperChanged:(id)sender
{
    NSLog(@"Stepper Changed! %.1f", self.stepper.value);
    [self setValueFromStepper];
    
}


- (IBAction)setAlarmTapped:(id)sender
{
    [self scheduleNotification: self.stepper.value];
    NSLog(@"Alarm set");
    self.stepper.alpha = 0.0f;
    self.valueLabel.alpha = 0.0f;
    self.instructionLabel.alpha = 0.0f;
    self.setAlarm.alpha = 0.0f;
    
    
}

- (void) setValueFromStepper
{
    self.valueLabel.text = [NSString stringWithFormat:@"%.1f hours from now", self.stepper.value];
}

- (void) scheduleNotification:(CGFloat)hoursValue
{
    // Convert hours to seconds
    
    NSInteger seconds = hoursValue * 3600;
    
    NSLog(@"Setting alarm for %d seconds", seconds);
    
    // Schedule local notification
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.alertBody = @"Go to the Dose Me!";
    
   notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:seconds];

    notification.applicationIconBadgeNumber=1;
    
    NSLog(@"Local Notification %@", notification);
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //[[UIApplication sharedApplication] presentLocalNotificationNow:self.localNot];
}


- (void) previousFunctionality
{
    
    NSLog(@"Down the Hatch was Pressed!");
    
    UIAlertView *newAlertView = [[UIAlertView alloc] initWithTitle:@"Button Pressed"
                                                           message:@"Down the Hatch was pressed"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
    
    [newAlertView show];
    
    self.localNot = [[UILocalNotification alloc] init];
    
    self.localNot.alertBody = @"Go to the app!";
    
    self.localNot.fireDate = [NSDate dateWithTimeIntervalSinceNow:20];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:self.localNot];
    
    self.boolProperty = FALSE;
    
    self.integerProperty = 43;
   
}


@end
