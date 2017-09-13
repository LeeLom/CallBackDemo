//
//  Logger.m
//  CallBacksDemo
//
//  Created by LeeLom on 2017/9/13.
//  Copyright © 2017年 LeeLom. All rights reserved.
//

#import "Logger.h"

@implementation Logger

/**
 * 1. target - action
 **/
- (NSString *)lastTimeString {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    return [dateFormatter stringFromDate:_lastTime];
}

- (void)updateLastTime:(NSTimer *)timer {
    NSDate *now = [NSDate date];
    self.lastTime = now;
    NSLog(@"Update time to %@", self.lastTimeString);
}

/**
 * 2. connnection delegate
 **/
// 收到一定的字节数后被调用
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"received %lu bytes", [data length]);
    if (!_incomingData) {
        _incomingData = [[NSMutableData alloc]init];
    }
    [_incomingData appendData:data];
}

// 最后一部分数据完毕后调用
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"got it all");
    NSString *string = [[NSString alloc]initWithData:_incomingData encoding:NSUTF8StringEncoding];
    _incomingData = nil;
    NSLog(@"string has %lu characters", [string length]);
}

// 获取失败时候被调用
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"connection failed: %@", [error localizedDescription]);
    _incomingData = nil;
}

- (void)zoneChange:(NSNotification *)note {
    NSLog(@"The system time zone has changed!");
}
@end
