//
//  Alarm.h
//  Alarm
//
//  Created by Ameesh Kapoor on 12/29/16.
//  Copyright © 2016 Kapoor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject

@property (nonatomic, readonly) NSString *id;
@property (nonatomic, readonly) NSString *alarmTitle;
@property (nonatomic, readonly) NSDate *dateTime;
@property (nonatomic, readonly) NSTimeZone *timeZone;

- (instancetype)initWithTitle:(NSString *)title dateTime:(NSDate *)dateTime timeZone:(NSTimeZone *)timeZone;
- (instancetype)updateWithTitle:(NSString *)title dateTime:(NSDate *)dateTime timeZone:(NSTimeZone *)timeZone;
- (NSDictionary *)toDictionary;
+ (instancetype)fromDictionary:(NSDictionary *)dict;

@end
