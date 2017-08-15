//
//  PictureScanView.h
//  Pic
//
//  Created by 沈增光 on 2017/8/3.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import <UIKit/UIKit.h>



@class PictureScanView;

@interface PictureShowView : NSObject

+(PictureScanView *)showImageView:(UIImage *)image imageUrl:(NSString *)url;

@end

@class PictureScanView;

@interface PictureScanView : UIView

-(void)createUIWithImage:(UIImage *)image ImgUrl:(NSString *)imageUrl;

@end
