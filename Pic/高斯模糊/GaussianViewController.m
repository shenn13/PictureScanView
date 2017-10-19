//
//  GaussianViewController.m
//  Pic
//
//  Created by 沈增光 on 2017/10/19.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "GaussianViewController.h"
#import "UIImage+Gaussian.h"
#define SCREENWIDTH   [UIScreen mainScreen].bounds.size.width


@interface GaussianViewController ()

@property  (strong,nonatomic)  UITextField  *textField;
@property  (strong,nonatomic)  UIButton     *button;

@property  (strong,nonatomic)  UIImage      *image;
@property  (strong,nonatomic)  UIImageView  *imageView;

@end

@implementation GaussianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  - getter and  setter
-(UIButton *)button{
    if (!_button) {
        _button=[[UIButton alloc]initWithFrame:CGRectMake(270,64, 80, 40)];
        _button.layer.borderColor=[[UIColor redColor] CGColor];
        _button.layer.borderWidth=1.0f;
        [_button setTitle:@"设置" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_button addTarget:self action:@selector(changeImageBlur:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _button;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField=[[UITextField alloc]initWithFrame:CGRectMake(100, 64, 80, 40)];
        [_textField setPlaceholder:@"测试"];
        [_textField setBorderStyle:UITextBorderStyleLine];
        [_textField setFont:[UIFont systemFontOfSize:14]];
    }
    return _textField;
}

-(UIImage *)image{
    if (!_image) {
        _image=[UIImage imageNamed:@"Person"];
    }
    return _image;
}
#pragma mark - UIButton
-(void)changeImageBlur:(UIButton *)sender{
    CGFloat value=[self.textField.text floatValue];
    self.imageView.image=[UIImage boxblurImage:self.image withBlurNumber:value];
}
#pragma mark - SubViews
-(void)configSubviews{
    [self.view addSubview:self.textField];
    [self.view addSubview:self.button];
    [self configImageOne];
    [self configImageTwo];
    [self configImageThree];
}
-(void)configImageOne{
    UIImageView  *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 140, SCREENWIDTH, 100)];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.image=self.image;
    imageView.clipsToBounds=YES;
    [self.view addSubview:imageView];
}

-(void)configImageTwo{
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 300, SCREENWIDTH, 100)];
    self.imageView.contentMode=UIViewContentModeScaleAspectFill;
    self.imageView.image=[UIImage boxblurImage:self.image withBlurNumber:0.5];
    self.imageView.clipsToBounds=YES;
    [self.view addSubview:self.imageView];
}

-(void)configImageThree{
    UIImageView  *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 420, SCREENWIDTH, 100)];
    imageView.contentMode=UIViewContentModeScaleAspectFill;
    imageView.image=[UIImage coreBlurImage:self.image withBlurNumber:2];
    imageView.clipsToBounds=YES;
    [self.view addSubview:imageView];
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
