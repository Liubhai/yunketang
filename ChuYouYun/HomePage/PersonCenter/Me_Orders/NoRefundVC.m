//
//  NoRefundVC.m
//  dafengche
//
//  Created by 赛新科技 on 2017/2/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "NoRefundVC.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "MJRefresh.h"
#import "MBProgressHUD+Add.h"

#import "InstitutionListCell.h"
#import "OrderCell.h"
#import "InstitutionMainViewController.h"

#import "ZhiBoMainViewController.h"
#import "Good_ClassMainViewController.h"
#import "OfflineDetailViewController.h"
#import "RefundViewController.h"


@interface NoRefundVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong ,nonatomic)NSMutableArray *dataArray;

@property (strong ,nonatomic)NSString *pay_status;//标示符

@property (strong ,nonatomic)NSString *alipayStr;
@property (strong ,nonatomic)NSString *wxpayStr;
@property (strong ,nonatomic)NSString *classTypeStr;

@property (assign ,nonatomic)NSInteger number;
@property (strong ,nonatomic)UIImageView *imageView;
@property (strong ,nonatomic)NSString    *order_switch;
@property (strong ,nonatomic)UIView      *allWindowView;

@end

@implementation NoRefundVC

- (instancetype)initWithType:(NSString *)type {
    if (self=[super init]) {
        _isInst = type;
    }
    return self;
}
- (instancetype)initWithType:(NSString *)type WithSchoolID:(NSString *)schoolID; {
    if (self=[super init]) {
        _isInst = type;
        _schoolID = schoolID;
    }
    return self;
}

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
    [self netWorkOrderGetList:1];
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
    [self addTableView];
    if ([_isInst isEqualToString:@"inst"]) {
//        [self NetWorkGetOrderInfo];
        [self netWorkSchoolGetOrderList:1];
    } else if ([_isInst isEqualToString:@"order"]) {
//        [self NetWorkGetOrderWithNumber:1];
        [self netWorkOrderGetList:1];
    }
    [self netWorkConfigGetMarketStatus];
}
- (void)interFace {
    
//    self.view.backgroundColor = [UIColor redColor];
    _number = 1;
    _classTypeStr = @"4";
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassType:) name:@"My_Order_ClassType" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInstClassType:) name:@"My_Inst_Order_ClassType" object:nil];
}


#pragma mark --- UITableView

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 44 * WideEachUnit + 36) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 64 + 44 * WideEachUnit, MainScreenWidth, MainScreenHeight - 88 - 44 * WideEachUnit + 36);
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 190;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [_tableView addHeaderWithTarget:self action:@selector(headerRerefreshings)];
    [_tableView headerBeginRefreshing];
    [_tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}


#pragma mark --- 刷新

- (void)headerRerefreshings
{
    if ([_isInst isEqualToString:@"inst"]) {
//        [self NetWorkGetOrderInfo];
        [self netWorkSchoolGetOrderList:1];
    } else if ([_isInst isEqualToString:@"order"]) {
//        [self NetWorkGetOrderWithNumber:1];
        [self netWorkOrderGetList:1];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing
{
    _number ++;
    if ([_isInst isEqualToString:@"inst"]) {
//        [self NetWorkGetOrderInfo];
        [self netWorkSchoolGetOrderList:_number];
    } else if ([_isInst isEqualToString:@"order"]) {
//        [self NetWorkGetOrderWithNumber:_number];
        [self netWorkOrderGetList:_number];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}



#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = nil;
    CellID = [NSString stringWithFormat:@"cell%@ - %ld",_pay_status,indexPath.row];
    //自定义cell类
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithReuseIdentifier:CellID];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict WithType:_isInst];
    
    [cell.schoolButton addTarget:self action:@selector(schoolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.actionButton.hidden = NO;
    cell.cancelButton.hidden = NO;
    if ([[dict stringValueForKey:@"pay_status"] integerValue] == 4) {//退款申请中
        [cell.actionButton setTitle:@"取消申请" forState:UIControlStateNormal];
        cell.cancelButton.hidden = YES;
    } else if ([[dict stringValueForKey:@"pay_status"] integerValue] == 6) {//已驳回
        [cell.actionButton setTitle:@"重新申请" forState:UIControlStateNormal];
        [cell.cancelButton setTitle:@"查看原因" forState:UIControlStateNormal];
    }


    cell.schoolButton.tag = indexPath.row;
    cell.actionButton.tag = indexPath.row;
    cell.cancelButton.tag = indexPath.row;
    
    if ([_isInst isEqualToString:@"inst"]) {
        [cell.actionButton setTitle:@"查看详情" forState:UIControlStateNormal];
        cell.actionButton.hidden = YES;
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_dataArray[indexPath.row][@"order_type"] integerValue] == 4) {//点播
        NSString *ID = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row][@"video_id"]];
        NSString *price = _dataArray[indexPath.row][@"price"];
        NSString *title = _dataArray[indexPath.row][@"video_name"];
        NSString *videoUrl = _dataArray[indexPath.row][@"source_info"][@"video_address"];
        NSString *imageUrl = _dataArray[indexPath.row][@"cover"];
        
        Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
        vc.ID = ID;
        vc.price = price;
        vc.title = title;
        vc.videoUrl = videoUrl;
        vc.imageUrl = imageUrl;
        vc.orderSwitch = _order_switch;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_dataArray[indexPath.row][@"order_type"] integerValue] == 5) {
        OfflineDetailViewController *vc = [[OfflineDetailViewController alloc] init];
        vc.ID = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_id"];
        vc.imageUrl = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"cover"];
        vc.titleStr = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_name"];
        vc.orderSwitch = _order_switch;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_dataArray[indexPath.row][@"order_type"] integerValue] == 3){//直播
        NSString *Cid = nil;
        Cid = _dataArray[indexPath.row][@"live_id"];
        NSString *Price = _dataArray[indexPath.row][@"price"];
        NSString *Title = _dataArray[indexPath.row][@"video_name"];
        NSString *ImageUrl = _dataArray[indexPath.row][@"cover"];
        
        ZhiBoMainViewController *zhiBoMainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:Price];
        zhiBoMainVc.order_switch = _order_switch;
        [self.navigationController pushViewController:zhiBoMainVc animated:YES];
    }

    
}

#pragma mark --- 添加试图
- (void)isLookResone {
    
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds = YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    _allWindowView = allWindowView;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(30 * WideEachUnit,44 * WideEachUnit,MainScreenWidth - 60 * WideEachUnit,140 * WideEachUnit)];
    moreView.center = app.keyWindow.center;
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    moreView.layer.cornerRadius = 5 * WideEachUnit;
    [allWindowView addSubview:moreView];
    moreView.userInteractionEnabled = YES;
    _allWindowView.userInteractionEnabled = YES;
    
    //添加
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 0 * WideEachUnit, MainScreenWidth - 60 * WideEachUnit, 40 * WideEachUnit)];
    title.textColor = [UIColor colorWithHexString:@"#333"];
    title.font = Font(14 * WideEachUnit);
    title.text = @"退款驳回原因";
    title.backgroundColor = BasidColor;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [moreView addSubview:title];
    
   
    
    UIView *textBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 * WideEachUnit, MainScreenWidth - 60 * WideEachUnit, 70 * WideEachUnit)];
    textBackView.backgroundColor = [UIColor whiteColor];
    [moreView addSubview:textBackView];
    
    //添加textView
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 5 * WideEachUnit, MainScreenWidth - 80 * WideEachUnit, 60 * WideEachUnit)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.text = [_orderDict stringValueForKey:@"reject_info"];
    textView.textColor = [UIColor colorWithHexString:@"#888"];
    [textBackView addSubview:textView];
    
    //添加提交的按钮
    UIButton *subitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 120, 110 * WideEachUnit, 50, 20 * WideEachUnit)];
    [subitButton setTitle:@"确定" forState:UIControlStateNormal];
    subitButton.titleLabel.font = Font(15);
    [subitButton setTitleColor:BasidColor forState:UIControlStateNormal];
    [subitButton addTarget:self action:@selector(subitButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:subitButton];
}

#pragma mark --- 手势
- (void)allWindowViewClick:(UIGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

#pragma mark --- 通知
- (void)getClassType:(NSNotification *)not {
    _classTypeStr = (NSString *)not.object;
    if ([_classTypeStr integerValue] == 0) {//点播
        _classTypeStr = @"4";
    } else if ([_classTypeStr integerValue] == 1) {//直播
        _classTypeStr = @"3";
    } else if ([_classTypeStr integerValue] == 2) {//线下课
        _classTypeStr = @"5";
    }
    [self netWorkOrderGetList:1];
}

- (void)getInstClassType:(NSNotification *)not {
    _classTypeStr = (NSString *)not.object;
    if ([_classTypeStr integerValue] == 0) {//点播
        _classTypeStr = @"4";
    } else if ([_classTypeStr integerValue] == 1) {//直播
        _classTypeStr = @"3";
    } else if ([_classTypeStr integerValue] == 2) {//线下课
        _classTypeStr = @"5";
    }
    [self netWorkSchoolGetOrderList:1];
}

#pragma mark --- 事件

- (void)schoolButtonClick:(UIButton *)button {
    InstitutionMainViewController *mainVc = [[InstitutionMainViewController alloc] init];
    mainVc.schoolID = _dataArray[button.tag][@"source_info"][@"school_info"][@"school_id"];
    [self.navigationController pushViewController:mainVc animated:YES];
}

- (void)actionButtonClick:(UIButton *)button {
    NSInteger index = button.tag;
    _orderDict = _dataArray[index];
    
    NSLog(@"%@",_orderDict);
    NSString *title = button.titleLabel.text;
    
    if ([title isEqualToString:@"去支付"]) {
        
    } else if ([title isEqualToString:@"申请退款"]) {
        [self isSureRefund];
    } else if ([title isEqualToString:@"查看详情"]) {
        
        if ([_isInst isEqualToString:@"inst"]) {
            
        } else if ([_isInst isEqualToString:@"order"])  {
        }
        
    } else if ([title isEqualToString:@"驳回原因"]) {
        
    } else if ([title isEqualToString:@"取消申请"]) {//申请中取消
        [self netWorkOrderCancelRefund];
        return;
    } else if ([title isEqualToString:@"重新申请"]) {//重新申请
        if ([[[_dataArray objectAtIndex:index] stringValueForKey:@"order_type"] integerValue] == 5) {//线
            [self gotoRefundVc];
        } else {
            [self gotoRefundVc];
        }
    }
}

- (void)cancelButtonClick:(UIButton *)button {
    NSInteger index = button.tag;
    _orderDict = _dataArray[index];
    if ([button.titleLabel.text isEqualToString:@"查看原因"]) {
        [self isLookResone];
        return;
    }
    [self isSureDele];
}

- (void)subitButtonCilck:(UIButton *)button {
    [_allWindowView removeFromSuperview];
}

//是否 真要删除小组
- (void)isSureDele {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否确定要取消该订单" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//是否 真要删除小组
- (void)isSureRefund {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否要要申请退款" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        [self NetWorkRefund];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark --- 跳转
- (void)gotoRefundVc {
    RefundViewController *refundVc = [[RefundViewController alloc] init];
    refundVc.orderDict = _orderDict;
    if ([[_orderDict stringValueForKey:@"order_type"] integerValue] == 5) {//线下课
        refundVc.downLineClass = @"lineClass";
    }
    [self.navigationController pushViewController:refundVc animated:YES];
}

#pragma mark --- 网络请求

//获取全部的订单
- (void)netWorkOrderGetList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_Order_order_getCourseOrderList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setValue:@"10" forKey:@"count"];
    [mutabDict setValue:_classTypeStr forKey:@"order_type"];
    [mutabDict setValue:@"4" forKey:@"pay_status"];
    
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
        if ([[dict stringValueForKey:@"code"] integerValue ] == 1) {
            if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
                if (Num == 1) {
                    _dataArray = (NSMutableArray *)[dict arrayValueForKey:@"data"];
                } else {
                    [_dataArray addObjectsFromArray:(NSMutableArray *)[dict arrayValueForKey:@"data"]];
                }
            } else {
                if (Num == 1) {
                    _dataArray = (NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                } else {
                    [_dataArray addObjectsFromArray:(NSMutableArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
                }
            }
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

//机构订单
- (void)netWorkSchoolGetOrderList:(NSInteger)Number {
    
    NSString *endUrlStr = YunKeTang_Order_order_getCourseOrderList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",Number] forKey:@"page"];
    [mutabDict setValue:@"20" forKey:@"count"];
    [mutabDict setValue:_classTypeStr forKey:@"order_type"];
    [mutabDict setValue:@"4" forKey:@"pay_status"];
    [mutabDict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"schoolID"] forKey:@"school_id"];
    
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
            if (Number == 1) {
                dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                if ([dict isKindOfClass:[NSArray class]]) {
                    _dataArray = (NSMutableArray *)dict;
                } else {
                    _dataArray = (NSMutableArray *)[dict arrayValueForKey:@"list"];
                }
            } else {
                dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
                if ([dict isKindOfClass:[NSArray class]]) {
                    [_dataArray addObjectsFromArray:(NSArray *)dict];
                } else {
                    if ([dict arrayValueForKey:@"list"].count == 0) {
                    } else {
                        [_dataArray addObjectsFromArray:[dict arrayValueForKey:@"list"]];
                    }
                }
            }
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                self.imageView.hidden = YES;
            }
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//取消订单
- (void)netWorkOrderCancel {
    
    NSString *endUrlStr = YunKeTang_Order_order_cancel;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_orderDict[@"order_id"] forKey:@"order_id"];
    [mutabDict setValue:_orderDict[@"order_type"] forKey:@"order_type"];
    
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
        NSDictionary *cancelDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        
        if ([[cancelDict stringValueForKey:@"staust"] integerValue] == 1) {
            [MBProgressHUD showSuccess:@"取消成功" toView:self.view];
            [self netWorkOrderGetList:_number];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}





//取消申请退款
- (void)netWorkOrderCancelRefund {
    
    NSString *endUrlStr = YunKeTang_Order_order_cancelRefund;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_orderDict stringValueForKey:@"order_type"] forKey:@"order_type"];
    [mutabDict setObject:[_orderDict stringValueForKey:@"id"] forKey:@"order_id"];
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
            [MBProgressHUD showSuccess:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            [self netWorkSchoolGetOrderList:1];
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
