//
//  ViewController.m
//  CWD_ScrollTextView
//
//  Created by anthony on 2017/4/9.
//  Copyright © 2017年 anthony. All rights reserved.
//

#import "ViewController.h"
#import "CWD_ScrollTextView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    //创建一个文本数组
    NSArray *arr = @[@"优惠券满8000立减800",@"张先生成功贷款 80 万元",@"苹果公司严厉打击热更新",@"德文·布克成为最年轻70分先生"];
    //创建一个可变数组去添加数组内的值
    NSMutableArray *nsmu = [NSMutableArray arrayWithArray:arr];
    
    [self createUpdown:nsmu];
    [self createAround:nsmu];
}
/// 创建上下滚动的文本信息
-(void)createUpdown:(NSMutableArray *)arr {
    CWD_ScrollTextView *updownScroll = [[CWD_ScrollTextView alloc]initWithScrollType:CWD_ScrollTypeUpDown titleArr:arr Frame:CGRectMake(0, 30, self.view.frame.size.width, 40)];
    [updownScroll setScrollBlock:^(NSInteger index) {
        //在代码块中获取点击下标，做跳转或者其他动作
        NSLog(@"点击了第%ld个标题",index);
    }];
    [self.view addSubview:updownScroll];
    
}
/// 创建左右滚动的文本信息
-(void)createAround:(NSMutableArray *)arr {
    CWD_ScrollTextView *aroundScroll = [[CWD_ScrollTextView alloc]initWithScrollType:CWD_ScrollTypeAround titleArr:arr Frame:CGRectMake(0, 110, self.view.frame.size.width, 40)];
    [aroundScroll setScrollBlock:^(NSInteger index) {
        //在代码块中获取点击下标，做跳转或者其他动作
        NSLog(@"点击了第%ld个标题",index);
    }];
    [self.view addSubview:aroundScroll];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
