//
//  LoopScrollView.h
//  CommentFun
//
//  Created by Lee on 2017/3/1.
//  Copyright © 2017年 李家乐. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    Rolling_direction_V,
    Rolling_direction_H
}Rolling_direction;

@protocol LoopScrollViewDelegate <NSObject>

@optional
- (void)tapImageHandelBack:(id)imageData;

@end

@interface LoopScrollView : UIView
/*
 lSVDelegate: 代理
 */
@property (nonatomic, assign) id<LoopScrollViewDelegate> lSVDelegate;
/*
 imageNames: 图片数组
 */
@property (nonatomic, strong) NSArray * imageNames;

- (instancetype)initWithFrame:(CGRect)frame loopTime:(CGFloat)time direction:(Rolling_direction)direction;

@end
