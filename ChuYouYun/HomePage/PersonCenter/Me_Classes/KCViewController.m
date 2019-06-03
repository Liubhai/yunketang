//
//  KCViewController.m
//  ChuYouYun
//
//  Created by 智艺创想 on 15/12/30.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width

#import "KCViewController.h"
#import "MyViewController.h"
#import "UIButton+WebCache.h"
#import "settingViewController.h"
#import "MyMsgViewController.h"
#import "receiveCommandViewController.h"
#import "ZhiyiHTTPRequest.h"
#import "Passport.h"
#import "CData.h"
#import "MJRefresh.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WebP.h"
#import "teacherList.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "BuyClass.h"
#import "SYG.h"
#import "UIColor+HTMLColors.h"
#import "MBProgressHUD+Add.h"
#import "ClassRevampCell.h"
#import "Good_ClassMainViewController.h"


@interface KCViewController ()<UITableViewDataSource,UITableViewDelegate>


{
    NSInteger _number;
    CGRect rect;
}

@property (strong ,nonatomic)UIImageView    *imageView;
@property (strong ,nonatomic)NSMutableArray *dataArray;

//营销数据
@property (strong ,nonatomic)NSString *order_switch;

@end

@implementation KCViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
        _imageView.image = Image(@"云课堂_空数据");
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initer];
    [self titleSet];
    [self addNav];
    [self netWorkConfigGetMarketStatus];
}

- (void)initer {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的课程";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 98, MainScreenWidth, MainScreenHeight - 98 + 36) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        self.tableView.frame = CGRectMake(0, 98, MainScreenWidth, MainScreenHeight - 88 - 34 + 36);
    }
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:237.0/255.0 alpha:1];
    self.tableView.userInteractionEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100 * WideEachUnit;
    self.dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self.view addSubview:self.tableView];
    //下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRerefreshing)];
    [self.tableView headerBeginRefreshing];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = @"我的课程";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)titleSet {
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:44.f / 255 green:132.f / 255 blue:214.f / 255 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
}

- (void)headerRerefreshing
{
    [self netWorkUserVideoGetMyList:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
    _number++;
    [self netWorkUserVideoGetMyList:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}

#pragma mark ---

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.05;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dataArray isEqual:[NSNull null]]) {
        return 0;
    }else {
        return _dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellStr = @"SYGClassTableViewCell";
    ClassRevampCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[ClassRevampCell alloc] initWithReuseIdentifier:cellStr];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
//    [cell dataWithDict:dict withType:@"1"];
    [cell dataWithDict:dict withType:@"1" withOrderSwitch:_order_switch];
    cell.kinsOf.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"time_limit"]];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *ID = _dataArray[indexPath.row][@"id"];
    NSString *price = _dataArray[indexPath.row][@"price"];
    NSString *title = _dataArray[indexPath.row][@"video_title"];
    NSString *videoUrl = _dataArray[indexPath.row][@"video_address"];
    NSString *imageUrl = _dataArray[indexPath.row][@"imageurl"];
    
    Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
    vc.ID = ID;
    vc.price = price;
    vc.title = title;
    vc.videoUrl = videoUrl;
    vc.imageUrl = imageUrl;
    vc.orderSwitch = _order_switch;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 网络请求
- (void)netWorkUserVideoGetMyList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_User_video_getMyList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[NSString stringWithFormat:@"%ld",(long)Num] forKey:@"page"];
    [mutabDict setObject:@"10" forKey:@"count"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                if (Num == 1) {
                    _dataArray = (NSMutableArray *) [dict arrayValueForKey:@"data"];
                } else {
                    [_dataArray addObjectsFromArray:(NSMutableArray *) [dict arrayValueForKey:@"data"]];
                }
            } else {
                if (Num == 1) {
                    _dataArray = (NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                } else {
                    [_dataArray addObjectsFromArray:(NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
                }
            }
        }
        if (_dataArray.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//获取营销数据
- (void)netWorkConfigGetMarketStatus {
    
    NSString *endUrlStr = YunKeTang_config_getMarketStatus;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //获取当前的时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _order_switch = [dict stringValueForKey:@"order_switch"];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}





@end
