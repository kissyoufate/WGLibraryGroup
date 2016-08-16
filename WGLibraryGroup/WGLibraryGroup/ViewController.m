//
//  ViewController.m
//  WGLibraryGroup
//
//  Created by wanggang on 16/8/16.
//  Copyright © 2016年 wanggang. All rights reserved.
//

#import "ViewController.h"
#import "WGLibraryList_Controller.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonClick:(UIButton *)sender {
    WGLibraryList_Controller *lVC = [[WGLibraryList_Controller alloc] init];
    /*
     1.有导航栏
     [self.navigationController pushViewController:lVC animated:YES];
     */
    //2.无导航
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lVC];
    [self presentViewController:nav animated:YES completion:^{
    }];

}


@end
