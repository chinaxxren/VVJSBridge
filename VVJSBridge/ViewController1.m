//
// Created by 赵江明 on 2021/10/22.
// Copyright (c) 2021 chinaxxren. All rights reserved.
//


#import "ViewController1.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"First";
    self.view.backgroundColor = [UIColor greenColor];


    UIButton *gotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    [gotoBtn setTitle:@"Go To Second" forState:UIControlStateNormal];
    [gotoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    gotoBtn.center = self.view.center;
    [gotoBtn addTarget:self action:@selector(goTo2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gotoBtn];
}

- (void)goTo2 {

}

@end
