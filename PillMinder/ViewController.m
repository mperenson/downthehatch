//
//  ViewController.m
//  PillMinder
//
//  Created by Melissa Perenson on 12/31/00.
//  Copyright (c) 2000 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.stepper.alpha = 0.0f;
    self.valueLabel.alpha = 0.0f;
    self.instructionLabel.alpha = 0.0f;
    
    
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
    } completion:^(BOOL finished) {
        
    }];
    
    self.slider.hidden = NO;
}


- (IBAction)stepperChanged:(id)sender
{
    NSLog(@"Stepper Changed! %.1f", self.stepper.value);
    [self setValueFromStepper];
    
}

- (void) setValueFromStepper
{
    self.valueLabel.text = [NSString stringWithFormat:@"%.1f hours from now", self.stepper.value];
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
