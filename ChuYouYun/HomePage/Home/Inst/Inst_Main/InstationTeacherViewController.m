//
//  InstationTeacherViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/11/4.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstationTeacherViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#import "SearchTeacherCell.h"

#import "GLTeaTableViewCell.h"
#import "TeacherMainViewController.h"



@interface InstationTeacherViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic)UITableView *tableView;
@property (strong ,nonatomic)UIImageView *imageView;

@property (strong ,nonatomic)NSArray *headerTitleArray;
@property (strong ,nonatomic)NSArray *dataArray;
@property (strong ,nonatomic)NSArray *teacherArray;
@property (strong ,nonatomic)UIView  *tableViewFootView;

@end

@implementation InstationTeacherViewController

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, 200)];
        _imageView.image = [UIImage imageNamed:@"云课堂_空数据 （小）"];
        if (iPhone6) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 145, 200, 200);
        } else if (iPhone6Plus) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 180, 200, 200);
        } else if (iPhone5o5Co5S) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 130, 200, 200);
        }
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
    [self interFace];
    [self addTableView];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _headerTitleArray = @[@"一对一"];
    
    //接受通知（将机构的id传过来）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetInstitonSchoolID:) name:@"NotificationInstitionSchoolID" object:nil];
}

#pragma mark --- 通知

- (void)GetInstitonSchoolID:(NSNotification *)Not {
    _schoolID = (NSString *)Not.userInfo[@"school_id"];
    [self netWorkTeacherGetList:1];
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight * 10) style:UITableViewStylePlain];
    _tableView.rowHeight = 130 + 10 - 10;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = _tableViewFootView;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark --- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _teacherArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellStr = @"GLTeaTableViewCell";
    GLTeaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellStr];
    if (cell == nil) {
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        cell = [[GLTeaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellStr];
        cell.instLabel.hidden = YES;
        cell.instView.frame = CGRectMake(0, 130, MainScreenWidth, 10 * WideEachUnit);
        cell.instView.hidden = YES;
        cell.boundaryView.frame = CGRectMake(0, 125, MainScreenWidth, 10 * WideEachUnit);
        cell.lineButton.hidden = YES;
        cell.areaLab.hidden = YES;
    }
    NSDictionary *dict = [_teacherArray objectAtIndex:indexPath.row];
    [cell dataWithDict:dict];
    CGFloat hight = _teacherArray.count * _tableView.rowHeight;
    self.scrollHight(hight);
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TeacherMainViewController *teacherMainVc = [[TeacherMainViewController alloc]initWithNumID:_teacherArray[indexPath.row][@"id"]];
    [self.navigationController pushViewController:teacherMainVc animated:YES];
}

//获取滚动的高度

#pragma mark --- 事件监听

- (void)allClassButtonCilck:(UIButton *)button {
    
}

#pragma mark --- 网络请求
- (void)netWorkTeacherGetList:(NSInteger)Num {
    
    NSString *endUrlStr = YunKeTang_Teacher_teacher_getList;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"1" forKey:@"page"];
    [mutabDict setObject:@"10" forKey:@"count"];
    [mutabDict setObject:_schoolID forKey:@"school_id"];
    [mutabDict setObject:@"1" forKey:@"stauts"];
    
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
                _teacherArray = [NSMutableArray arrayWithArray:[dict arrayValueForKey:@"data"]];
                if (Num == 1) {
                    _teacherArray = [NSMutableArray arrayWithArray:[dict arrayValueForKey:@"data"]];
                } else {
//                    [_teacherArray ]
                }
            } else {
                if (Num == 1) {
                    _teacherArray = [NSMutableArray arrayWithArray:(NSArray *)[YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject]];
                } else {
                    
                }
            }
        }
        _tableView.frame = CGRectMake(0, 64, MainScreenWidth, MainScreenHeight * 10);
        if (_teacherArray.count == 0) {
            self.imageView.hidden = NO;
        } else {
            self.imageView.hidden = YES;
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}




@end
