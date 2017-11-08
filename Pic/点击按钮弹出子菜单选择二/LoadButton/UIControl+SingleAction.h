//
//  UIControl+SingleAction.h
//  XBSingleTouchTest
//
//  Created by chuango on 16/10/28.
//  Copyright © 2016年 chuango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (SingleAction)
@property (nonatomic, assign) NSTimeInterval cjr_acceptEventInterval;// 可以用这个给重复点击加间隔
@end
