//
//  AKKAddEditAlarmViewController.h
//  Alarm
//
//  Created by Ameesh Kapoor on 12/29/16.
//  Copyright © 2016 Kapoor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"

@interface AKKAddEditAlarmViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) Alarm *theAlarm;

@end
