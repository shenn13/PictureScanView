
//
//  CenterViewController.m
//  Pic
//
//  Created by 沈增光 on 2017/8/25.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "CenterViewController.h"
#import "WRCellView.h"


@interface CenterViewController ()

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    WRCellView *cellView = [[WRCellView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 50) lineStyle:WRCellStyleLabel_LabelIndicator];
    cellView.backgroundColor = [UIColor lightGrayColor];
    cellView.leftLabel.text = @"123344";
    cellView.rightLabel.text = @"1223455";
    cellView.rightIndicator.image = [UIImage imageNamed:@"jiaxiaotongimg_0"];
    cellView.tapBlock = ^{
        NSLog(@"=========");
    };
    [self.view addSubview:cellView];
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
