//
//  receiveCommandViewController.h
//  ChuYouYun
//
//  Created by ZhiYiForMac on 15/1/31.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface receiveCommandViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong ,nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *muArr;
@property (strong ,nonatomic)NSArray        *dataArr;

@property (strong ,nonatomic)NSArray       *allArray;

@end
