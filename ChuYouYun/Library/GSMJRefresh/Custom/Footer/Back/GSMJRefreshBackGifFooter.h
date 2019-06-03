//
//  GSMJRefreshBackGifFooter.h
//  GSMJRefreshExample
//
//  Created by GSMJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "GSMJRefreshBackStateFooter.h"

@interface GSMJRefreshBackGifFooter : GSMJRefreshBackStateFooter
/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(GSMJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(GSMJRefreshState)state;
@end
