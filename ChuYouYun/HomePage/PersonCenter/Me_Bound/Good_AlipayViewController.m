//
//  Good_AlipayViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/11/7.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "Good_AlipayViewController.h"
#import "AppDelegate.h"
#import "rootViewController.h"
#import "SYG.h"
#import "BigWindCar.h"

#import "Good_AliBoundViewController.h"

@interface Good_AlipayViewController ()

@property (strong ,nonatomic)NSArray        *dataArray;
@property (strong ,nonatomic)UITextField    *aliTextField;
@property (strong ,nonatomic)NSDictionary   *aliDict;

@end

@implementation Good_AlipayViewController

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
    [self addAilpay];
//    [self NetWorkAlipayInfo];
    [self netWorkUserGetAlipayInfo];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 100, 25, 200, 30)];
    WZLabel.text = @"支付宝";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.font = [UIFont systemFontOfSize:20];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    [SYGView addSubview:WZLabel];
}

#pragma mark --- 添加视图
- (void)addAilpay {
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 64 , MainScreenWidth, 40 * WideEachUnit)];
    title.text = @"支付宝账号";
    title.font = Font(14 * WideEachUnit);
    title.textColor = [UIColor colorWithHexString:@"#656565"];
    [self.view addSubview:title];
    
    //添加输入框
    UITextField *aliTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64 + 40 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit)];
    aliTextField.backgroundColor = [UIColor whiteColor];
    aliTextField.enabled = NO;
    [self.view addSubview:aliTextField];
    _aliTextField = aliTextField;
    aliTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10 * WideEachUnit, 10 * WideEachUnit)];
    aliTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
    //切换账号
    UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 64 + 100 * WideEachUnit, 100 * WideEachUnit, 30 * WideEachUnit)];
    [changeButton setTitle:@"切换账号" forState:UIControlStateNormal];
    [changeButton setImage:Image(@"") forState:UIControlStateNormal];
    [changeButton setTitleColor:[UIColor colorWithHexString:@"#333"] forState:UIControlStateNormal];
    changeButton.titleLabel.font = Font(14 * WideEachUnit);
    [changeButton addTarget:self action:@selector(changeButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
    
    //解除绑定
    UIButton *relieveButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 120 * WideEachUnit, 64 + 100 * WideEachUnit, 100 * WideEachUnit, 30 * WideEachUnit)];
    [relieveButton setTitleColor:[UIColor colorWithHexString:@"#d04c4c"] forState:UIControlStateNormal];
    [relieveButton setTitle:@"解除绑定" forState:UIControlStateNormal];
    relieveButton.titleLabel.font = Font(14 * WideEachUnit);
    [relieveButton addTarget:self action:@selector(relieveButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:relieveButton];
    
}

#pragma mark --- 事件处理
- (void)backPressed {
    if ([_isFormBound isEqualToString:@"bound"]) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)changeButtonCilck {
    Good_AliBoundViewController *vc = [[Good_AliBoundViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)relieveButtonCilck:(UIButton *)button {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认解除绑定？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        [self NetWorkDoBondAlipay];
        [self netWorkUserUnbindAlipay];
    }];
    [alertController addAction:sureAction];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    

}

#pragma mark --- 网络请求


- (void)NetWorkDoBondAlipay {
    
    BigWindCar *manager = [BigWindCar manager];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] != nil) {
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
    }
    [dic setObject:[_aliDict stringValueForKey:@"id"] forKey:@"id"];
    [manager BigWinCar_GetPublicWay:dic mod:@"User" act:@"doBondAlipay" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *msg = [responseObject stringValueForKey:@"msg"];
        if ([responseObject[@"code"] integerValue] == 1) {
//            [MBProgressHUD showError:msg toView:self.view];
            [MBProgressHUD showSuccess:msg toView:self.view];
            [self backPressed];
        } else {
            [MBProgressHUD showError:msg toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark --- 网络请求
//获取支付宝的信息
- (void)netWorkUserGetAlipayInfo {
    
    NSString *endUrlStr = YunKeTang_User_user_getAlipayInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"20" forKey:@"count"];
    
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
        _aliDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        _aliDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        _aliTextField.text = [_aliDict stringValueForKey:@"account"];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}


//解除当前绑定
- (void)netWorkUserUnbindAlipay {
    
    NSString *endUrlStr = YunKeTang_User_user_unbindAlipay;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:[_aliDict stringValueForKey:@"id"] forKey:@"id"];
    
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
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            [self backPressed];
        } else {
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    [op start];
}






@end
