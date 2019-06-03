//
//  Good_MemberCardViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/2.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_MemberCardViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "Good_CardStockTableViewCell.h"
#import "InstitutionMainViewController.h"

@interface Good_MemberCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSArray     *dataArray;

@end

@implementation Good_MemberCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addTableView];
    [self netWorkCouponGetMyCouponList];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 64 + 45 * WideEachUnit, MainScreenWidth - 30 * WideEachUnit, MainScreenHeight - 64 - 45 * WideEachUnit) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 88 + 34, MainScreenWidth, MainScreenHeight - 88 - 34 + 36);
    }
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.rowHeight = 170 * WideEachUnit;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- UITableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10 * WideEachUnit;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return 5;
    return _dataArray.count;
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
    [cell dataSourceWith:dict WithType:@"2"];
    
//    cell.useLabel.hidden = YES;
//    cell.insetLabel.hidden = YES;
    
    [cell.useLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellUserLabelClick:)]];
    cell.useLabel.tag = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *cellDict = _dataArray[indexPath.row];
    [self netWorkCouponUse:cellDict];
//    InstitutionMainViewController *instVc = [[InstitutionMainViewController alloc] init];
//    instVc.schoolID =  [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"sid"]];
//    instVc.uID = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"uid"]];
//    [self.navigationController pushViewController:instVc animated:YES];
}

#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

//手势
- (void)cellUserLabelClick:(UIGestureRecognizer *)tap {
    
    NSInteger tapTag = tap.view.tag;
    InstitutionMainViewController *instVc = [[InstitutionMainViewController alloc] init];
    instVc.schoolID =  [NSString stringWithFormat:@"%@",_dataArray[tapTag][@"sid"]];
    instVc.uID = [NSString stringWithFormat:@"%@",_dataArray[tapTag][@"uid"]];
    [self.navigationController pushViewController:instVc animated:YES];
}


#pragma mark ----网络请求

//获取打折卡
- (void)NetWorkGetMyCouponList {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    
    [dic setObject:@"100" forKey:@"count"];
    [dic setObject:@"3" forKey:@"type"];
    [dic setObject:@"1" forKey:@"page"];
    
    [manager BigWinCar_GetPublicWay:dic mod:@"Coupon" act:@"getMyCouponList" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([responseObject[@"code"] integerValue] == 1) {
            _dataArray = [responseObject arrayValueForKey:@"data"];
        }
        if (_dataArray.count == 0) {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-15 * WideEachUnit, 0, MainScreenWidth, MainScreenHeight - 64)];
            imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
            [_tableView addSubview:imageView];
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取打折卡
- (void)netWorkCouponGetMyCouponList {
    
    NSString *endUrlStr = YunKeTang_Coupon_coupon_getMyCouponList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"100" forKey:@"count"];
    [mutabDict setObject:@"3" forKey:@"type"];
    [mutabDict setObject:@"1" forKey:@"page"];
    [mutabDict setObject:@"0" forKey:@"status"];
    
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
                _dataArray = [dict arrayValueForKey:@"data"];
            } else {
                _dataArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        } else {
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        if (_dataArray.count == 0) {
            //添加空白处理
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-15 * WideEachUnit, 0, MainScreenWidth, MainScreenHeight - 64)];
            imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
            [_tableView addSubview:imageView];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


- (void)netWorkCouponUse:(NSDictionary *)cellDict {
    
    NSString *endUrlStr = YunKeTang_Coupon_coupon_useVipCard;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    //    [mutabDict setObject:@"100" forKey:@"count"];
    [mutabDict setValue:[cellDict stringValueForKey:@"coupon_id"] forKey:@"coupon_id"];
    
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
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            [self netWorkCouponGetMyCouponList];
        } else {
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



@end
