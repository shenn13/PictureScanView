//
//  UIImage+Gaussian.h
//  Pic
//
//  Created by 沈增光 on 2017/10/19.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>


@interface UIImage (Gaussian)

/**
 *  CoreImage图片高斯模糊
 *
 *  @param image 图片
 *  @param blur  模糊数值(默认是10)
 *
 *  @return 重新绘制的新图片
 */

+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
/**
 *  vImage模糊图片
 *
 *  @param image 原始图片
 *  @param blur  模糊数值(0-1)
 *
 *  @return 重新绘制的新图片
 */
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
