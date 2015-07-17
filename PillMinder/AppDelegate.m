//
//  AppDelegate.m
//  PillMinder
//
//  Created by Melissa Perenson on 12/31/00.
//  Copyright (c) 2000 Flight of Fancy. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "Constants.h"

@interface AppDelegate ()
@property (strong, nonatomic) NSMutableArray *tempCounterData;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController; 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    
#ifdef __IPHONE_8_0
    //Right, that is the point
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
    //register to receive notifications
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    //self.window.rootViewController = self.viewController;
    //[self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    UIAlertView *alertView = nil;
    
    if ([notification.alertBody isEqualToString:kScheduleNextDoseMessage]) {
        alertView = [[UIAlertView alloc] initWithTitle:kScheduleNextDoseMessage
                                               message:@""
                                              delegate:self
                                     cancelButtonTitle:kCloseButtonTitle
                                     otherButtonTitles:nil];
    }
    else {
        alertView = [[UIAlertView alloc] initWithTitle:kTimeToEatMessage
                                               message:@""
                                              delegate:self
                                     cancelButtonTitle:kCloseButtonTitle
                                     otherButtonTitles:nil];

    }

    [alertView show];
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply {
    
    reply(@{@"insert counter value":@(1)});
    
    NSString *counterValue = [userInfo objectForKey:@"counterValue"];
    if (!self.tempCounterData) {
        self.tempCounterData = [[NSMutableArray alloc] init];
    }
    
    [self.tempCounterData addObject:counterValue];
    
    [self scheduleNotification:[counterValue intValue] alertBody:kScheduleNextDoseMessage];
    
    
    
    
}

- (void) scheduleNotification:(CGFloat)hoursValue alertBody:(NSString*)alertBody
{
    // Convert hours to seconds
    NSInteger seconds = hoursValue * 6;
    
    //NSInteger seconds = hoursValue * 3600;
    NSLog(@"Setting alarm for %ld seconds", (long)seconds);
    
    // Schedule local notification
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = alertBody;
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    NSLog(@"Local Notification %@", notification);
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}
@end
