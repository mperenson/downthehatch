//
//  ViewController.m
//  PillMinder
//
//  Created by Melissa Perenson on 12/31/00.
//  Copyright (c) 2000 Flight of Fancy LLC. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"

#import "LogViewController.h"
#import "Constants.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIButton *setAlarm;

@property (weak, nonatomic) IBOutlet UIButton *medsButton;
@property (weak, nonatomic) IBOutlet UIButton *eatButton;

@property (weak, nonatomic) IBOutlet UIButton *lastTapped;
@property (strong, nonatomic) NSString *medicationLogPath;
@property (weak, nonatomic) IBOutlet UILabel *takeMedicationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eatMealLabel;

@property(nonatomic) NSInteger timeIntervalBeforeMeal;
@property(nonatomic) NSInteger timeIntervalAfterMeal;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.medicationLogPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"medication-log.csv"];

    self.stepper.alpha = 0.0f;
    self.valueLabel.alpha = 0.0f;
    self.instructionLabel.alpha = 0.0f;
    self.setAlarm.alpha = 0.0f;
    
    
    [self setValueFromStepper];
}

-(void) viewDidAppear:(BOOL)animated
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.timeIntervalBeforeMeal = [userDefaults integerForKey: @"pillminder.timeIntervalBeforeMeal"];
    
    self.timeIntervalAfterMeal = [userDefaults integerForKey: @"pillminder.timeIntervalAfterMeal"];
    
    UIApplication *app = [UIApplication sharedApplication];
    NSMutableArray *alarms = [NSMutableArray arrayWithArray:[app scheduledLocalNotifications]];

    BOOL timeToEat = NO;
    BOOL timeToMed = NO;
    
    UILocalNotification *notificationToEat;
    UILocalNotification *notificationToMed;
    
    for (UILocalNotification *notification in alarms) {
        if ([notification.alertBody isEqualToString:kScheduleNextDoseMessage]) {
            timeToMed = YES;
            
            notificationToMed = notification;
        }
        
        if ([notification.alertBody isEqualToString:kTimeToEatMessage]) {
            timeToEat = YES;
            
            notificationToEat = notification;
        }
    }
    
    if (!timeToEat) {
        self.takeMedicationLabel.text = [NSString stringWithFormat: @"Take meds. Meal alarm in %ld min", (long)self.timeIntervalBeforeMeal];;
        
        self.medsButton.enabled = YES;
    }else{
         NSString *dateString =  [NSDateFormatter localizedStringFromDate:notificationToEat.fireDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        
        self.takeMedicationLabel.text =  [NSString stringWithFormat: @"Meal at %@", dateString];
        self.medsButton.enabled = NO;
    }
    
    if (!timeToMed) {
        self.eatMealLabel.text = [NSString stringWithFormat: @"Eat meal. Meds alarm in %ld min", (long)self.timeIntervalAfterMeal];
        self.eatButton.enabled = YES;
    } else {
        NSString *dateString =  [NSDateFormatter localizedStringFromDate:notificationToMed.fireDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        
        self.eatMealLabel.text =  [NSString stringWithFormat: @"After meal meds at %@", dateString];
        self.eatButton.enabled = NO;
    }
    
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

#pragma mark - Actions

- (IBAction)iconPressed:(id)sender
{
    self.lastTapped = sender;
   // [UIView animateWithDuration:0.7f animations:^{
        self.stepper.alpha = 1.0f;
        self.valueLabel.alpha = 1.0f;
        self.instructionLabel.alpha = 1.0f;
        self.setAlarm.alpha = 1.0f;
        
  //  } completion:^(BOOL finished) {
        AppDelegate* appDelegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]) ;
        if (sender == self.medsButton) {
            [appDelegate scheduleNotification:self.timeIntervalBeforeMeal alertBody:kTimeToEatMessage];
            self.medsButton.enabled = NO;
            
            NSString *dateString =  [NSDateFormatter localizedStringFromDate:[[NSDate date] dateByAddingTimeInterval:self.timeIntervalBeforeMeal*60] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
            
            self.takeMedicationLabel.text = [NSString stringWithFormat: @"Meal at %@", dateString];
            
            self.instructionLabel.text = @"SCHEDULE NEXT DOSE";
        }
        else {
            [appDelegate scheduleNotification:self.timeIntervalAfterMeal alertBody:kScheduleNextDoseMessage];
            self.eatButton.enabled = NO;
            
            NSString *dateString =  [NSDateFormatter localizedStringFromDate:[[NSDate date] dateByAddingTimeInterval:self.timeIntervalAfterMeal*60] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
            
            self.eatMealLabel.text = [NSString stringWithFormat: @"After meal meds at %@", dateString];
            
            self.instructionLabel.text = @"SCHEDULE NEXT MEAL";
        }
        NSLog(@"Alarm set");
        
  //  }];
    
    [self writeEntryToCSVFile];
}


- (IBAction)stepperChanged:(id)sender
{
    NSLog(@"Stepper Changed! %.1f", self.stepper.value);
    [self setValueFromStepper];
    
}


- (IBAction)setAlarmTapped:(id)sender
{
    CGFloat correctedTimeInterval = self.stepper.value*60;
    
    AppDelegate* appDelegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]) ;
    if (self.lastTapped == self.medsButton) {
        //correctedTimeInterval -= self.timeIntervalBeforeMeal;
        [appDelegate scheduleNotification:correctedTimeInterval alertBody:kScheduleNextDoseMessage];
    }else{
        [appDelegate scheduleNotification:correctedTimeInterval alertBody:kTimeToEatMessage];
    }
    
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
    logViewController.medicationLogPath = [self.medicationLogPath copy];
    
    [self presentViewController:logViewController animated:YES completion:nil];
}



#pragma mark - CSV Processing

- (void) writeEntryToCSVFile
{
    
    [self createCSVFileIfItDoesntAlreadyExist:self.medicationLogPath];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *entryString = [@"\"Medication Taken\" " stringByAppendingString:dateString];
    
    NSArray *entryArray = @[entryString, @"\n"];
    NSString *entry = [entryArray componentsJoinedByString:@""];
    
    NSFileHandle *writer = [NSFileHandle fileHandleForWritingAtPath:self.medicationLogPath];
    [writer seekToEndOfFile];
    [writer writeData:[entry dataUsingEncoding:NSUTF8StringEncoding]];

}

- (void) createCSVFileIfItDoesntAlreadyExist:(NSString*)filePath
{
    if(![[NSFileManager defaultManager]  fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
}

- (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
-(IBAction)gotoMainViewController:(UIStoryboardSegue *)sender
{
    
}
-(IBAction)gotoMainViewControllerToo
:(UIStoryboardSegue *)sender
{
    
}
@end
