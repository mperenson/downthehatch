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
    
  //  NSString *counterValue = [userInfo objectForKey:@"counterValue"];
    
    [self.alarmSetLabel setText:@"Med in 1 hour"];
    
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



