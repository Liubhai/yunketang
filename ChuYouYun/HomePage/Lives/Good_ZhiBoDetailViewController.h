//
//  Good_ZhiBoDetailViewController.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/8/9.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_ZhiBoDetailViewController : UIViewController

@property (strong ,nonatomic)void (^detailScroll)(CGFloat hight);
-(instancetype)initWithNumID:(NSString *)ID;
-(instancetype)initWithNumID:(NSString *)ID WithOrderSwitch:(NSString *)orderSwitch; 

@end
