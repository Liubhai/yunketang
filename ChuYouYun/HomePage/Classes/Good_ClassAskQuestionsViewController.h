//
//  Good_ClassAskQuestionsViewController.h
//  YunKeTang
//
//  Created by IOS on 2019/3/19.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_ClassAskQuestionsViewController : UIViewController

@property (strong ,nonatomic)void (^vcHight)(CGFloat hight);
-(instancetype)initWithNumID:(NSString *)ID;

@end
