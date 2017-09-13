//
//  BViewController.m
//  CallBacksDemo
//
//  Created by LeeLom on 2017/9/13.
//  Copyright © 2017年 LeeLom. All rights reserved.
//

#import "BViewController.h"

@interface BViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BViewController";
    
}


- (IBAction)popToA:(id)sender {
    NSLog(@"text:%@",_textField.text);
    self.callBackBlock(_textField.text);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 另一种实现方式
- (void)passBlock:(CallBackBlock)block {
    block(@"这是另外一种方式的...");
}

@end
