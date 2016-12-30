//
//  AlarmListManager.h
//  Alarm
//
//  Created by Ameesh Kapoor on 12/30/16.
//  Copyright © 2016 Kapoor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"


@interface AlarmListManager : NSObject

+ (instancetype)manager;
+ (NSMutableArray<Alarm*> *)load;
+ (void)save;
+ (void)addAlarm:(Alarm *)alarm;
+ (void)removeAlarm:(Alarm *)alarm;

@end
