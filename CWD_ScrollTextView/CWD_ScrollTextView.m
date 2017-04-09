//
//  CWD_ScrollTextView.m
//  文本左右循环滚动
//
//  Created by Anthony on 2017/4/6.
//  Copyright © 2017年 XWSD. All rights reserved.
//

#import "CWD_ScrollTextView.h"

@interface CWD_ScrollTextView()<UIScrollViewDelegate>
/// 定时器
@property (nonatomic,strong) NSTimer *timer;

@end
@implementation CWD_ScrollTextView

NSInteger const Normal_Tag = 2000;
/// 定时器秒数
NSInteger const timeNumber = 3;
#pragma mark -- init
- (instancetype)initWithScrollType:(CWD_ScrollType)scrolltype titleArr:(NSMutableArray *)arr Frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.arrTitle = arr;
        self.scrollType = scrolltype;
        //设置背景颜色
        self.backgroundColor = [UIColor lightGrayColor];
        if (self.scrollType==CWD_ScrollTypeAround) {
            //设置滚动量
            self.contentSize = CGSizeMake(self.frame.size.width*self.arrTitle.count,0);
        }else{
            //设置滚动量
            self.contentSize = CGSizeMake(0,self.bounds.size.height*self.arrTitle.count);
        }
        //设置偏移量
        self.contentOffset = CGPointMake(0, 0);
        //设置按页滚动
        self.pagingEnabled = YES;
        //设置是否显示水平滑动条
        self.showsHorizontalScrollIndicator = NO;
        //设置是否边界反弹
        self.bounces = NO;
        //设置不许拖动
        self.scrollEnabled = NO;
        //设置代理
        self.delegate = self;
        
        [self createLabel];
        
    }
    return self;
}
#pragma mark -- private methods
/// 创建字符串内容文本的方法
- (void)createLabel {
    //循环创建文本信息控件
    for (int i=0; i < self.arrTitle.count; i++) {
        UILabel *messageLabel = [[UILabel alloc]init];
        messageLabel.text = [self.arrTitle objectAtIndex:i];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:15*[UIScreen mainScreen].bounds.size.width/375.0];
        if (self.scrollType == CWD_ScrollTypeAround) {
             messageLabel.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            
        }else{
             messageLabel.frame = CGRectMake(0, i*self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        }

        messageLabel.tag =i + Normal_Tag;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        messageLabel.userInteractionEnabled = YES;
        [messageLabel addGestureRecognizer:tapGesture];
        [self addSubview:messageLabel];
    }
    [self addTimer];
    
}

/// 开启定时器
- (void)addTimer {
        //设置定时器  这里设置为3秒，可以自行更改
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeNumber target:self selector:@selector(timeRunning:) userInfo:nil repeats:YES];
}
/// 关闭定时器
- (void)removeTimer {
    if (_timer) {
        if ([self.timer isValid]) {
            [self.timer invalidate];
            _timer = nil;
        }
    }
}

/// 给控件设置新的字符串数组
- (void)setScrollTitleArr:(NSMutableArray *)arr {
    //移除定时器
    [self removeTimer];
    //移除在控件中的所有子控件
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //清空数组
    [self.arrTitle removeAllObjects];
    self.arrTitle = arr;
    if (self.scrollType == CWD_ScrollTypeAround) {
            //设置滚动量
        self.contentSize = CGSizeMake(self.frame.size.width*self.arrTitle.count,0);
    }else{
        //设置滚动量
        self.contentSize = CGSizeMake(0,self.bounds.size.height*self.arrTitle.count);
    }
    
    
    [self createLabel];
    
}

#pragma mark -- response event
/// 定时器方法
- (void)timeRunning:(NSTimer *)time {
    
    //获取当前scrollview滚动到的点
    CGFloat offSetx = self.contentOffset.x;
    
    CGFloat offSety = self.contentOffset.y;
    if (self.scrollType == CWD_ScrollTypeAround) {
        //让scrollview向右滚动一个屏幕宽的距离
        offSetx += self.bounds.size.width;
        [self setContentOffset:CGPointMake(offSetx, 0) animated:YES];
    }else{
        //让scrollview向上滚动一个屏幕高的距离
        offSety += self.bounds.size.height;
        [self setContentOffset:CGPointMake(0, offSety) animated:YES];
    }
    
}
/// 点击字符串内容文本的方法
- (void)tapClick:(UITapGestureRecognizer *)sender {
    if (self.ScrollBlock) {
        //将点击的控件下标用代码块传出
        self.ScrollBlock(sender.view.tag-Normal_Tag);
    }
}

#pragma mark -- <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //获得偏移量
    CGPoint point = self.contentOffset;
    //获得当前的最大x值(在可见区域内，最大的x轴上的值)
    CGFloat manX = self.bounds.size.width * (self.arrTitle.count - 1);
    //获得当前的最大Y值(在可见区域内，最大的Y轴上的值)
    CGFloat manY = self.bounds.size.height * (self.arrTitle.count - 1);
    
    if (self.scrollType == CWD_ScrollTypeAround) {
        if (point.x == manX) {
            //到最后一个文本信息时，先移除定时器
            [self removeTimer];
            //做一个延时动作 与定时器的时间相同
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeNumber * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //将滚动的位置设为第一个文本信息的位置
                [self setContentOffset:CGPointMake(0, 0)];
                //重新启动定时器
                [self addTimer];
            });
            
        }
    }else{
        if (point.y == manY)
        {
            //到最后一个文本信息时，先移除定时器
            [self removeTimer];
            //做一个延时动作 与定时器的时间相同
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeNumber * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //将滚动的位置设为第一个文本信息的位置
                [self setContentOffset:CGPointMake(0, 0)];
                //重新启动定时器
                [self addTimer];
            });
        }
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

#pragma mark -- getter/setter

- (NSMutableArray *)arrTitle {
    if (!_arrTitle) {
        _arrTitle = [NSMutableArray new];
    }
    return _arrTitle;
}


@end
