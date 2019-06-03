//
//  MyExerciseViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/26.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "MyExerciseViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"

#import "BigWindCar.h"
#import "MyExerciseTableViewCell.h"
#import "TestCurrentViewController.h"
#import "TestResultViewController.h"


@interface MyExerciseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *imageView;
@property (assign ,nonatomic)NSInteger   Number;

@property (strong ,nonatomic)NSMutableArray *dataArray;

//考试界面相关
@property (strong ,nonatomic)NSDictionary  *dataSource;
@property (strong ,nonatomic)NSDictionary  *testDict;


@end

@implementation MyExerciseViewController


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
    [self addTableView];
//    [self NetWorkGetOrderWithNumber:1];
}
- (void)interFace {
    
    self.view.backgroundColor = [UIColor whiteColor];
//    _dataArray = [NSMutableArray array];
    _Number = 1;
}

#pragma mark --- UITableView

- (void)addTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 44 * WideEachUnit, MainScreenWidth, MainScreenHeight - 64 - 44 * WideEachUnit + 36) style:UITableViewStyleGrouped];
    if (iPhoneX) {
        _tableView.frame = CGRectMake(0, 60 + 44 * WideEachUnit, MainScreenWidth, MainScreenHeight - 88 - 44 * WideEachUnit + 36);
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 75 * WideEachUnit;
//    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:_tableView];
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
//    [self NetWorkExamsLogWithNumber:1];
    [self netWorkExamsGetExamsLog:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    });
    
    
}

- (void)footerRefreshing {
    _Number ++;
//    [self NetWorkExamsLogWithNumber:_Number];
    [self netWorkExamsGetExamsLog:_Number];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        [_tableView footerEndRefreshing];
    });
}




#pragma mark --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellID = nil;
    CellID = [NSString stringWithFormat:@" - %ld",indexPath.row];
    //自定义cell类
    MyExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    //自定义cell类
    if (cell == nil) {
        cell = [[MyExerciseTableViewCell alloc] initWithReuseIdentifier:CellID];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    [cell dataSourceWith:dict WithType:@"1"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //这里写个通知 （目的是最后从出来的时候不会停留在练习记录的地方）
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationExercise" object:@"0"];
    
    _testDict = [_dataArray objectAtIndex:indexPath.row];
    
    if ([[_testDict stringValueForKey:@"progress"] integerValue] == 100) {
        if ([[_testDict stringValueForKey:@"status"] integerValue] == 0) {//正在阅卷
            return;
        }
    }
    
    if ([[_testDict stringValueForKey:@"progress"] integerValue] == 100) {
        TestResultViewController *vc = [[TestResultViewController alloc] init];
        vc.testDict = _testDict;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self netWorkExamsGetPaperInfo];
    }
}

#pragma mark --- UITableView -- 删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"index %ld",(long)indexPath.row);
    _testDict = [_dataArray objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSLog(@"----删除");
//        [self NetWorkDeleteExamsLog];
        [self netWorkExamsDeleteExamsLog];
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {}
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


#pragma mark --- 网络请求
//获取考试记录
- (void)netWorkExamsGetExamsLog:(NSInteger)Num {
    NSString *endUrlStr = YunKeTang_Exams_exams_getExamsLog;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"10" forKey:@"count"];
    [mutabDict setValue:[NSString stringWithFormat:@"%ld",Num] forKey:@"page"];
    [mutabDict setValue:@"1" forKey:@"log_type"];
    
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
        if (Num == 1) {
            _dataArray = (NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        } else {
            [_dataArray addObjectsFromArray:(NSMutableArray *) [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
        }
        if (_dataArray.count == 0) {
            _imageView.hidden = NO;
            if (_imageView.subviews.count > 0) {
            } else {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 + 40, MainScreenWidth, MainScreenHeight - 64 - 40)];
                imageView.image = [UIImage imageNamed:@"云课堂_空数据"];
                [self.view addSubview:imageView];
            }
        } else {
            _imageView.hidden = YES;
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取考试的数据
- (void)netWorkExamsGetPaperInfo {
    NSString *endUrlStr = YunKeTang_Exams_exams_getPaperInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_testDict stringValueForKey:@"exams_paper_id"] forKey:@"paper_id"];
    [mutabDict setObject:@"1" forKey:@"exams_type"];//这个界面为练习模式
    [mutabDict setObject:[_testDict stringValueForKey:@"exams_users_id"] forKey:@"exams_users_id"];
    
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    [MBProgressHUD showMessag:@"加载中..." toView:[UIApplication sharedApplication].keyWindow];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_dataSource stringValueForKey:@"code"] integerValue] == 1) {
            _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([_dataSource dictionaryValueForKey:@"paper_options"].allKeys.count == 0) {
                [MBProgressHUD showError:@"考试数据为空" toView:self.view];
                return ;
            }
            if ([[_dataSource dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions"].allKeys.count == 0) {
                [MBProgressHUD showError:@"考试数据为空" toView:self.view];
                return ;
            }
            TestCurrentViewController *vc = [[TestCurrentViewController alloc] init];
            vc.examsType = @"1";
            vc.dataSource = _dataSource;
            vc.continueStr = @"continue";//这个标识符主要是用于继续答题的时候 要吧之前的答案显示出来（所以在答题的时候，答案要处理一次）
            vc.testDict = _testDict;
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showError:[_dataSource stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
    [op start];
}


//删除记录
- (void)netWorkExamsDeleteExamsLog {
    NSString *endUrlStr = YunKeTang_Exams_exams_deleteExamsLog;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_testDict stringValueForKey:@"exams_users_id"] forKey:@"exams_users_id"];
    
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
        NSDictionary *deleDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if (deleDict.allKeys.count > 0 ) {
             [self netWorkExamsGetExamsLog:1];
        } else {
            [MBProgressHUD showError:@"删除记录失败" toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


@end
