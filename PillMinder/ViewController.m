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

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

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

@property (nonatomic, strong) NSArray * alarms;
@property (weak, nonatomic) IBOutlet UITableView *activeAlarmsTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activeAlarmsTableHeight;

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
    
    UIApplication *app = [UIApplication sharedApplication];
    self.alarms = [app scheduledLocalNotifications];
}

-(void) viewDidAppear:(BOOL)animated
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.timeIntervalBeforeMeal = [userDefaults integerForKey: @"pillminder.timeIntervalBeforeMeal"];
    
    self.timeIntervalAfterMeal = [userDefaults integerForKey: @"pillminder.timeIntervalAfterMeal"];
    
    [self reloadEatAndTakeMedsSections];
    [self.activeAlarmsTableView reloadData];
    [self changeTableHeight];
    
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

-(void) reloadEatAndTakeMedsSections
{
    UIApplication *app = [UIApplication sharedApplication];
    NSMutableArray *alarms = [NSMutableArray arrayWithArray:[app scheduledLocalNotifications]];
    
    BOOL timeToEat = NO;
    BOOL timeToAfterMealMed = NO;
    
    UILocalNotification *notificationToEat;
    UILocalNotification *notificationToMed;
    
    for (UILocalNotification *notification in alarms) {
        if ([notification.alertBody isEqualToString:kScheduleNextAfterMealDoseMessage]) {
            timeToAfterMealMed = YES;
            
            notificationToMed = notification;
        }
        
        if ([notification.alertBody isEqualToString:kBeforeMealMedTakenTimeToEatMessage]) {
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
    
    if (!timeToAfterMealMed) {
        self.eatMealLabel.text = [NSString stringWithFormat: @"Eat meal. Meds alarm in %ld min", (long)self.timeIntervalAfterMeal];
        self.eatButton.enabled = YES;
    } else {
        NSString *dateString =  [NSDateFormatter localizedStringFromDate:notificationToMed.fireDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        
        self.eatMealLabel.text =  [NSString stringWithFormat: @"After meal meds at %@", dateString];
        self.eatButton.enabled = NO;
    }

}


#pragma mark - Actions

- (IBAction)takeMedsPressed:(id)sender
{
    self.lastTapped = sender;
 
        self.stepper.alpha = 1.0f;
        self.valueLabel.alpha = 1.0f;
        self.instructionLabel.alpha = 1.0f;
        self.setAlarm.alpha = 1.0f;
    
        AppDelegate* appDelegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]) ;
    
        [appDelegate scheduleNotification:self.timeIntervalBeforeMeal alertBody:kBeforeMealMedTakenTimeToEatMessage];
            self.medsButton.enabled = NO;
            
        NSString *dateString =  [NSDateFormatter localizedStringFromDate:[[NSDate date] dateByAddingTimeInterval:self.timeIntervalBeforeMeal*60] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
            
        self.takeMedicationLabel.text = [NSString stringWithFormat: @"Meal at %@", dateString];
            
        self.instructionLabel.text = @"SCHEDULE NEXT DOSE";

        NSLog(@"Alarm set");
    
    
    [self writeEntryToCSVFile];
    
    UIApplication *app = [UIApplication sharedApplication];
    self.alarms = [app scheduledLocalNotifications];
    
    [self.activeAlarmsTableView reloadData];
    [self changeTableHeight];
    
}

-(void) changeTableHeight
{
    self.activeAlarmsTableView.rowHeight = UITableViewAutomaticDimension;
    self.activeAlarmsTableView.estimatedRowHeight = 44.0;
    
    self.activeAlarmsTableHeight.constant = self.activeAlarmsTableView.estimatedRowHeight * self.alarms.count;//self.activeAlarmsTableView.rowHeight * self.alarms.count;
}
-(IBAction)takeMealPressed:(id)sender
{
    self.lastTapped = sender;
    
    self.stepper.alpha = 1.0f;
    self.valueLabel.alpha = 1.0f;
    self.instructionLabel.alpha = 1.0f;
    self.setAlarm.alpha = 1.0f;
    
    //check if notification for kBeforeMealMedTakenTimeToEatMessage is not fired yet
    
    UILocalNotification* notification = [self notificationWithAlertBody:kBeforeMealMedTakenTimeToEatMessage];
    
    if (notification) {
        NSLog(@"Notification --%@-- will be canceled", notification.alertBody);
        
        [[UIApplication sharedApplication] cancelLocalNotification: notification ];
    }
    
    AppDelegate* appDelegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]) ;

    [appDelegate scheduleNotification:self.timeIntervalAfterMeal alertBody:kScheduleNextAfterMealDoseMessage];
    self.eatButton.enabled = NO;
        
    NSString *dateString =  [NSDateFormatter localizedStringFromDate:[[NSDate date] dateByAddingTimeInterval:self.timeIntervalAfterMeal*60] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
        
    self.eatMealLabel.text = [NSString stringWithFormat: @"After meal meds at %@", dateString];
        
    self.instructionLabel.text = @"SCHEDULE NEXT MEAL";
    
    NSLog(@"Alarm set");
    
    [self writeEntryToCSVFile];
    
    UIApplication *app = [UIApplication sharedApplication];
    self.alarms = [app scheduledLocalNotifications];
    
    [self.activeAlarmsTableView reloadData];
    
    [self changeTableHeight];
}

-(UILocalNotification*) notificationWithAlertBody:(NSString*) alertBody
{
    UIApplication *app = [UIApplication sharedApplication];
    NSMutableArray *alarms = [NSMutableArray arrayWithArray:[app scheduledLocalNotifications]];
    
    for (UILocalNotification *notification in alarms) {
        if ([notification.alertBody isEqualToString:alertBody]) {
            return notification;
        }
    }
    
    return nil;
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
        [appDelegate scheduleNotification:correctedTimeInterval alertBody:kScheduleNextBeforeMealDoseMessage];
    }else{
        [appDelegate scheduleNotification:correctedTimeInterval alertBody:kTimeToEatMessage];
    }
    
    self.stepper.alpha = 0.0f;
    self.valueLabel.alpha = 0.0f;
    self.instructionLabel.alpha = 0.0f;
    self.setAlarm.alpha = 0.0f;
    
    
    UIApplication *app = [UIApplication sharedApplication];
    
    self.alarms = [app scheduledLocalNotifications];
    
    [self.activeAlarmsTableView reloadData];
    [self changeTableHeight];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.alarms.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currentAlarmCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    UILocalNotification * notification = (UILocalNotification*)[self.alarms objectAtIndex:indexPath.row];
    
    cell.textLabel.text = notification.alertBody;
    
    NSString *dateString =  [NSDateFormatter localizedStringFromDate:notification.fireDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    
    
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", dateString];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        UILocalNotification * notification = (UILocalNotification*)[self.alarms objectAtIndex:indexPath.row];
        
        
        [self cancelNotification:notification];
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    [self changeTableHeight];
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void) cancelNotification:(UILocalNotification*)notification
{
    UIApplication *app = [UIApplication sharedApplication];
    
    [app cancelLocalNotification:notification];
    
    self.alarms = [app scheduledLocalNotifications];
    
    [self reloadEatAndTakeMedsSections];
}

@end
