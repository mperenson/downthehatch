//
//  IntervalViewController.m
//  PillMinder
//
//  Created by Melissa Perenson on 7/11/15.
//
//

#import "IntervalViewController.h"

@interface IntervalViewController ()
@property (weak, nonatomic) IBOutlet UIStepper *beforeMealStepper;
@property (weak, nonatomic) IBOutlet UIStepper *afterMealStepper;
- (IBAction)changeBeforeMealStepperValue:(id)sender;

- (IBAction)changeAfterMealStepperValue:(id)sender;
@end

@implementation IntervalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSInteger timeIntervalBeforeMeal = [[NSUserDefaults standardUserDefaults] integerForKey: @"pillminder.timeIntervalBeforeMeal"];
    
    [self setMedicationLabelText:timeIntervalBeforeMeal];
    self.beforeMealStepper.value = timeIntervalBeforeMeal;
    
    
    NSInteger timeIntervalAfterMeal = [[NSUserDefaults standardUserDefaults] integerForKey: @"pillminder.timeIntervalAfterMeal"];
    [self setMealLabelText:timeIntervalAfterMeal];
    self.afterMealStepper.value = timeIntervalAfterMeal;
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
        
        [self setMedicationLabelText:stepper.value];
        
        [[NSUserDefaults standardUserDefaults] setInteger: stepper.value forKey: @"pillminder.timeIntervalBeforeMeal"];
    }
}
- (IBAction)changeAfterMealStepperValue:(id)sender {
    
    if ([sender isKindOfClass:[UIStepper class]]) {
        UIStepper * stepper = (UIStepper*)sender;
        
        [self setMealLabelText:stepper.value];

        [[NSUserDefaults standardUserDefaults] setInteger: stepper.value forKey: @"pillminder.timeIntervalAfterMeal"];
    }
}

-(void) setMedicationLabelText:(NSInteger)stepperValue
{
    if (stepperValue<60) {
        self.medicationLabel.text = [NSString stringWithFormat:@"%d min before meal", (int)stepperValue ];
    }else{
        
        long hours = stepperValue / 60;
        
        if (stepperValue - hours * 60==0) {
            self.medicationLabel.text = [NSString stringWithFormat:@"%ld hr before meal", hours];
        } else {
            self.medicationLabel.text = [NSString stringWithFormat:@"%ld hr %ld min before meal", hours,stepperValue - hours * 60];
        }
        
        
    }
}
-(void) setMealLabelText:(NSInteger)stepperValue
{
    if (stepperValue<60) {
        self.mealLabel.text = [NSString stringWithFormat:@"%ld min after meal", stepperValue ];
    }else{
        
        long hours = stepperValue / 60;
        
        if (stepperValue - hours * 60==0) {
            self.mealLabel.text = [NSString stringWithFormat:@"%ld hr after meal", hours];
        } else {
            self.mealLabel.text = [NSString stringWithFormat:@"%ld hr %ld min after meal", hours,stepperValue - hours * 60];
        }
        
        
    }
}
@end
