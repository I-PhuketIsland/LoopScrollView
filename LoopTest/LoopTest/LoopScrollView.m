//
//  LoopScrollView.m
//  CommentFun
//
//  Created by Lee on 2017/3/1.
//  Copyright © 2017年 李家乐. All rights reserved.
//

#import "LoopScrollView.h"
#import <Masonry.h>

@interface LoopScrollView()<UIScrollViewDelegate>
/*
 <#name#>: <#description#>
 */
@property (nonatomic, strong) UIScrollView* scrollView;
/*
 <#name#>: <#description#>
 */
@property (nonatomic, strong) UIPageControl* pageControll;
/*
 <#name#>: <#description#>
 */
@property (nonatomic, assign) NSInteger currentPage;
/*
 <#name#>: <#description#>
 */
@property (nonatomic, assign) Rolling_direction direction;
/*
 <#name#>: <#description#>
 */
@property (nonatomic, strong) NSTimer* timer;
/*
 <#name#>: <#description#>
 */
@property (nonatomic, assign) CGFloat time;
@end

@implementation LoopScrollView

- (instancetype)initWithFrame:(CGRect)frame loopTime:(CGFloat)time direction:(Rolling_direction)direction {
    if (self = [super initWithFrame:frame]) {
        self.direction = direction;
        self.time = time;
        self.currentPage = 0;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.pageControll mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];
}
- (void)timeOn {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(timerScroll:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)timeOff {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)setupView {
    for (int i = 0  ; i<self.imageNames.count + 2; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        
        if (i == 0) {
            imageView.image = [UIImage imageNamed:self.imageNames[self.imageNames.count -1]];
        }else if (i == self.imageNames.count + 1) {
            imageView.image = [UIImage imageNamed:self.imageNames[0]];
        }else {
            imageView.image = [UIImage imageNamed:self.imageNames[i - 1]];
        }
        if (self.direction == Rolling_direction_H) {
            imageView.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
        }else {
            imageView.frame = CGRectMake(0, self.frame.size.height * i, self.frame.size.width, self.frame.size.height);
        }
        [self.scrollView addSubview:imageView];
    }
    
}
- (void)setImageNames:(NSArray *)imageNames {
    _imageNames = imageNames;
    [self addSubview:self.scrollView];
    [self setupView];
    [self addSubview:self.pageControll];
    [self timeOn];
    
}
- (void)tapImage:(UITapGestureRecognizer*)tap {
    CGPoint point = [tap locationInView:self.scrollView];
    NSInteger index;
    if (self.direction == Rolling_direction_H) {
        index = point.x / self.frame.size.width;
    }else {
        index = point.x / self.frame.size.height;
    }
    [self.lSVDelegate tapImageHandelBack:self.imageNames[index - 1]];
}
- (void)pageControllChange:(UIPageControl *)pageControll event:(UIEvent *)touchs{
    UITouch *touch = [[touchs allTouches]anyObject];
    CGPoint p = [touch locationInView:pageControll];
    CGFloat avgIndexWidth = pageControll.frame.size.width / self.imageNames.count;
    NSInteger index = p.x / avgIndexWidth;
    self.currentPage = index;
    pageControll.currentPage = index;
    
    [self.scrollView setContentOffset:CGPointMake((pageControll.currentPage + 1)*self.frame.size.width, 0)];
    
    
}
- (void)timerScroll:(NSTimer*)timer {
    if (self.currentPage < _imageNames.count) {
        self.currentPage ++;
    }
    CGPoint offset = self.scrollView.contentOffset;
    if (self.direction == Rolling_direction_H) {
        offset.x = self.frame.size.width * (self.currentPage +1);
        [self.scrollView setContentOffset:offset animated:YES];
        
    }else {
        offset.y = self.frame.size.height * (self.currentPage +1);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    
    if (self.currentPage == _imageNames.count) {
        self.currentPage = 0;
    }
    self.pageControll.currentPage = self.currentPage;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self timeOff];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    
    
    if (self.direction == Rolling_direction_H) {
        if (offset.x == 0) {
            offset.x = self.frame.size.width * _imageNames.count;
            scrollView.contentOffset = offset;
            self.currentPage = _imageNames.count - 1;
        }else if(offset.x/self.frame.size.width == _imageNames.count +1){
            offset.x = self.frame.size.width;
            scrollView.contentOffset = offset;
            self.currentPage = 0;
        }else {
            self.currentPage = offset.x / self.frame.size.width - 1;
        }
        
    }else {
        if (offset.y == 0) {
            offset.y = self.frame.size.height * _imageNames.count;
            scrollView.contentOffset = offset;
            self.currentPage = _imageNames.count - 1;
        }else if(offset.y/self.frame.size.height == _imageNames.count +1){
            offset.y = self.frame.size.height;
            scrollView.contentOffset = offset;
            self.currentPage = 0;
        }else {
            self.currentPage = offset.y / self.frame.size.height - 1;
        }
    }
    
    self.pageControll.currentPage = self.currentPage;
    [self timeOn];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (self.direction == Rolling_direction_H) {
        if (offset.x == self.frame.size.width *(_imageNames.count + 1)) {
            offset.x = self.frame.size.width;
        }
        
    }else {
        if (offset.y == self.frame.size.height *(_imageNames.count + 1)) {
            offset.y = self.frame.size.height;
        }
    }
    
    scrollView.contentOffset = offset;
}
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        CGPoint offset = _scrollView.contentOffset;
        
        if (_direction == Rolling_direction_H) {
            _scrollView.contentSize = CGSizeMake((_imageNames.count + 2) * self.frame.size.width, 0);
            offset.x = self.frame.size.width;
            
        }else {
            _scrollView.contentSize = CGSizeMake(0, (_imageNames.count + 2) * self.frame.size.height);
            offset.y = self.frame.size.height;
        }
        
        _scrollView.contentOffset = offset;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}
- (UIPageControl *)pageControll {
    if (_pageControll == nil) {
        _pageControll = [[UIPageControl alloc]init];
        _pageControll.numberOfPages = _imageNames.count;
        _pageControll.currentPage = self.currentPage;
//        _pageControll.userInteractionEnabled = NO;
        /*
         //kvc自定义图片
         [_pageControll setValue:[UIImage imageNamed:@"image1"] forKeyPath:@"_pageImage"];
         
         [_pageControll setValue:[UIImage imageNamed:@"image2"] forKeyPath:@"_currentPageImage"];
         */
        _pageControll.pageIndicatorTintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
        _pageControll.currentPageIndicatorTintColor = [[UIColor orangeColor]colorWithAlphaComponent:0.8];
        _pageControll.hidesForSinglePage = YES;
        [_pageControll addTarget:self action:@selector(pageControllChange:event:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageControll;
}




@end
