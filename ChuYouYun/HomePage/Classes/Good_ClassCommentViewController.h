//
//  Good_ClassCommentViewController.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_ClassCommentViewController : UIViewController

@property (strong ,nonatomic)void(^vcHight)(CGFloat hight);
-(instancetype)initWithNumID:(NSString *)ID;

@end
