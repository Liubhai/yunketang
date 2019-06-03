//  代码地址: https://github.com/CoderGSMJLee/GSMJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  GSMJRefreshComponent.m
//  GSMJRefreshExample
//
//  Created by GSMJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "GSMJRefreshComponent.h"
#import "GSMJRefreshConst.h"
#import "UIView+GSMJExtension.h"

@interface GSMJRefreshComponent()
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@end

@implementation GSMJRefreshComponent
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 准备工作
        [self prepare];
        
        // 默认是普通状态
        self.state = GSMJRefreshStateIdle;
    }
    return self;
}

- (void)prepare
{
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self placeSubviews];
}

- (void)placeSubviews{}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 设置宽度
        self.mj_w = newSuperview.mj_w;
        // 设置位置
        self.mj_x = 0;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = self.scrollView.contentInset;
        
        // 添加监听
        [self addObservers];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.state == GSMJRefreshStateWillRefresh) {
        // 预防view还没显示出来就调用了beginRefreshing
        self.state = GSMJRefreshStateRefreshing;
    }
}

#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:GSMJRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:GSMJRefreshKeyPathContentSize options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:GSMJRefreshKeyPathPanState options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:GSMJRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:GSMJRefreshKeyPathContentSize];;
    [self.pan removeObserver:self forKeyPath:GSMJRefreshKeyPathPanState];
    self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled || self.hidden) return;
    
    if ([keyPath isEqualToString:GSMJRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:GSMJRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    } else if ([keyPath isEqualToString:GSMJRefreshKeyPathContentInset]) {
        [self scrollViewContentInsetDidChange:change];
    } else if ([keyPath isEqualToString:GSMJRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{}
- (void)scrollViewContentInsetDidChange:(NSDictionary *)change{}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{}

#pragma mark - 公共方法
#pragma mark 设置回调对象和回调方法
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    self.refreshingTarget = target;
    self.refreshingAction = action;
}

#pragma mark 进入刷新状态
- (void)beginRefreshing
{
    [UIView animateWithDuration:GSMJRefreshFastAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
    self.pullingPercent = 1.0;
    // 只要正在刷新，就完全显示
    if (self.window) {
        self.state = GSMJRefreshStateRefreshing;
    } else {
        self.state = GSMJRefreshStateWillRefresh;
        // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
        [self setNeedsDisplay];
    }
}

#pragma mark 结束刷新状态
- (void)endRefreshing
{
    self.state = GSMJRefreshStateIdle;
}

#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return self.state == GSMJRefreshStateRefreshing || self.state == GSMJRefreshStateWillRefresh;
}

#pragma mark 自动切换透明度
- (void)setAutoChangeAlpha:(BOOL)autoChangeAlpha
{
    _autoChangeAlpha = autoChangeAlpha;
    
    if (self.isRefreshing) return;
    
    if (autoChangeAlpha) {
         self.alpha = self.pullingPercent;
    } else {
        self.alpha = 1.0;
    }
}

#pragma mark 根据拖拽进度设置透明度
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    _pullingPercent = pullingPercent;
    
    if (self.isRefreshing) return;
    
    if (self.isAutoChangeAlpha) {
        self.alpha = pullingPercent;
    }
}

#pragma mark - 内部方法
- (void)executeRefreshingCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
            msgSend(msgTarget(self.refreshingTarget), self.refreshingAction, self);
        }
    });
}
@end

@implementation UILabel(GSMJRefresh)
+ (instancetype)label
{
    UILabel *label = [[self alloc] init];
    label.font = GSMJRefreshLabelFont;
    label.textColor = GSMJRefreshLabelTextColor;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}
@end