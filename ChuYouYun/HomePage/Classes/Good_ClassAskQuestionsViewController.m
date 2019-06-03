//
//  Good_ClassAskQuestionsViewController.m
//  YunKeTang
//
//  Created by IOS on 2019/3/19.
//  Copyright © 2019年 ZhiYiForMac. All rights reserved.
//

#import "Good_ClassAskQuestionsViewController.h"
#import "SYG.h"
#import "AppDelegate.h"
#import "BigWindCar.h"
#import "DLViewController.h"

#import "Good_ClassNotesTableViewCell.h"



@interface Good_ClassAskQuestionsViewController ()<UITableViewDelegate,UITableViewDataSource> {
        CGRect  _keyboardRect;
}

@property (strong ,nonatomic)UIImageView   *imageView;
@property (strong ,nonatomic)UITableView   *tableView;
@property (strong ,nonatomic)UIView        *downView;
@property (strong ,nonatomic)UIView        *headerView;
@property (strong ,nonatomic)UITextView    *textView;
@property (strong ,nonatomic)UIView        *allWindowView;
@property (strong ,nonatomic)UIView        *moreView;

@property (strong ,nonatomic)NSArray       *dataArray;
@property (strong ,nonatomic)NSDictionary  *dataSoruce;
@property (strong ,nonatomic)NSString      *ID;
@property (strong ,nonatomic)NSString      *currentID;

@end

@implementation Good_ClassAskQuestionsViewController

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, 200)];
        _imageView.image = [UIImage imageNamed:@"云课堂_空数据 （小）"];
        if (iPhone6) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 90, 200, 200);
        } else if (iPhone6Plus) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 180, 200, 200);
        } else if (iPhone5o5Co5S) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 120, 200, 200);
        } else if (iPhoneX) {
            _imageView.frame = CGRectMake(MainScreenWidth / 2 - 100, 180, 200, 200);
        }
        [self.view addSubview:_imageView];
    }
    return _imageView;
}


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    app._allowRotation = YES;
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
    self.navigationController.navigationBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addDownView];
    [self addTableView];
    
    [self netWorkVideoGetRender];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //    Num = 0;
    //    indexPathRow = 0;
    //    indexPathSection = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight * 10) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _headerView;
}

- (void)addDownView {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit)];
    _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_headerView];
    
    //添加按钮
    UIButton *askButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50 * WideEachUnit)];
    [askButton setTitle:@"提问题" forState:UIControlStateNormal];
    [askButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [askButton setImage:Image(@"tiwen2-4@2x") forState:UIControlStateNormal];
    [askButton addTarget:self action:@selector(askButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:askButton];
}

#pragma mark  --- 表格视图

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    Good_ClassNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Good_ClassNotesTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell dataSourceWithDict:dic WithType:@"2"];
    CGFloat tableHight = tableView.contentSize.height;
    self.vcHight(tableHight);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark --- 点击事件

- (void)askButtonCilck {
    [self addAllWindow];
}

- (void)subitButtonCilck:(UIButton *)button {
    if (_textView.text.length > 0) {
        [self netWorkVideoAddQuestion];
    }
}


#pragma mark --- 添加全局视图
- (void)addAllWindow {
    if (!UserOathToken) {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds = YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    _allWindowView = allWindowView;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0 * WideEachUnit,MainScreenHeight - 180 * WideEachUnit,MainScreenWidth,180 * WideEachUnit)];
//    moreView.center = app.keyWindow.center;
//    moreView.center = CGPointMake(MainScreenWidth / 2, MainScreenHeight / 3);
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    moreView.userInteractionEnabled = YES;
    _allWindowView.userInteractionEnabled = YES;
    _moreView = moreView;
    
    //添加
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 12 * WideEachUnit, 180 * WideEachUnit, 12 * WideEachUnit)];
    title.textColor = [UIColor colorWithHexString:@"#333"];
    title.font = Font(12 * WideEachUnit);
    title.text = @"添加提问";
    [moreView addSubview:title];
    
    UIView *textBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 * WideEachUnit, 200 * WideEachUnit, 100 * WideEachUnit)];
    textBackView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [moreView addSubview:textBackView];
    
    //添加textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 100 * WideEachUnit)];
    _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [textBackView addSubview:_textView];
    
    //添加提交的按钮
    UIButton *subitButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, CGRectGetMaxY(textBackView.frame) + 10 * WideEachUnit, 50 * WideEachUnit, 25 * WideEachUnit)];
    [subitButton setTitle:@"提交" forState:UIControlStateNormal];
    [subitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subitButton.backgroundColor = BasidColor;
    [subitButton addTarget:self action:@selector(subitButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:subitButton];
    
    
}

#pragma mark --- 手势
- (void)allWindowViewClick:(UIGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

#pragma mark --- 键盘
- (void)keyboardWillShow:(NSNotification *)notif {
    if(![self.textView isFirstResponder]) {
        return;
    }
    NSDictionary *userInfo = [notif userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyboardRect = [aValue CGRectValue];
    CGFloat y = _keyboardRect.size.height;
    CGFloat x = _keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",(int)y);
    NSLog(@"键盘宽度是  %d",(int)x);
    [UIView animateWithDuration:0.25 animations:^{
        _moreView.frame = CGRectMake(0, MainScreenHeight - 180 * WideEachUnit - y, MainScreenWidth, 180 * WideEachUnit);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [UIView animateWithDuration:0.25 animations:^{
        _moreView.frame = CGRectMake(0, MainScreenHeight - 180 * WideEachUnit, MainScreenWidth, 180 * WideEachUnit);
    }];
}


#pragma mark --- 网络请求

//请求课程下的评论
- (void)netWorkVideoGetRender {
    
    NSString *endUrlStr = YunKeTang_Video_video_render;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"kzid"];
    [mutabDict setValue:@"1" forKey:@"kztype"]; // 2为专辑 1 为课程
    [mutabDict setValue:@"1" forKey:@"type"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (oath_token_Str != nil) {
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict arrayValueForKey:@"data"] isKindOfClass:[NSArray class]]) {
            _dataArray = [dict arrayValueForKey:@"data"];
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                self.imageView.hidden = YES;
            }
        }
        [_tableView reloadData];
        
        //        //发送通知 滚动的范围
        if (_dataArray.count == 0) {
            CGFloat scrollHight = _dataArray.count * 85 * WideEachUnit;
            NSString *hightStr = [NSString stringWithFormat:@"%lf",scrollHight];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Good_ClassCommentHight" object:hightStr];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//课程添加评论
- (void)netWorkVideoAddQuestion {

    NSString *endUrlStr = YunKeTang_Video_video_addQuestion;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];

    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_ID forKey:@"kzid"];
    [mutabDict setValue:_textView.text forKey:@"content"];
    //评论星级
    [mutabDict setValue:_currentID forKey:@"pid"];//提问的id
    [mutabDict setValue:@"1" forKey:@"kztype"]; // 2为专辑 1 为课程


    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        //        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    } else {
        [MBProgressHUD showError:@"请先去登陆" toView:self.view];
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
            [_allWindowView removeFromSuperview];
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            [self netWorkVideoGetRender];
        } else {
            [_allWindowView removeFromSuperview];
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:[UIApplication sharedApplication].keyWindow];
            [self netWorkVideoGetRender];
        }

    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}





@end
