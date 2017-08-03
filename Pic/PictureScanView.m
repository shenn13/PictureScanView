//
//  PictureScanView.m
//  Pic
//
//  Created by 沈增光 on 2017/8/3.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "PictureScanView.h"

#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@interface PictureScanView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation PictureScanView

-(void)createUIWithImage:(UIImage *)image ImgUrl:(NSString *)imageUrl
{
    if (imageUrl == nil && image == nil) {
        return;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 3;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;
    if (imageUrl == nil) {
        //本地图片
        self.imageView.image = image;
    }
    if (image == nil) {
        
        //网络图片 可设置其他加载图片 根据需求来~
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
    [_scrollView addSubview:_imageView];
    //一个手指
    UITapGestureRecognizer *singleClickDog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singliDogTap:)];
    UITapGestureRecognizer *doubleClickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    //两个手指
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTwoFingerTap:)];
    singleClickDog.numberOfTapsRequired = 1;
    singleClickDog.numberOfTouchesRequired = 1;
    doubleClickTap.numberOfTapsRequired = 2;//需要点两下
    twoFingerTap.numberOfTouchesRequired = 2;
    [_imageView addGestureRecognizer:singleClickDog];
    [_imageView addGestureRecognizer:doubleClickTap];
    [_imageView addGestureRecognizer:twoFingerTap];
    [singleClickDog requireGestureRecognizerToFail:doubleClickTap];//如果双击了，则不响应单击事件
    [_scrollView setZoomScale:1];
    [self addSubview:_scrollView];
}

#pragma mark - ScrollView Delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
//缩放系数(倍数)
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}
#pragma mark - 事件处理
-(void)singliDogTap:(UITapGestureRecognizer *)gestureRecognizer
{
  
    if (gestureRecognizer.numberOfTapsRequired == 1)
    {
       [self removeFromSuperview];
    }
}
-(void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer{
  
    if (gestureRecognizer.numberOfTapsRequired == 2) {
        if(_scrollView.zoomScale == 1){
            float newScale = [_scrollView zoomScale] *2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [_scrollView zoomToRect:zoomRect animated:YES];
        }else{
            float newScale = [_scrollView zoomScale]/2;
            CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
            [_scrollView zoomToRect:zoomRect animated:YES];
        }
    }
}

-(void)handelTwoFingerTap:(UITapGestureRecognizer *)gestureRecongnizer{

    float newScale = [_scrollView zoomScale]/2;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecongnizer locationInView:gestureRecongnizer.view]];
    [_scrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark - 缩放大小获取方法
-(CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    //大小
    zoomRect.size.height = [_scrollView frame].size.height/scale;
    zoomRect.size.width = [_scrollView frame].size.width/scale;
    //原点
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    return zoomRect;
}


@end
