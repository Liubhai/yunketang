//
//  ZhiBoMainViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/5/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhiBoMainViewController : UIViewController

- (id)initWithMemberId:(NSString *)MemberId andImage:(NSString *)imgUrl andTitle:(NSString *)title andNum:(int)num andprice:(NSString *)price;

//机构获取返利
@property (strong ,nonatomic)NSString   *schoolID;
//获取营销数据是否开启
@property (strong ,nonatomic)NSString   *order_switch;

@end
