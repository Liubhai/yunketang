//  代码地址: https://github.com/CoderGSMJLee/GSMJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>

const CGFloat GSMJRefreshHeaderHeight = 54.0;
const CGFloat GSMJRefreshFooterHeight = 44.0;
const CGFloat GSMJRefreshFastAnimationDuration = 0.25;
const CGFloat GSMJRefreshSlowAnimationDuration = 0.4;

NSString *const GSMJRefreshKeyPathContentOffset = @"contentOffset";
NSString *const GSMJRefreshKeyPathContentInset = @"contentInset";
NSString *const GSMJRefreshKeyPathContentSize = @"contentSize";
NSString *const GSMJRefreshKeyPathPanState = @"state";

NSString *const GSMJRefreshHeaderLastUpdatedTimeKey = @"GSMJRefreshHeaderLastUpdatedTimeKey";

NSString *const GSMJRefreshHeaderIdleText = @"下拉可以刷新";
NSString *const GSMJRefreshHeaderPullingText = @"松开立即刷新";
NSString *const GSMJRefreshHeaderRefreshingText = @"正在刷新数据中...";

NSString *const GSMJRefreshAutoFooterIdleText = @"点击或上拉加载更多";
NSString *const GSMJRefreshAutoFooterRefreshingText = @"正在加载更多的数据...";
NSString *const GSMJRefreshAutoFooterNoMoreDataText = @"已经全部加载完毕";

NSString *const GSMJRefreshBackFooterIdleText = @"上拉可以加载更多";
NSString *const GSMJRefreshBackFooterPullingText = @"松开立即加载更多";
NSString *const GSMJRefreshBackFooterRefreshingText = @"正在加载更多的数据...";
NSString *const GSMJRefreshBackFooterNoMoreDataText = @"已经全部加载完毕";