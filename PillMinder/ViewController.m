//
//  ViewController.m
//  PillMinder
//
//  Created by Melissa Perenson on 12/31/00.
//  Copyright (c) 2000 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
