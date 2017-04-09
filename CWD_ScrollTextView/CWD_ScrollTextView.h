//
//  CWD_ScrollTextView.h
//  文本左右循环滚动
//
//  Created by Anthony on 2017/4/6.
//  Copyright © 2017年 XWSD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CWD_ScrollType)//滚动方式
{
    CWD_ScrollTypeAround,//左右滚动
    CWD_ScrollTypeUpDown//上下滚动
    
};

@interface CWD_ScrollTextView : UIScrollView
/// 文本数组
@property (nonatomic,strong) NSMutableArray *arrTitle;
/// 文本滚动方式
@property (nonatomic,assign) CWD_ScrollType scrollType;
/// 点击文本跳转的代码块
@property (nonatomic,copy) void(^ScrollBlock)(NSInteger index);

/**
 控件自定义初始化方法
 @param scrolltype   控件文本的滚动方式
 @param arr          控件字符串文本数组
 @param frame        控件的frame
 @return             控件实例
 */
- (instancetype)initWithScrollType:(CWD_ScrollType)scrolltype titleArr:(NSMutableArray *)arr Frame:(CGRect)frame;

/**
 给控件设置字符串文本数组
 @param arr 字符串文本数组
 */
- (void)setScrollTitleArr:(NSMutableArray *)arr;
@end
