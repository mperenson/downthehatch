//
//  AlarmsManagerTableViewController.m
//  PillMinder
//
//  Created by Svetlana Brodskaya on 7/16/15.
//
//

#import "AlarmsManagerTableViewController.h"

@interface AlarmsManagerTableViewController ()

@property (nonatomic, strong) NSMutableArray * alarms;


@end

@implementation AlarmsManagerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIApplication *app = [UIApplication sharedApplication];
    self.alarms = [NSMutableArray arrayWithArray:[app scheduledLocalNotifications]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        [self.alarms removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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

-(void) cancelNotificationById:(NSString*)uidtodelete
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
        if ([uid isEqualToString:uidtodelete])
        {
            //Cancelling local notification
            [app cancelLocalNotification:oneEvent];
            break;
        }
    }
}

-(void) cancelNotification:(UILocalNotification*)notification
{
    UIApplication *app = [UIApplication sharedApplication];

    [app cancelLocalNotification:notification];

}


@end
