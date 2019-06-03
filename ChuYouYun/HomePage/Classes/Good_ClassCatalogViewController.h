//
//  Good_ClassCatalogViewController.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Good_ClassCatalogViewController : UIViewController

@property (strong ,nonatomic)void (^vcHight)(CGFloat hight);
@property (strong ,nonatomic)void (^didSele)(NSString *seleStr);
@property (strong ,nonatomic)void (^videoDataSource)(NSDictionary *videoDataSource);
-(instancetype)initWithNumID:(NSString *)ID;

@end
