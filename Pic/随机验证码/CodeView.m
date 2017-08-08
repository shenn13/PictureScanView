//
//  CodeView.m
//  Pic
//
//  Created by 沈增光 on 2017/8/7.
//  Copyright © 2017年 沈增光. All rights reserved.
//

#import "CodeView.h"


#define kRandomColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];

#define kLineCount 4

#define kLineWidth 1.0

#define kCharCount 4

#define kFontSize [UIFont systemFontOfSize:arc4random()%5 + 15]

@interface CodeView(){
    
    NSArray * changeArray;//字符素材数组
    
}

@end

@implementation CodeView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.layer.masksToBounds = YES;//隐藏边界
        
        self.backgroundColor = kRandomColor;
        //显示一个随机验证码
        
        [self changeCaptcha];
        
    }
    
    return self;
    
}

-(void)changeCaptcha{
    
    changeArray = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z", nil];
    
    _changeString = [[NSMutableString alloc]initWithCapacity:kCharCount];
    
    NSString * getStr = [[NSString alloc]init];
    
    for (int i = 0; i < kCharCount; i++) {
        
        NSInteger index = arc4random()%(changeArray.count-1);
        
        getStr = [changeArray objectAtIndex:index];
        
        _changeString = (NSMutableString *)[_changeString stringByAppendingString:getStr];
        
    }
    
}

//设置点击，更好验证码的方法

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self changeCaptcha];
    
    [self setNeedsDisplay];
    
}

//画背景图和干扰线

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    self.backgroundColor = kRandomColor;

    //获得要显示验证码字符串，根据长度，计算每个字符显示的大概位置
    
    CGSize csize = [@"S" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    int width = rect.size.width/_changeString.length-csize.width;
    
    int height = rect.size.height-csize.height;
    
    CGPoint point;
    //一次绘制每一个字符，可以设置显示的每个字符的字体大小、颜色、样式
    
    float pX,pY;
    
    for (int i = 0; i < _changeString.length; i++) {
        
        pX = arc4random() % width + rect.size.width/_changeString.length*i;
        
        pY = arc4random()%height;
        point = CGPointMake(pX, pY);
        
        unichar c = [_changeString characterAtIndex:i];
        
        NSString * textC = [NSString stringWithFormat:@"%c",c];
        
        [textC drawAtPoint:point withAttributes:@{NSFontAttributeName:kFontSize}];
    }
    //取得栈顶的CGContextRef
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, kLineWidth);
    
    //绘制干扰的彩色直线
    
    for (int i = 0; i < kLineCount; i++) {
        
        CGFloat components[] = {arc4random()%255/255.0,arc4random()%255/255.0,arc4random()%255/255.0,arc4random()%255/255.0};
        
        CGContextSetStrokeColor(context, components);
        
        //设置起点
        
        pX = arc4random()%(int)rect.size.width;
        
        pY = arc4random()%(int)rect.size.height;
        
        CGContextMoveToPoint(context, pX, pY);
        
        //设置终点
        
        pX = arc4random()%(int)rect.size.width;
        
        pY = arc4random()%(int)rect.size.height;
        
        CGContextAddLineToPoint(context, pX, pY);
        
        CGContextStrokePath(context);
        
    }
    
}


@end
