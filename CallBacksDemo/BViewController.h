//
//  BViewController.h
//  CallBacksDemo
//
//  Created by LeeLom on 2017/9/13.
//  Copyright © 2017年 LeeLom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlock)(NSString *text); // 定义带有参数text的block

@interface BViewController : UIViewController

@property (nonatomic, copy)CallBackBlock callBackBlock;

// 另一种Block回调的实现方式
- (void)passBlock:(CallBackBlock)block;
@end
