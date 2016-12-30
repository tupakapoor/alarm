//
//  Alarm.m
//  Alarm
//
//  Created by Ameesh Kapoor on 12/29/16.
//  Copyright © 2016 Kapoor. All rights reserved.
//

#import "Alarm.h"

@interface Alarm ()

@property (nonatomic, strong) NSUUID *id;
@property (nonatomic, strong) NSString *alarmTitle;
@property (nonatomic, strong) NSDate *dateTime;
@property (nonatomic, strong) NSTimeZone *timeZone;

@end

@implementation Alarm

- (instancetype)initWithTitle:(NSString *)title dateTime:(NSDate *)dateTime timeZone:(NSTimeZone *)timeZone {
    self = [super init];
    if (self) {
        self.id = [NSUUID UUID];
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

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.alarmTitle forKey:@"alarmTitle"];
    [aCoder encodeObject:self.dateTime forKey:@"dateTime"];
    [aCoder encodeObject:self.timeZone forKey:@"timeZone"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _id = [aDecoder decodeObjectForKey:@"id"];
        _alarmTitle = [aDecoder decodeObjectForKey:@"alarmTitle"];
        _dateTime = [aDecoder decodeObjectForKey:@"dateTime"];
        _timeZone = [aDecoder decodeObjectForKey:@"timeZone"];
    }
    
    return self;
}

@end
