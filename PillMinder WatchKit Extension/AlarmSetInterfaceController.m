//
//  AlarmSetInterfaceController.m
//  PillMinder
//
//  Created by Svetlana Brodskaya on 7/12/15.
//
//

#import "AlarmSetInterfaceController.h"


@implementation AlarmSetInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self setTitle:@"Alarm Set!!!"];
    
    [self.alarmSetLabel setText:[NSString stringWithFormat:@"Med in %@ hour(s)", context]];
    
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

@end



