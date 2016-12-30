//
//  AKKAlarmTableViewController.m
//  Alarm
//
//  Created by Ameesh Kapoor on 12/29/16.
//  Copyright © 2016 Kapoor. All rights reserved.
//

#import "AKKAlarmTableViewController.h"
#import "AKKAddEditAlarmViewController.h"
#import "Alarm.h"

#define CELL_REUSE_IDENTIFIER @"alarmCell"

@interface AKKAlarmTableViewController ()

@property (nonatomic, strong) NSMutableArray *alarms;

@end

@implementation AKKAlarmTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *alarmDictionaries = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarms"];
    self.alarms = [NSMutableArray new];
    for (NSDictionary *alarmDict in alarmDictionaries) {
        Alarm *a = [Alarm fromDictionary:alarmDict];
        [self.alarms addObject:a];
    }
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
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MMMM d h:mm";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    cell.textLabel.text = theAlarm.alarmTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", [df stringFromDate:theAlarm.dateTime], theAlarm.timeZone.name];
    
    return cell;
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
