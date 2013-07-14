//
//  LogViewController.m
//  PillMinder
//
//  Created by Gemma Barlow on 7/13/13.
//
//

#import "LogViewController.h"


@interface LogViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *logEntries;
@end

@implementation LogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"LogViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"kLogViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.logEntries = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"kLogViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *rawLogEntryString = self.logEntries[indexPath.row];
    NSString *formattedEntryString = [rawLogEntryString stringByReplacingOccurrencesOfString:@"\"Medication Taken\"" withString:@""];
    
    NSArray *formattedEntryComponents = [[formattedEntryString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@" "];
    
    cell.textLabel.text = formattedEntryComponents[1];
    cell.detailTextLabel.text = formattedEntryComponents[0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0f;
}

#pragma mark - Actions

- (IBAction)closeTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)exportTapped:(id)sender
{
    [self sendCSVFileToMail];
}

- (void) sendCSVFileToMail
{
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    [mailer setSubject:@"Exported log from Dose Me"];
    [mailer addAttachmentData:[NSData dataWithContentsOfFile:self.medicationLogPath]
                     mimeType:@"text/csv"
                     fileName:@"doseme-medication-log.csv"];
    [self presentViewController:mailer animated:YES completion:^() {
        
    }];

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if(result == MFMailComposeResultFailed) {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"Error"
                                   message:@"An error occurred trying to export your log, please retrieve it from the device using iExplorer instead."
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        
        [errorView show];
    }
    else {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Properties

- (NSArray*)logEntries
{
    if(_logEntries == nil) {
        
        NSError *readLogError = nil;
        
        NSString *dataStr = [NSString stringWithContentsOfFile:self.medicationLogPath encoding:NSUTF8StringEncoding error:&readLogError];
        
        if(readLogError) {
            NSLog(@"There was an error reading the medication log :%@", [readLogError description]);
            return nil;
        }
        
        NSMutableArray *logEntries = [NSMutableArray arrayWithArray:[dataStr componentsSeparatedByString: @"\n"]];
        [logEntries removeLastObject];
        _logEntries = logEntries;
    }
    return _logEntries;
}



@end
