//
//  HWWaveViewController.m
//  Pic
//
//  Created by 沈增光 on 2017/8/7.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "HWWaveViewController.h"
#import "HWWaveView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define  WaterMaxHeight WIDTH-140
@interface HWWaveViewController ()

@property (nonatomic, weak) HWWaveView *circleView;


@property(nonatomic, strong) UISlider *slider;

@end

@implementation HWWaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    HWWaveView *circleView = [[HWWaveView alloc] initWithFrame:CGRectMake(0, 64, 260, 260)];
    circleView.userInteractionEnabled = NO;
    circleView.center = self.view.center;
    [self.view addSubview:circleView];
    self.circleView = circleView;
    
    
    
    //  滑动slider ==========================
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(100, HEIGHT-100, WIDTH-200, 20)];
    [self.view addSubview:self.slider];
    [self.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
}


- (void)sliderAction:(UISlider *)slider{
    
    if (slider.value > 0 || slider.value < 1){
        
        self.circleView.progress = slider.value;
        
        NSLog(@"-----%f",slider.value);
    }else{
        NSLog(@"progress value is error");
    }
    
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
