//
//  GSMJRefreshBackStateFooter.m
//  GSMJRefreshExample
//
//  Created by GSMJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "GSMJRefreshBackStateFooter.h"

@interface GSMJRefreshBackStateFooter()
{
    /** 显示刷新状态的label */
    __weak UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation GSMJRefreshBackStateFooter
#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel label]];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(GSMJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化文字
    [self setTitle:GSMJRefreshBackFooterIdleText forState:GSMJRefreshStateIdle];
    [self setTitle:GSMJRefreshBackFooterPullingText forState:GSMJRefreshStatePulling];
    [self setTitle:GSMJRefreshBackFooterRefreshingText forState:GSMJRefreshStateRefreshing];
    [self setTitle:GSMJRefreshBackFooterNoMoreDataText forState:GSMJRefreshStateNoMoreData];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(GSMJRefreshState)state
{
    GSMJRefreshCheckState
    
    // 设置状态文字
    self.stateLabel.text = self.stateTitles[@(state)];
}
@end
