//
//  InstationClassViewController.h
//  dafengche
//
//  Created by 智艺创想 on 16/11/4.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstationClassViewController : UIViewController

@property (strong ,nonatomic)NSString *schoolID;
@property (strong ,nonatomic)void (^scollHight)(CGFloat hight);

@end
