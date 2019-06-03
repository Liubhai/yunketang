//  代码地址: https://github.com/CoderGSMJLee/GSMJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>
#import <objc/message.h>

// 日志输出
#ifdef DEBUG
#define GSMJLog(...) NSLog(__VA_ARGS__)
#else
#define GSMJLog(...)
#endif

#define iOS(version) ([[UIDevice currentDevice].systemVersion doubleValue] >= version)

// 过期提醒
#define GSMJDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define msgTarget(target) (__bridge void *)(target)

// RGB颜色
#define GSMJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define GSMJRefreshLabelTextColor GSMJColor(90, 90, 90)

// 字体大小
#define GSMJRefreshLabelFont [UIFont boldSystemFontOfSize:14]

// 图片路径
#define GSMJRefreshSrcName(file) [@"GSMJRefresh.bundle" stringByAppendingPathComponent:file]

// 常量
UIKIT_EXTERN const CGFloat GSMJRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat GSMJRefreshFooterHeight;
UIKIT_EXTERN const CGFloat GSMJRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat GSMJRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const GSMJRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const GSMJRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const GSMJRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const GSMJRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const GSMJRefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const GSMJRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const GSMJRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const GSMJRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const GSMJRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const GSMJRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const GSMJRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const GSMJRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const GSMJRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const GSMJRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const GSMJRefreshBackFooterNoMoreDataText;

// 状态检查
#define GSMJRefreshCheckState \
GSMJRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
