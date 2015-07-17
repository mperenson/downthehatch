//
//  IntervalViewController.m
//  PillMinder
//
//  Created by Melissa Perenson on 7/11/15.
//
//

#import "IntervalViewController.h"

@interface IntervalViewController ()
- (IBAction)changeBeforeMealStepperValue:(id)sender;

@end

@implementation IntervalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeBeforeMealStepperValue:(id)sender {
    
    if ([sender isKindOfClass:[UIStepper class]]) {
        UIStepper * stepper = (UIStepper*)sender;
        
        NSLog(@"stepper.value:%f", stepper.value);
        
        if (stepper.value<60) {
            self.medicationLabel.text = [NSString stringWithFormat:@"%d min before meal", (int)stepper.value ];
        }else{
            
            int hours = stepper.value / 60;
            
            if ((int)stepper.value - hours * 60==0) {
                self.medicationLabel.text = [NSString stringWithFormat:@"%d hr before meal", hours];
            } else {
                self.medicationLabel.text = [NSString stringWithFormat:@"%d hr %d min before meal", hours,(int)stepper.value - hours * 60];
            }
            
            
        }
    }
}
- (IBAction)changeAfterMealStepperValue:(id)sender {
    
    if ([sender isKindOfClass:[UIStepper class]]) {
        UIStepper * stepper = (UIStepper*)sender;
        
        NSLog(@"stepper.value:%f", stepper.value);
        
        if (stepper.value<60) {
            self.mealLabel.text = [NSString stringWithFormat:@"%d min after meal", (int)stepper.value ];
        }else{
            
            int hours = stepper.value / 60;
            
            if ((int)stepper.value - hours * 60==0) {
                self.mealLabel.text = [NSString stringWithFormat:@"%d hr after meal", hours];
            } else {
                self.mealLabel.text = [NSString stringWithFormat:@"%d hr %d min after meal", hours,(int)stepper.value - hours * 60];
            }
            
            
        }
    }
}
@end
