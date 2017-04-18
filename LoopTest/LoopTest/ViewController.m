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
    /*
    LoopScrollView *ss = [[LoopScrollView alloc]initWithFrame:CGRectMake(100, 100, 200, 300) loopTime:3 direction:Rolling_direction_H];
    ss.lSVDelegate = self;
    ss.imageNames = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"];
    [self.view addSubview:ss];
     */
    
    UIView * view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor blackColor];
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor redColor];
    LoopScrollView *sss = [[LoopScrollView alloc]initWithFrame:CGRectMake(0, 400, 200, 300) loopTime:3 direction:Rolling_direction_H];
    sss.backgroundColor = [UIColor blueColor];
    sss.imageNames = @[view1,view2];
    [self.view addSubview:sss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
