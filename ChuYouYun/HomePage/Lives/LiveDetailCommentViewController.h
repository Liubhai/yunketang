//
//  LiveDetailCommentViewController.h
//  dafengche
//
//  Created by 赛新科技 on 2017/3/29.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveDetailCommentViewController : UIViewController

@property (strong ,nonatomic)void (^getCommentHight)(CGFloat commentHight);
- (instancetype)initWithNumID:(NSString *)ID;

@end
