//
//  suijiViewController.m
//  Pic
//
//  Created by 沈增光 on 2017/8/7.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "suijiViewController.h"
#import "CodeView.h"

@interface suijiViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic, retain)CodeView * codeView;

@property(nonatomic, retain)UITextField * inputTextField;

@end

@implementation suijiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    _codeView = [[CodeView alloc]initWithFrame:CGRectMake(20, 100, 90, 40)];
    
    [self.view addSubview:_codeView];
    
    //提示文字
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(190, 100, 100, 40)];
    
    label.text = @"点击图片换验证码";
    
    label.font = [UIFont systemFontOfSize:12];
    
    label.textColor = [UIColor grayColor];
    
    [self.view addSubview:label];
    
    
    
    //添加输入框
    
    _inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 160, 150, 40)];
    
    _inputTextField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    _inputTextField.layer.borderWidth = 2.0;
    
    _inputTextField.layer.cornerRadius = 5.0;
    
    _inputTextField.font = [UIFont systemFontOfSize:21];
    
    _inputTextField.placeholder = @"请输入验证码";
    
    _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _inputTextField.backgroundColor = [UIColor clearColor];
    
    _inputTextField.textAlignment = NSTextAlignmentCenter;
    
    _inputTextField.returnKeyType = UIReturnKeyDone;
    
    _inputTextField.delegate = self;
    
    [self.view addSubview:_inputTextField];
    
    
    
    //添加手势，用来隐藏键盘
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToHideTheKeyBoard:)];
    
    tapGestureRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}


#pragma mark --Tap
-(void)tapToHideTheKeyBoard:(UITapGestureRecognizer *)tap{
    
    //    [_inputTextField resignFirstResponder];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [_inputTextField resignFirstResponder];
    
}


#pragma mark --UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([_inputTextField.text isEqualToString:_codeView.changeString ] || [_inputTextField.text isEqualToString:[_codeView.changeString lowercaseString]]) {
        //弹出正确
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"恭喜您" message:@"验证成功" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        
        [alertView show];
        
    }else{
        
        //验证码不匹配，验证码和输入框晃动
        
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        
        animation.repeatCount = 1;
        
        animation.values = @[@-20,@20,@-20];
        
        [_codeView.layer addAnimation:animation forKey:nil];
        
        [_inputTextField.layer addAnimation:animation forKey:nil];
        
    }
    
    return YES;
    
}

#pragma mark --UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //清空输入框内容，收回键盘
    
    if (buttonIndex == 0) {
        
        _inputTextField.text = @"";
        
        [_inputTextField resignFirstResponder];
        
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
