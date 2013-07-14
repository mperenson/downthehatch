//
//  ViewController.m
//  PillMinder
//
//  Created by Melissa Perenson on 12/31/00.
//  Copyright (c) 2000 Flight of Fancy LLC. All rights reserved.
//

#import "ViewController.h"
#import "LogViewController.h"

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

- (void) setValueFromStepper
{
    self.valueLabel.text = [NSString stringWithFormat:@"%.1f hours from now", self.stepper.value];
}

- (void) scheduleNotification:(CGFloat)hoursValue alertBody:(NSString*)alertBody
{
    // Convert hours to seconds
    NSInteger seconds = hoursValue * 60;
    NSLog(@"Setting alarm for %d seconds", seconds);
    
    // Schedule local notification
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = alertBody;
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    NSLog(@"Local Notification %@", notification);
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

#pragma mark - Actions

- (IBAction)downTheHatchPressed:(id)sender
{
    [UIView animateWithDuration:0.7f animations:^{
        self.stepper.alpha = 1.0f;
        self.valueLabel.alpha = 1.0f;
        self.instructionLabel.alpha = 1.0f;
        self.setAlarm.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        [self scheduleNotification:1 alertBody:@"Time to Eat!"];
        NSLog(@"Alarm set");
        
    }];
}


- (IBAction)stepperChanged:(id)sender
{
    NSLog(@"Stepper Changed! %.1f", self.stepper.value);
    [self setValueFromStepper];
    
}


- (IBAction)setAlarmTapped:(id)sender
{
    [self scheduleNotification:self.stepper.value alertBody:@"It's Time for Your Next Dose"];
    NSLog(@"Alarm set");
    self.stepper.alpha = 0.0f;
    self.valueLabel.alpha = 0.0f;
    self.instructionLabel.alpha = 0.0f;
    self.setAlarm.alpha = 0.0f;
}

- (IBAction)logButtonTapped:(id)sender
{
    NSLog(@"Log Tapped");
    NSString *logNibName = NSStringFromClass([LogViewController class]);
    LogViewController *logViewController = [[LogViewController alloc] initWithNibName:logNibName bundle:nil];
    
    [self presentViewController:logViewController animated:YES completion:nil];
    
    //[self.navigationController pushViewController:logViewController animated:YES];
    
    
//    [UIView  transitionWithView:logViewController.view
//                       duration:0.4f
//                        options:UIViewAnimationOptionTransitionFlipFromLeft
//                     animations:^(void) {
//                         //[self.navigationController pushViewController:logViewController animated:YES];
//                     }
//                     completion:nil];
    
}


@end
