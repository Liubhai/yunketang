//
//  InstCouponViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/3/10.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "InstCouponViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MJRefresh.h"
#import "DLViewController.h"

#import "Good_CardStockTableViewCell.h"


@interface InstCouponViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)NSString        *schoolID;
@property (strong ,nonatomic)UITableView     *tableView;
@property (strong ,nonatomic)UIImageView     *imageView;
@property (strong ,nonatomic)NSMutableArray  *dataArray;
@property (assign ,nonatomic)NSInteger        number;

@end

@implementation InstCouponViewController

- (instancetype)initWithSchoolID:(NSString *)schoolID {
    if (self = [super init]) {
        _schoolID = schoolID;
    }
    return self;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight - 64 - 48)];
        _imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
        [_tableView addSubview:_imageView];
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
    
    [self interFace];
    [self addNav];
    [self addTableView];
    [self netWorkSchoolGetGetCouponList:1];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _number = 0;
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"通用返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25, MainScreenWidth - 100, 30)];
    WZLabel.text = @"机构主页";
    [WZLabel setTextColor:BasidColor];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark --- UITableView

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 98, MainScreenWidth, MainScreenHeight - 98 + 36) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView headerBeginRefreshing];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }

}


#pragma mark --- 刷新

- (void)headerRerefreshings
{
    [self netWorkSchoolGetGetCouponList:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRefreshing
{
        _number ++;
    [self netWorkSchoolGetGetCouponList:_number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}




#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170 * WideEachUnit;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    Good_CardStockTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //自定义cell类
    if (cell == nil) {
        cell = [[Good_CardStockTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict WithType:@"1"];
    cell.use.text = @"立\n即\n领\n取";
    cell.use.frame = CGRectMake(MainScreenWidth - 70 * WideEachUnit, 0, 65 * WideEachUnit, 150 * WideEachUnit);
    cell.segmentationImageView.frame = CGRectMake(MainScreenWidth - 65 * WideEachUnit, 0, 10 * WideEachUnit, 150 * WideEachUnit);
    cell.lineButton.frame = CGRectMake(0, 150 * WideEachUnit,MainScreenWidth , 20 * WideEachUnit);
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[Passport formatterDate:[dict stringValueForKey:@"ctime"]],[Passport formatterDate:[dict stringValueForKey:@"end_time"]]];
    [cell.useLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellUserLabelClick:)]];
    cell.useLabel.tag = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = _dataArray[indexPath.row];
    NSString *code = [dict stringValueForKey:@"coupon_code"];
    [self netWorkCouponGrant:code];
}

#pragma mark --- 事件监听

- (void)UseBtnCilck:(UIButton *)button {
    
    NSLog(@"123");
    NSString *code = [NSString stringWithFormat:@"%@",_dataArray[button.tag][@"code"]];
    
//    [self netWorkInstGrantCoupon:code];
    [self netWorkCouponGrant:code];
    
}

#pragma mark --- 手势
- (void)cellUserLabelClick:(UIGestureRecognizer *)ges {
    
}


#pragma mark --- 网络请求
//获取机构优惠券
- (void)netWorkSchoolGetGetCouponList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_School_school_getCouponList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"1" forKey:@"page"];
    [mutabDict setObject:@"20" forKey:@"count"];
    [mutabDict setObject:_schoolID forKey:@"school_id"];
    [mutabDict setObject:@"2" forKey:@"type"];
    
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
                    _dataArray = [NSMutableArray arrayWithArray:(NSArray *)[dict arrayValueForKey:@"data"]];
                } else {
                    [_dataArray addObjectsFromArray:(NSArray *)[dict arrayValueForKey:@"data"]];
                }
            } else {
                if (Num == 1) {
                    _dataArray = [NSMutableArray arrayWithArray:(NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
                } else {
                    [_dataArray addObjectsFromArray:(NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
                }
            }
        } else {
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        if (_dataArray.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



//领取优惠券
- (void)netWorkCouponGrant:(NSString *)code {
    
    NSString *endUrlStr = YunKeTang_Coupon_coupon_grant;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:code forKey:@"code"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    } else {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
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
            [MBProgressHUD showSuccess:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            [self netWorkSchoolGetGetCouponList:1];
        } else {
            if (dict == nil) {
                 [MBProgressHUD showSuccess:@"领取成功" toView:[UIApplication sharedApplication].keyWindow];
                [self netWorkSchoolGetGetCouponList:1];
            } else {
                [MBProgressHUD showSuccess:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



@end
