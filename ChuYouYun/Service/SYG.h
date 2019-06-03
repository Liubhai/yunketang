//
//  SYG.h
//  ChuYouYun
//
//  Created by 智艺创想 on 16/4/5.
//  Copyright (c) 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>
#import "UIColor+HTMLColors.h"
#import "UIView+Utils.h"
#import "NSDictionary+Json.h"
#import "Passport.h"
#import "MBProgressHUD+Add.h"
#import "SYGTextField.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "Passport.h"
//#import "AppDelegate.h"
//#import "rootViewController.h"
#import "YunKeTang_Api_Tool.h"
#import "Api_Config.h"


//配置单机构或者多机构 (1,单机构、2,多机构)
#define MoreOrSingle @"2"

#ifndef ChuYouYun_SYG_h
#define ChuYouYun_SYG_h

#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define SpaceBaside 10

//# define ORIGIN_HEIGHT  568.f
//# define ORIGIN_WIDTH   320.f

#define WideEachUnit MainScreenWidth / 375
#define HigtEachUnit  MainScreenHeight / 667

//#define WideEachUnit MainScreenWidth / 320.f
//#define HigtEachUnit MainScreenHeight / 568.f
#define NavigationBarHeight MainScreenHeight == 812 ? 88 : 64
#define NavigationBarSubViewHeight  MainScreenHeight == 812 ? 40 : 25
#define TabBarHeight MainScreenHeight == 812 ? 83 : 49


//阿里播放相关
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

//内购
#define IAPPurchID @"com.bb.helper_eduline"
#define IAPPurchID_20 @"com.bb.helper_eduline_20"
#define IAPPurchID_50 @"com.bb.helper_eduline_50"
#define IAPPurchID_100 @"com.bb.helper_eduline_100"
#define IAPPurchID_200 @"com.bb.helper_eduline_200"
#define IAPPurchID_500 @"com.bb.helper_eduline_500"



#define NetKey [[NSUserDefaults standardUserDefaults] objectForKey:@"App_Key"] == nil ? @"2506957b1ea89b71" : [[NSUserDefaults standardUserDefaults] objectForKey:@"App_Key"]
#define HeaderKey @"En-Params"



#define currentIOS [[[UIDevice currentDevice] systemVersion] floatValue]

#define iPhone4SOriPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)//iphone4 4s屏幕

#define iPhone5o5Co5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)//iphone5/5c/5s屏幕

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6屏幕

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus屏幕

#define iPhone6PlusBIG ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)//iphone6plus放大版屏幕

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)//iphoneX屏幕


//本地保存
#define UserOathToken [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"]
#define UserOathTokenSecret [[NSUserDefaults standardUserDefaults] objectForKey:@"oauthTokenSecret"]
#define UserID [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"]
#define APPID [[NSUserDefaults standardUserDefaults] objectForKey:@"appID"]
#define AppName [[NSUserDefaults standardUserDefaults] objectForKey:@"appName"]
#define Only_Login_Key [[NSUserDefaults standardUserDefaults] objectForKey:@"only_login_key"]


#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//#define EncryptUrl @"https://t.v4.51eduline.com/service/"
//#define EncryptHeaderUrl @"https://t.v4.51eduline.com"

#define EncryptUrl [MoreOrSingle integerValue] == 1 ? @"https://single.51eduline.com/service/" : @"https://t.v4.51eduline.com/service/"
#define EncryptHeaderUrl [MoreOrSingle integerValue] == 1 ? @"https://single.51eduline.com" : @"https://t.v4.51eduline.com"

#define basidUrl [MoreOrSingle integerValue] == 1 ? @"https://single.51eduline.com/service" : @"https://t.v4.51eduline.com/service"




#define Image(name) [UIImage imageNamed:name]
#define BasidColor [UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1]
#define PartitionColor [UIColor colorWithRed:225.f / 255 green:225.f / 255 blue:225.f / 255 alpha:1]
#define BackColor [UIColor colorWithRed:240.f / 255 green:240.f / 255 blue:240.f / 255 alpha:1]
#define XXColor [UIColor colorWithRed:153.f / 255 green:153.f / 255 blue:153.f / 255 alpha:1]
#define JHColor [UIColor colorWithRed:255.f / 255 green:127.f / 255 blue:0.f / 255 alpha:1]

//几个类型相同的时候 选中与未选中的颜色
#define sameColor [UIColor colorWithRed:89.f / 255 green:89.f / 255 blue:89.f / 255 alpha:1]

//考试系统正确答案
#define FalseColor [UIColor colorWithRed:246.f / 255 green:62.f / 255 blue:51.f / 255 alpha:1]

//考试系统错误答案
#define TrueColor [UIColor colorWithRed:96.f / 255 green:181.f / 255 blue:23.f / 255 alpha:1]

//一般分类里面的字的颜色(不是纯黑的颜色)
#define BlackNotColor [UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1]


#define Font(number) [UIFont systemFontOfSize:number]
#define Color(color) [UIColor color]

//#define basidUrl @"https://t.v4.51eduline.com/service"

//下载保存视频的Key
#define YunKeTang_EdulineOssCnShangHai @"eduline.oss-cn-shanghai"
#define YunKeTang_VideoDataSource @"YunKeTang_VideoDataSource"
#define YunKeTang_CurrentDownCount @"YunKeTang_CurrentDownCount"
#define YunKeTang_CurrentDownList @"YunKeTang_CurrentDownList"
#define YunKeTang_CurrentDownTitleList @"YunKeTang_CurrentDownTitleList"
#define YunKeTang_CurrentDownExit @"YunKeTang_CurrentDownExit"

#endif
