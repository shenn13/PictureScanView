//
//  PictureScanView.m
//  Pic
//
//  Created by 沈增光 on 2017/8/3.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "PictureScanView.h"


@interface PictureScanView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation PictureScanView

static PictureScanView *picView = nil;

+(instancetype)share{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        picView = [[PictureScanView alloc]init];
        picView.userInteractionEnabled = YES;
    });
    return picView;
}

-(void)createUIWithImage:(UIImage *)image ImgUrl:(NSString *)imageUrl
{
    if (imageUrl == nil && image == nil) {
        return;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 3;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor blackColor];
    self.imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
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
    //一个手指
    UITapGestureRecognizer *singleClickDog = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singliDogTap:)];
    UITapGestureRecognizer *doubleClickTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    //两个手指
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTwoFingerTap:)];
    singleClickDog.numberOfTapsRequired = 1;
    singleClickDog.numberOfTouchesRequired = 1;
    doubleClickTap.numberOfTapsRequired = 2;//需要点两下
    twoFingerTap.numberOfTouchesRequired = 2;
   
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [window addSubview:_scrollView];
    [_scrollView addSubview:_imageView];
    [_scrollView setZoomScale:1];
    [_imageView addGestureRecognizer:doubleClickTap];
    [_imageView addGestureRecognizer:twoFingerTap];
    [singleClickDog requireGestureRecognizerToFail:doubleClickTap];//如果双击了，则不响应单击事件
    [window addGestureRecognizer:singleClickDog];
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
    NSLog(@"---------------------");
    if (gestureRecognizer.numberOfTapsRequired == 1)
    {
       [self removeFromSuperview];
        [_scrollView removeFromSuperview];
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
