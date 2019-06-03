//
//  Good_ClassMainViewController.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCVideoConfig;

@interface Good_ClassMainViewController : UIViewController

@property (strong ,nonatomic)NSString         *ID;
@property (strong ,nonatomic)NSString         *videoTitle;
@property (strong ,nonatomic)NSString         *imageUrl;
@property (strong ,nonatomic)NSString         *price;
@property (strong ,nonatomic)NSString         *videoUrl;
@property (strong ,nonatomic)NSString         *schoolID;

//营销数据的标识
@property (strong ,nonatomic)NSString         *orderSwitch;


@property (nonatomic, strong) AVCVideoConfig *config;

@end
