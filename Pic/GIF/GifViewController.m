//
//  GifViewController.m
//  Pic
//
//  Created by 沈增光 on 2017/8/4.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "GifViewController.h"


#import <Lottie/Lottie.h>



//屏幕的宽和高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface GifViewController ()<OLImageViewDelegate>

@property (nonatomic, getter=isRunning) BOOL running;

@end

@implementation GifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //第一种加载方式
    OLImageView *gitAimv = [[OLImageView alloc] initWithImage:[OLImage imageNamed:@"notEven.gif"]];
    [gitAimv setFrame:CGRectMake(0, 64, 160, 160)];
    [gitAimv setUserInteractionEnabled:YES];
    [gitAimv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    [self.view addSubview:gitAimv];
    
    
    gitAimv = [[OLImageView alloc] initWithImage:[OLImage imageNamed:@"google-io"]];
    [gitAimv setFrame:CGRectMake(0, 224, 160, 160)];
    [gitAimv setUserInteractionEnabled:YES];
    [gitAimv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    [self.view addSubview:gitAimv];
    
    gitAimv = [[OLImageView alloc] initWithImage:[OLImage imageNamed:@"fdgdf.gif"]];
    [gitAimv setFrame:CGRectMake(160, 64, 160, 160)];
    [gitAimv setUserInteractionEnabled:YES];
    [gitAimv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    [self.view addSubview:gitAimv];
    
    gitAimv = [[OLImageView alloc] initWithImage:[OLImage imageNamed:@"AA.gif"]];
    gitAimv.delegate = self;
    [gitAimv setFrame:CGRectMake(160, 224, 160, 160)];
    [gitAimv setUserInteractionEnabled:YES];
    [gitAimv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    [self.view addSubview:gitAimv];
    
    
     //第二种加载方式
    //【链接】大杀器Bodymovin和Lottie：把AE动画转换成HTML5/A
    //http://www.cnblogs.com/zamhown/p/6688369.html
    
    LOTAnimationView *fengcheView = [LOTAnimationView animationNamed:@"fengchedata"];
    fengcheView.frame = CGRectMake((kScreenWidth - 75)/2, kScreenHeight - 60 - 83 ,75 ,83) ;
    fengcheView.contentMode = UIViewContentModeScaleToFill;
    fengcheView.loopAnimation = YES;

    fengcheView.userInteractionEnabled = NO;
    [self.view addSubview:fengcheView];
    [fengcheView playWithCompletion:^(BOOL animationFinished) {
        NSLog(@"播放完毕");
    }];
    
    
}

- (void)handleTap:(UITapGestureRecognizer *)gestRecon
{
    OLImageView *imageView = (OLImageView *)gestRecon.view;
    if (self.isRunning) {
        self.running = NO;
        NSLog(@"STOP");
        [imageView stopAnimating];
    } else {
        self.running = YES;
        NSLog(@"START");
        [imageView startAnimating];
    }
}

-(BOOL)imageViewShouldStartAnimating:(OLImageView *)imageView {
    
    return self.isRunning;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
