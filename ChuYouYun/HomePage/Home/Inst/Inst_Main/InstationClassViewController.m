//
//  InstationClassViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/4.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstationClassViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIButton+WebCache.h"

#import "InstationClassVideoCell.h"
#import "InstationClassCell.h"

#import "ZhiBoMainViewController.h"
#import "ClassRevampCell.h"
#import "Good_ClassMainViewController.h"



@interface InstationClassViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIView      *footView;

@property (strong ,nonatomic)NSArray *headerTitleArray;
@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSArray *classArray;

//营销数据
@property (strong ,nonatomic)NSString *order_switch;

@end

@implementation InstationClassViewController

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
//    [self addNav];
//    [self addFootView];
    [self addTableView];
    [self netWorkConfigGetMarketStatus];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //接受通知（将机构的id传过来）
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetInstitonSchoolID:) name:@"NotificationInstitionSchoolID" object:nil];
}

#pragma mark --- 通知

- (void)GetInstitonSchoolID:(NSNotification *)Not {
    _schoolID = (NSString *)Not.userInfo[@"school_id"];
//    [self netWorkSchoolGetInfo];
    [self netWorkSchoolGetVideoList];
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"点评返回@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"机构";
    [WZLabel setTextColor:[UIColor blackColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
    
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight * 10) style:UITableViewStyleGrouped];
    _tableView.rowHeight = 100 * WideEachUnit;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = _footView;
    [self.view addSubview:_tableView];
    
//    [_tableView addFooterWithTarget:self action:@selector(footMore)];
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

- (void)footMore {
//    [self netWorkSchoolGetVideoList];
    [_tableView footerBeginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView footerEndRefreshing];
    });
}

#pragma mark --- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _classArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = @"cell1";
    //自定义cell类
    ClassRevampCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[ClassRevampCell alloc] initWithReuseIdentifier:CellID];
    }
    NSDictionary *dict = _classArray[indexPath.row];
    NSString *type = dict[@"type"];
    [cell dataWithDict:dict withType:type];
    
    NSString *timeStr = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];
    NSString *studyStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_order_count"]];
    if ([_order_switch integerValue] == 1) {
        studyStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_order_count_mark"]];
    }
    NSString *sectionStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"section_count"]];
    NSString *priceStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"t_price"]];
    
    if ([type integerValue] == 1) {
        cell.studyNum.text =  [NSString stringWithFormat:@"%@人在学 · 共%@节",studyStr,sectionStr];
    } else if ([type integerValue] == 2) {
        cell.studyNum.text = [NSString stringWithFormat:@"%@人在学 · %@开课",studyStr,timeStr];
    }
    
    //传滚动的范围
    CGFloat hight = _classArray.count * _tableView.rowHeight;
    self.scollHight(hight);
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (currentIOS >= 11.0) {
        return 0.01;
    } else {
        return 32;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%@",_classArray[indexPath.row]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {//课程的时候
        if ([_classArray[indexPath.row][@"type"] integerValue] == 1) {//课程
            NSDictionary *dict = [_classArray objectAtIndex:indexPath.row];
            Good_ClassMainViewController *vc = [[Good_ClassMainViewController alloc] init];
            vc.ID = [dict stringValueForKey:@"id"];
            vc.title = [dict stringValueForKey:@"video_title"];
            vc.price = [dict stringValueForKey:@"price"];
            vc.imageUrl = [dict stringValueForKey:@"imageurl"];
            vc.videoUrl = [dict stringValueForKey:@"video_address"];
            vc.orderSwitch = _order_switch;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([_classArray[indexPath.row][@"type"] integerValue] == 2) {
            
//            NSString *address = [[_dataArray objectAtIndex:indexPath.row] stringValueForKey:@"video_address"];
            NSString *Cid = [NSString stringWithFormat:@"%@",[[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"id"]];
            NSString *Price = [[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"price"];
            NSString *Title = [[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"video_title"];
            NSString *ImageUrl = [[_classArray objectAtIndex:indexPath.row] stringValueForKey:@"imageurl"];
    
            ZhiBoMainViewController *MainVc = [[ZhiBoMainViewController alloc]initWithMemberId:Cid andImage:ImageUrl andTitle:Title andNum:(int)indexPath.row andprice:Price];
            MainVc.order_switch = _order_switch;
            [self.navigationController pushViewController:MainVc animated:YES];
        }
    }
}

#pragma mark --- 网络请求
//获取机构详情
- (void)netWorkSchoolGetInfo {
    
    NSString *endUrlStr = YunKeTang_School_school_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_schoolID forKey:@"school_id"];
    [mutabDict setObject:@"1" forKey:@"page"];
    [mutabDict setObject:@"5" forKey:@"count"];
    
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
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        _classArray = [dict arrayValueForKey:@"recommend_list"];
        if (_classArray.count == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, 200)];
            imageView.image = [UIImage imageNamed:@"云课堂_空数据 （小）"];
            
            if (iPhone6) {
                imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 145, 200, 200);
            } else if (iPhone6Plus) {
                imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 180, 200, 200);
            } else if (iPhone5o5Co5S) {
                imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 130, 200, 200);
            }
            [self.view addSubview:imageView];
        }
        
//        _tableView.frame = CGRectMake(0, 30, MainScreenWidth, _classArray.count * 110 + 40);
        [_tableView reloadData];

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取机构课程详情
- (void)netWorkSchoolGetVideoList {
    
    NSString *endUrlStr = YunKeTang_Video_videogetList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_schoolID forKey:@"school_id"];
    [mutabDict setObject:@"20" forKey:@"count"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        //        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
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
                _classArray = [dict arrayValueForKey:@"data"];
            } else {
                _classArray = (NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        if (_classArray.count == 0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, 200)];
            imageView.image = [UIImage imageNamed:@"云课堂_空数据 （小）"];
            
            if (iPhone6) {
                imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 145, 200, 200);
            } else if (iPhone6Plus) {
                imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 180, 200, 200);
            } else if (iPhone5o5Co5S) {
                imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 130, 200, 200);
            }
            [self.view addSubview:imageView];
        }
        _tableView.frame = CGRectMake(0, 30, MainScreenWidth, MainScreenHeight * 10);
        [_tableView reloadData];
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
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}





@end
