//
//  LoadButton.h
//  Pic
//
//  Created by 沈增光 on 2017/8/9.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoadButton;

typedef void(^LoadingBegin)(LoadButton*btn);
typedef void(^LoadingEnd)(LoadButton*btn);

@interface LoadButton : UIButton

#pragma mark - 是否正在加载
@property(nonatomic,assign,readonly)BOOL isLoading;

#pragma mark - 每次动画运行的时间
@property(nonatomic,assign)NSTimeInterval duration;

#pragma mark - 线宽度
@property(nonatomic,assign)CGFloat loadingLineWidth;

#pragma mark - 加载线的颜色
@property(nonatomic,strong)UIColor *loadingTintColor;

#pragma mark - 加载层
@property(nonatomic,strong,readonly)CAShapeLayer *loadingLayer;

#pragma mark - 动画开始回调
@property(nonatomic,strong)LoadingBegin beginBlock;

#pragma mark - 动画结束回调
@property(nonatomic,strong)LoadingEnd endBlock;

#pragma mark - 加载时是否disable按钮
@property(nonatomic,assign)BOOL disableWhenLoad;

#pragma mark - 开始加载
-(void)beginLoading;

#pragma mark - 停止加载
-(void)endLoading;

#pragma mark - 切换
-(void)toggle;

@end
