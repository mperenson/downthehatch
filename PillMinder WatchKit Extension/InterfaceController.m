//
//  InterfaceController.m
//  PillMinder WatchKit Extension
//
//  Created by Svetlana Brodskaya on 7/11/15.
//
//


#import "InterfaceController.h"

#import "AlarmSetInterfaceController.h"


@interface InterfaceController()

@property (nonatomic, assign) int counter;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *counterLabel;

@end


@implementation InterfaceController

- (IBAction)incrementCounter {
    self.counter++;
    [self setCounterLabelText];
}
- (IBAction)decrementCounter {
    self.counter--;
    [self setCounterLabelText];
}

- (void)setCounterLabelText {
    [self.counterLabel setText:[NSString stringWithFormat:@"next in:%d hour(s)", self.counter]];
}

- (IBAction)scheduleAlarm {
    //Send count to parent application
    NSString *counterString = [NSString stringWithFormat:@"%d", self.counter];
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[counterString] forKeys:@[@"counterValue"]];
    
    //Handle reciever in app delegate of parent app
    [WKInterfaceController openParentApplication:applicationData reply:^(NSDictionary *replyInfo, NSError *error) {
        NSLog(@"%@ %@",replyInfo, error);
    }];
    
  //  [self performSegueWithIdentifier:@"alarmSetSegue" sender:nil];
}


- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.counter = 1;
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
/*
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"alarmSetSegue"])
    {
        AlarmSetInterfaceController *controller = (AlarmSetInterfaceController*)[segue destinationViewController];
        
       // controller.delegate = self;
        
        [controller.alarmSetLabel setText:@"hsdshdfkjhs"];
        
//        if ([sender isKindOfClass:[NSString class]]) {
//            
//            NSString *subword = (NSString*)sender;
//            
//            controller.currentString = subword;
//        }
        
      //  controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
}
*/
@end




