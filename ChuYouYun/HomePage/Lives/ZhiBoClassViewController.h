//
//  ZhiBoClassViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/5/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhiBoClassViewController : UIViewController

@property (strong ,nonatomic)void (^vcHight)(CGFloat hight);
-(instancetype)initWithNumID:(NSString *)ID;



@end
