//
//  BUttonViewController.m
//  Pic
//
//  Created by 沈增光 on 2017/8/9.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "BUttonViewController.h"
#import "LoadButton.h"

@interface BUttonViewController (){
     NSInteger i;
}

@end

@implementation BUttonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    i = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    LoadButton *_btn = [[LoadButton alloc]initWithFrame:CGRectMake(20, 120, CGRectGetWidth(self.view.frame) - 40, 44.f)];
    _btn.layer.cornerRadius = 8.f;
    [_btn setBackgroundImage:[UIImage imageNamed:@"login_bg"] forState:UIControlStateNormal];
    [_btn setBackgroundImage:[UIImage imageNamed:@"loginclicked_bg"] forState:UIControlStateHighlighted];
    [_btn setTitle:@"登录" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
}
-(void)btnClicked:(LoadButton*)sender{
   
    i ++;
    [sender toggle];
    
    NSLog(@"暴力点击==========%ld",(long)i);
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
