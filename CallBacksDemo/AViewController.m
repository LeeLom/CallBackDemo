//
//  AViewController.m
//  CallBacksDemo
//
//  Created by LeeLom on 2017/9/13.
//  Copyright © 2017年 LeeLom. All rights reserved.
//

#import "AViewController.h"
#import "BViewController.h"

@interface AViewController ()
@property (strong, nonatomic) IBOutlet UILabel *textLabel;

@property (strong, nonatomic) IBOutlet UILabel *anotherTextLabel;
@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AViewController";
}


- (IBAction)getValueFromB:(id)sender {
    BViewController *vc = [[BViewController alloc]init];
    __weak AViewController *weakSelf = self; //避免循环引用
    vc.callBackBlock = ^(NSString *text) {
        weakSelf.textLabel.text = text;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)anotherButtonClick:(id)sender {
    BViewController *vc = [[BViewController alloc]init];
    __weak AViewController *weakSelf = self; //避免循环引用
    [vc passBlock:^(NSString *text) {
        weakSelf.anotherTextLabel.text = text;
    }];
}





@end
