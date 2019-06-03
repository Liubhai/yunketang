//  代码地址: https://github.com/CoderGSMJLee/GSMJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIScrollView+GSMJRefresh.m
//  GSMJRefreshExample
//
//  Created by GSMJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "UIScrollView+GSMJRefresh.h"
#import "GSMJRefreshHeader.h"
#import "GSMJRefreshFooter.h"
#import <objc/runtime.h>

@implementation UIScrollView (GSMJRefresh)

#pragma mark - header
static const char GSMJRefreshHeaderKey = '\0';
- (void)setHeader:(GSMJRefreshHeader *)header
{
    if (header != self.header) {
        // 删除旧的，添加新的
        [self.header removeFromSuperview];
        [self addSubview:header];
        
        // 存储新的
        [self willChangeValueForKey:@"header"]; // KVO
        objc_setAssociatedObject(self, &GSMJRefreshHeaderKey,
                                 header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"header"]; // KVO
    }
}

- (GSMJRefreshHeader *)header
{
    return objc_getAssociatedObject(self, &GSMJRefreshHeaderKey);
}

#pragma mark - footer
static const char GSMJRefreshFooterKey = '\0';
- (void)setFooter:(GSMJRefreshFooter *)footer
{
    if (footer != self.footer) {
        // 删除旧的，添加新的
        [self.footer removeFromSuperview];
        [self addSubview:footer];
        
        // 存储新的
        [self willChangeValueForKey:@"footer"]; // KVO
        objc_setAssociatedObject(self, &GSMJRefreshFooterKey,
                                 footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"footer"]; // KVO
    }
}

- (GSMJRefreshFooter *)footer
{
    return objc_getAssociatedObject(self, &GSMJRefreshFooterKey);
}
@end
