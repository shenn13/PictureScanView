//
//  GifViewController.m
//  Pic
//
//  Created by 沈增光 on 2017/8/4.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "GifViewController.h"

@interface GifViewController ()<OLImageViewDelegate>

@property (nonatomic, getter=isRunning) BOOL running;

@end

@implementation GifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
