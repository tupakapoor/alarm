//
//  AKKAddEditAlarmViewController.m
//  Alarm
//
//  Created by Ameesh Kapoor on 12/29/16.
//  Copyright © 2016 Kapoor. All rights reserved.
//

#import "AKKAddEditAlarmViewController.h"

@interface AKKAddEditAlarmViewController ()

@property (nonatomic, weak) IBOutlet UITextField *alarmTitle;
@property (nonatomic, weak) IBOutlet UITextField *dateTime;
@property (nonatomic, weak) IBOutlet UITextField *timeZone;
@property (nonatomic, strong) NSDateFormatter *df;

@end

@implementation AKKAddEditAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.df = [[NSDateFormatter alloc] init];
    self.df.dateFormat = @"MMMM d h:mm";
    if (self.theAlarm) {
        self.alarmTitle.text = self.theAlarm.alarmTitle;
        self.dateTime.text = [self.df stringFromDate:self.theAlarm.dateTime];
        self.timeZone.text = self.theAlarm.timeZone.name;
    }
    
    // TODO: Set input accessories (date picker, uipicker) for date time and timezone
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addAlarm {
    NSString *alarmTitle = self.alarmTitle.text;
    NSDate *dateTime = [self.df dateFromString:self.dateTime.text];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:self.timeZone.text];
    
    if (!alarmTitle || !dateTime || !timeZone) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Please fill out all data"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    Alarm *alarm  = [[Alarm alloc] initWithTitle:alarmTitle
                                        dateTime:dateTime
                                        timeZone:timeZone];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *alarms = [[defaults objectForKey:@"alarms"] mutableCopy];
    [alarms addObject:[alarm toDictionary]];
    [defaults setObject:alarms forKey:@"alarms"];
    [defaults synchronize];
    
    // TODO: Schedule notification here
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
