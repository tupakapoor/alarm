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
    manager.alarms = [NSMutableArray new];
    for (NSDictionary *alarmDict in alarmDictionaries) {
        Alarm *a = [Alarm fromDictionary:alarmDict];
        [manager.alarms addObject:a];
    }
    
    return manager.alarms;
}

+ (void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *serializedAlarms = [NSMutableArray new];
    for (Alarm *a in manager.alarms) {
        [serializedAlarms addObject:[a toDictionary]];
    }
    
    [defaults setObject:serializedAlarms forKey:@"alarms"];
    [defaults synchronize];
}

+ (void)addAlarm:(Alarm *)alarm {
    [manager.alarms addObject:alarm];
    [AlarmListManager save];
}

+ (void)removeAlarm:(Alarm *)alarm {
    [manager.alarms removeObject:alarm];
    [AlarmListManager save];
}

@end
