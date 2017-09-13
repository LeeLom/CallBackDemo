//
//  AppDelegate.m
//  CallBacksDemo
//
//  Created by LeeLom on 2017/9/13.
//  Copyright © 2017年 LeeLom. All rights reserved.
//

#import "AppDelegate.h"
#import "Logger.h"
#import <UIKit/UIKit.h>
#import "NotificationA.h"
#import "NotificationB.h"
#import "AViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1. 目标-动作对
    // 创建一个Logger的实例logger
    Logger *logger = [[Logger alloc]init];
    // 每隔2秒，NSTimer对象会向其Target对象logger，发送指定的消息updateLastTime:
    
//    __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0
//                                                      target:logger
//                                                    selector:@selector(updateLastTime:)
//                                                    userInfo:nil
//                                                     repeats:YES];
    // 创建一个按钮
    UIButton *btn = [[UIButton alloc]init];
    // 为按钮添加事件
    [btn addTarget:self
            action:@selector(btnClick)
  forControlEvents:UIControlEventTouchUpInside];
    
    
    //2. 辅助对象
//    NSURL *url = [NSURL URLWithString:@"https://www.gutenberg.org/cache/epub/205/pg205.txt"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    __unused NSURLConnection *fetchConn = [[NSURLConnection alloc]initWithRequest:request
//                                                                         delegate:logger
//                                                                 startImmediately:YES];
    
    //3. 通知中心
    [[NSNotificationCenter defaultCenter]addObserver:logger
                                            selector:@selector(zoneChange:)
                                                name:NSSystemTimeZoneDidChangeNotification
                                              object:nil];
    NotificationA *notiA = [[NotificationA alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:notiA
                                             selector:@selector(receiveNotification)
                                                 name:@"receiveNotification"
                                               object:nil];
    NotificationB *notiB = [[NotificationB alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:notiB
                                             selector:@selector(receiveNotification)
                                                 name:@"receiveNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNotification"
                                                        object:nil];
    
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    AViewController *vc = [[AViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)btnClick {
    NSLog(@"按钮点击事件");
}
@end
