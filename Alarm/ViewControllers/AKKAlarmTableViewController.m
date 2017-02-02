//
//  AKKAlarmTableViewController.m
//  Alarm
//
//  Created by Ameesh Kapoor on 12/29/16.
//  Copyright © 2016 Kapoor. All rights reserved.
//

@import UserNotifications;

#import "AKKAlarmTableViewController.h"
#import "AKKAddEditAlarmViewController.h"
#import "Alarm.h"
#import "AlarmListManager.h"

#define CELL_REUSE_IDENTIFIER @"alarmCell"

@interface AKKAlarmTableViewController ()

@property (nonatomic, strong) NSDateFormatter *df;
@property (nonatomic, strong) NSMutableArray<Alarm*> *alarms;

@end

@implementation AKKAlarmTableViewController

- (void)viewDidLoad {
    self.df = [[NSDateFormatter alloc] init];
    self.df.dateFormat = @"MMMM d, yyyy h:mm a";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!granted || error) {
                                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                 message:@"In order to display alarms, we need permission to show you notifications. Please update this in Settings."
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                                  UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Go to Settings"
                                                                                         style:UIAlertActionStyleDefault
                                                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                                                                                                              options:@{}
                                                                                                                    completionHandler:nil];
                                                                                       }];
                                  UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                                               style:UIAlertActionStyleCancel
                                                                             handler:nil];
                                  [alert addAction:settings];
                                  [alert addAction:ok];
                                  [self presentViewController:alert animated:YES completion:nil];
                              }
                          }];
    
    self.alarms = [AlarmListManager load];
    [self.alarms sortUsingComparator:^NSComparisonResult(Alarm* _Nonnull obj1, Alarm* _Nonnull obj2) {
        NSCalendar *cal1 = [NSCalendar currentCalendar];
        cal1.timeZone = obj1.timeZone;
        
        
        return [obj1.dateTime compare:obj2.dateTime];
    }];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addAlarm {
    [self performSegueWithIdentifier:@"AddEdit" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alarms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Alarm *theAlarm = self.alarms[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    cell.textLabel.text = theAlarm.alarmTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", [self.df stringFromDate:theAlarm.dateTime], theAlarm.timeZone.name];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                    title:@"Edit"
                                                                  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                        Alarm *alarm = self.alarms[indexPath.row];
                                                                        [self performSegueWithIdentifier:@"AddEdit" sender:alarm];
                                                                    }];
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                      title:@"Delete"
                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                        Alarm *a = self.alarms[indexPath.row];
                                                                        [a unschedule];
                                                                        [AlarmListManager removeAlarm:a];
                                                                        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                                        self.alarms = [AlarmListManager load];
                                                                      }];
    return @[edit, delete];
}


#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddEdit"]) {
        if (sender != nil && [sender isKindOfClass:[Alarm class]]) {
            AKKAddEditAlarmViewController *aevc = (AKKAddEditAlarmViewController *)segue.destinationViewController;
            aevc.theAlarm = sender;
        }
    }
}


@end
