//
//  Alarm.m
//  Alarm
//
//  Created by Ameesh Kapoor on 12/29/16.
//  Copyright © 2016 Kapoor. All rights reserved.
//

#import "Alarm.h"

@interface Alarm ()

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *alarmTitle;
@property (nonatomic, strong) NSDate *dateTime;
@property (nonatomic, strong) NSTimeZone *timeZone;

@end

@implementation Alarm

- (instancetype)initWithTitle:(NSString *)title dateTime:(NSDate *)dateTime timeZone:(NSTimeZone *)timeZone {
    self = [super init];
    if (self) {
        self.id = [NSUUID UUID].UUIDString;
        self.alarmTitle = title;
        self.dateTime = dateTime;
        self.timeZone = timeZone;
    }
    return self;
}

- (instancetype)updateWithTitle:(NSString *)title dateTime:(NSDate *)dateTime timeZone:(NSTimeZone *)timeZone {
    self.alarmTitle = title;
    self.dateTime = dateTime;
    self.timeZone = timeZone;
    
    return self;
}

- (void)setId:(NSString *)id {
    if (_id == nil) {
        _id = id;
    }
}

- (NSDictionary *)toDictionary {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    return @{ @"id": self.id,
              @"alarmTitle": self.alarmTitle,
              @"dateTime": [df stringFromDate:self.dateTime],
              @"timeZone": self.timeZone.name
              };
}

+ (instancetype)fromDictionary:(NSDictionary *)dict {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    NSString *id = dict[@"id"];
    NSString *title = dict[@"alarmTitle"];
    NSDate *dateTime = [df dateFromString:dict[@"dateTime"]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:dict[@"timeZone"]];
    Alarm *a = [[Alarm alloc] initWithTitle:title
                                   dateTime:dateTime
                                   timeZone:timeZone];
    [a setId:id];
        
    return a;
}

@end
