//
//  Logger.h
//  CallBacksDemo
//
//  Created by LeeLom on 2017/9/13.
//  Copyright © 2017年 LeeLom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logger : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSMutableData *_incomingData;
}


@property(strong, nonatomic) NSDate *lastTime;

//1. target-action
- (NSString *)lastTimeString;
- (void)updateLastTime:(NSTimer *)timer;

//2. connection delegate and data delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

//3. notification
- (void)zoneChange:(NSNotification *)note;
@end
