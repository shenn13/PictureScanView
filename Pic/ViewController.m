//
//  ViewController.m
//  Pic
//
//  Created by 沈增光 on 2017/8/3.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "ViewController.h"
#import "PictureViewController.h"
#import "GifViewController.h"
#import "HWWaveViewController.h"
#import "suijiViewController.h"
@interface ViewController (){
    NSArray *_dataArr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
 
    _dataArr = @[@"手势点击放大缩小图片封装",@"加载GIF动画",@"水波纹特效",@"获取随机验证码"];
  
    
}



#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[PictureViewController new] animated:YES];
    }
    if (indexPath.row == 1) {
       [self.navigationController pushViewController:[GifViewController new] animated:YES];
    }
    if (indexPath.row == 2) {
        
     [self.navigationController pushViewController:[HWWaveViewController new] animated:YES];
    }
    if (indexPath.row == 3) {
        
        [self.navigationController pushViewController:[suijiViewController new] animated:YES];
    }
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    return 80;
}




-(void)buttonClicked{
  
    
   
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
