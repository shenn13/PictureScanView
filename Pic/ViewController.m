//
//  ViewController.m
//  Pic
//
//  Created by 沈增光 on 2017/8/3.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "ViewController.h"
#import "PictureScanView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    button.center = self.view.center;
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

-(void)buttonClicked{
  
    
    PictureScanView *pic = [[PictureScanView alloc] initWithFrame:self.view.bounds];
    [pic createUIWithImage:[UIImage imageNamed:@"test0.jpg"] ImgUrl:nil];
    
    pic.backgroundColor = [UIColor blackColor];

    [self.view addSubview:pic];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
