//
//  ViewController.m
//  LoopTest
//
//  Created by Lee on 2017/3/1.
//  Copyright © 2017年 李家乐. All rights reserved.
//

#import "ViewController.h"
#import "LoopScrollView.h"

@interface ViewController ()<LoopScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LoopScrollView *ss = [[LoopScrollView alloc]initWithFrame:CGRectMake(100, 100, 200, 300) loopTime:3 direction:Rolling_direction_H];
    ss.lSVDelegate = self;
    ss.imageNames = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"];
    [self.view addSubview:ss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
