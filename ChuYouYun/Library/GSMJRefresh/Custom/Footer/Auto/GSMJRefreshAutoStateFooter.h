//
//  GSMJRefreshAutoStateFooter.h
//  GSMJRefreshExample
//
//  Created by GSMJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "GSMJRefreshAutoFooter.h"

@interface GSMJRefreshAutoStateFooter : GSMJRefreshAutoFooter
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;

/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(GSMJRefreshState)state;

/** 隐藏刷新状态的文字 */
@property (assign, nonatomic, getter=isRefreshingTitleHidden) BOOL refreshingTitleHidden;
@end
