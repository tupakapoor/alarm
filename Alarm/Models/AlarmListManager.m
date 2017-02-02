//
//  AlarmListManager.m
//  Alarm
//
//  Created by Ameesh Kapoor on 12/30/16.
//  Copyright © 2016 Kapoor. All rights reserved.
//

#import "AlarmListManager.h"

@interface AlarmListManager ()

@property (nonatomic, strong) NSMutableArray *alarms;

@end

@implementation AlarmListManager

static AlarmListManager *manager;

+ (instancetype)manager {
    if (!manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[AlarmListManager alloc] init];
            manager.alarms = [NSMutableArray new];
        });
    }
    
    return manager;
}

+ (NSArray<Alarm*> *)load {
    NSArray *alarmDictionaries = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarms"];
    [[AlarmListManager manager].alarms removeAllObjects];
    for (NSDictionary *alarmDict in alarmDictionaries) {
        Alarm *a = [Alarm fromDictionary:alarmDict];
        if ([a.dateTime compare:[NSDate date]] == NSOrderedDescending) {
            [[AlarmListManager manager].alarms addObject:a];
        }
    }
    
    return [AlarmListManager manager].alarms;
}

+ (void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *serializedAlarms = [NSMutableArray new];
    for (Alarm *a in [AlarmListManager manager].alarms) {
        [serializedAlarms addObject:[a toDictionary]];
    }
    
    [defaults setObject:serializedAlarms forKey:@"alarms"];
    [defaults synchronize];
}

+ (void)addAlarm:(Alarm *)alarm {
    [[AlarmListManager manager].alarms addObject:alarm];
    [AlarmListManager save];
}

+ (void)removeAlarm:(Alarm *)alarm {
    for (Alarm *a in [AlarmListManager manager].alarms) {
        if ([alarm.id isEqualToString:a.id]) {
            [[AlarmListManager manager].alarms removeObject:a];
            break;
        }
    }
    
    [AlarmListManager save];
}

@end
