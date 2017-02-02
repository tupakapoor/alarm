//
//  AKKAddEditAlarmViewController.m
//  Alarm
//
//  Created by Ameesh Kapoor on 12/29/16.
//  Copyright © 2016 Kapoor. All rights reserved.
//

@import UserNotifications;

#import "AKKAddEditAlarmViewController.h"
#import "AlarmListManager.h"
#import "AppDelegate.h"

@interface AKKAddEditAlarmViewController ()

@property (nonatomic, weak) IBOutlet UITextField *alarmTitle;
@property (nonatomic, weak) IBOutlet UITextField *dateTime;
@property (nonatomic, weak) IBOutlet UITextField *timeZone;
@property (nonatomic, strong) NSDateFormatter *df;
@property (nonatomic, strong) NSArray<NSString *> *timeZones;

@end

@implementation AKKAddEditAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.df = [[NSDateFormatter alloc] init];
    self.df.dateFormat = @"MMMM d, yyyy h:mm a";
    self.dateTime.placeholder = [self.df stringFromDate:[[NSDate date] dateByAddingTimeInterval:3600]];
    
    if (self.theAlarm) {
        self.alarmTitle.text = self.theAlarm.alarmTitle;
        self.dateTime.text = [self.df stringFromDate:self.theAlarm.dateTime];
        self.timeZone.text = self.theAlarm.timeZone.name;
        self.navigationItem.title = @"Edit Alarm";
    } else {
        self.timeZone.text = [NSTimeZone localTimeZone].name;
    }
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minimumDate = [NSDate date];
    datePicker.minuteInterval = 1;
    datePicker.timeZone = [NSTimeZone localTimeZone];
    [datePicker addTarget:self
                   action:@selector(datePickerValueChanged:)
         forControlEvents:UIControlEventValueChanged];
    self.dateTime.inputView = datePicker;
    
    UIPickerView *timezonePicker = [[UIPickerView alloc] init];
    timezonePicker.delegate = self;
    timezonePicker.dataSource = self;
    self.timeZone.inputView = timezonePicker;
    
    self.timeZones = [NSTimeZone knownTimeZoneNames];
    [timezonePicker selectRow:[self.timeZones indexOfObject:self.timeZone.text] inComponent:0 animated:YES];
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
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    
    [alarm scheduleWithHandler:^(NSError *error){
        if (error) {
            NSLog(@"error creating notification: %@", error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"Unable to create your alarm. Please try again."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            if (self.theAlarm) {
                [self.theAlarm unschedule];
                [AlarmListManager removeAlarm:self.theAlarm];
                self.theAlarm = nil;
            }
            
            [AlarmListManager addAlarm:alarm];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    
    
}


#pragma mark - Date Picker Delegate


- (void)datePickerValueChanged:(UIDatePicker *)sender {
    NSDate *date = sender.date;
    self.dateTime.text = [self.df stringFromDate:date];
}


#pragma mark - Picker View Data Source and Delegate


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.timeZones.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.timeZones[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.timeZone.text = self.timeZones[row];
    UIDatePicker *dp = (UIDatePicker *)self.dateTime.inputView;
    dp.timeZone = [NSTimeZone timeZoneWithName:self.timeZone.text];
}

@end
