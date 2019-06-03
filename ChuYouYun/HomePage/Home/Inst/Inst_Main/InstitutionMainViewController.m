//
//  InstitutionMainViewController.m
//  dafengche
//
//  Created by 智艺创想 on 16/10/13.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import "InstitutionMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"

#import "InstationClassViewController.h"
#import "InstationTeacherViewController.h"
#import "InstitutionHomeViewController.h"

#import "InstitionDiscountViewController.h"
#import "MessageSendViewController.h"
#import "DLViewController.h"
#import "ZhiBoMainViewController.h"


@interface InstitutionMainViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    NSInteger currentIndex;
    CGFloat buttonW;
    CGFloat moreViewH;
    
    CGFloat basidFrame;
    CGFloat classFrame;
    CGFloat teacherFrame;
    
    NSString *offSet;
    
}
@property (strong ,nonatomic)UIView *infoView;
@property (strong ,nonatomic)UITableView *cityTableView;
@property (strong ,nonatomic)NSArray *cityDataArray;
@property (strong ,nonatomic)NSArray *subVcArray;
//@property (strong ,nonatomic)UIButton *allButton;
@property (strong ,nonatomic)UIButton *seletedButton;
@property (strong ,nonatomic)UISegmentedControl *mainSegment;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UILabel *WZLabel;

@property (strong ,nonatomic)UIButton *attentionButton;

@property (strong ,nonatomic)NSString *homeScrollHight;
@property (strong ,nonatomic)NSString *classScrollHight;
@property (strong ,nonatomic)NSString *teacherScrollHight;
@property (strong ,nonatomic)NSString *followingStr;

@end

@implementation InstitutionMainViewController

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self getTheClassOffSet];
    [self getTheTeacherOffSet];
    
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
    [self getTheClassFrame];
    [self getTheTeacherFrame];

    [self interFace];
    [self addAllScrollView];

//    [self netWorkInstitutionInfo];
    [self netWorkSchoolGetInfo];
    

}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    currentIndex = 0;
    _imageArray = @[@"你好",@"我好",@"他好",@"你好",@"大家好"];
    _titleInfoArray = @[@"简介"];
    
    //通知
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeScrollHight:) name:@"IntHomeScrollHight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getClassScrollHight:) name:@"InsClassScrollHight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTeacherScrollHight:) name:@"NSNotificationInstTeacherScrollFrame" object:nil];
    
    
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = [UIColor clearColor];
    [_allScrollView addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
}


- (void)addAllScrollView {
    
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreenWidth, MainScreenHeight)];
    if (iPhoneX) {
        _allScrollView.frame = CGRectMake(0, 88, MainScreenWidth, MainScreenHeight - 83 - 88);
    }
//    _allScrollView.pagingEnabled = YES;
    _allScrollView.delegate = self;
    _allScrollView.bounces = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _allScrollView.contentSize = CGSizeMake(0, 2000);
    [self.view addSubview:_allScrollView];
}

- (void)addInfoView {
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 150 * WideEachUnit)];
    _infoView.backgroundColor = [UIColor redColor];
    [_allScrollView addSubview:_infoView];
    
    //背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_infoView.bounds];
    imageView.image = Image(@"my_bg100");
    [_infoView addSubview:imageView];
    _imageView = imageView;
    
    //机构头像
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 * WideEachUnit, 70 * WideEachUnit, 60 * WideEachUnit, 60 * WideEachUnit)];
    headerImageView.image = Image(@"你好");
    headerImageView.layer.cornerRadius = 6 * WideEachUnit;
    headerImageView.layer.masksToBounds = YES;
    NSString *urlStr = [_schoolDic stringValueForKey:@"cover"];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    [_infoView addSubview:headerImageView];
    
    
    
    //添加名字
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(90 * WideEachUnit, 80 * WideEachUnit,MainScreenWidth - 100 * WideEachUnit, 16 * WideEachUnit)];
    Name.text = [_schoolDic stringValueForKey:@"title"];
    Name.textColor = [UIColor colorWithHexString:@"#fff"];
    Name.font = Font(16 * WideEachUnit);
    [_infoView addSubview:Name];
    
    
    //添加介绍
    _schoolInfo = [[UILabel alloc] initWithFrame:CGRectMake(90 * WideEachUnit, 105 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 20 * WideEachUnit)];
//    [self setIntroductionText:[_schoolDic stringValueForKey:@"type"]];
    _schoolInfo.font = Font(12 * WideEachUnit);
    _schoolInfo.textColor = [UIColor colorWithHexString:@"#fff"];
    _schoolInfo.text = @"0个课程    0人关注";
    NSString *video_count = [[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"video_count"];
    NSString *teacher_count = [[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"teacher_count"];
    _schoolInfo.text = [NSString stringWithFormat:@"%@个课程 | %@位讲师",video_count,teacher_count];
    [_infoView addSubview:_schoolInfo];
    
    
    //添加关注的按钮
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80 * WideEachUnit, 80 * WideEachUnit, 70 * WideEachUnit, 30 * WideEachUnit)];
    if ([_followingStr integerValue] == 0) {
        [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    } else {
        [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    _attentionButton.titleLabel.font = Font(13 * WideEachUnit);
    [_attentionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_attentionButton setImage:Image(@"icon_focus@3x") forState:UIControlStateNormal];
    _attentionButton.backgroundColor = [UIColor whiteColor];
    _attentionButton.layer.cornerRadius = 15 * WideEachUnit;
    [_attentionButton addTarget:self action:@selector(attentionButtonButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:_attentionButton];
    _attentionButton.hidden = YES;
    
    
    
    //添加粉丝、浏览、评价的界面
    UIView *kinsOfView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_schoolInfo.frame), MainScreenWidth, 40)];
    kinsOfView.backgroundColor = [UIColor clearColor];
    [_infoView addSubview:kinsOfView];
    kinsOfView.hidden = YES;
    
    NSArray *buttonArray = @[@"浏览",@"粉丝"];
    
    CGFloat labelW = 100 * WideEachUnit;
    CGFloat labelH = 20;
    CGFloat buttonW = 100 * WideEachUnit;
    CGFloat buttonH = 20;
    
    NSString *Str0 = [NSString stringWithFormat:@"%@",[[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"view_count"]];
//    NSString *Str1 = [NSString stringWithFormat:@"%@",[[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"comment_score"]];
    NSString *Str2 = [NSString stringWithFormat:@"%@",[[_schoolDic dictionaryValueForKey:@"count"] stringValueForKey:@"follower_count"]];
    
    NSArray *titleArray = @[Str0,Str2];
    
    
    for (int i = 0 ; i < buttonArray.count ; i ++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelW, 0, labelW, labelH)];
        if (i == 0) {
            label.frame = CGRectMake(MainScreenWidth / 2 - labelW, 0, labelW, labelH);
        } else {
            label.frame = CGRectMake(MainScreenWidth / 2, 0, labelW, labelH);
        }
        label.text = titleArray[i];
        label.font = Font(12);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [kinsOfView addSubview:label];

        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * buttonW, 20, buttonW, buttonH)];
        if (i == 0) {
            button.frame = CGRectMake(MainScreenWidth / 2 - labelW, 20, labelW, labelH);
        } else {
            button.frame = CGRectMake(MainScreenWidth / 2, 20, labelW, labelH);
        }
        [button setTitle:buttonArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = Font(12);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [kinsOfView addSubview:button];
    }
    
}

#pragma mark -- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segleMentView.frame) + 10,  MainScreenWidth, MainScreenHeight * 3 + 500)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 3,0);
    [_allScrollView addSubview:_controllerSrcollView];

    InstitutionHomeViewController * instHomeVc= [[InstitutionHomeViewController alloc]init];
    instHomeVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:instHomeVc];
    instHomeVc.address = _address;
    [_controllerSrcollView addSubview:instHomeVc.view];
    
    InstationClassViewController * classVc = [[InstationClassViewController alloc]init];
    classVc.view.frame = CGRectMake(MainScreenWidth, -64, MainScreenWidth, MainScreenHeight * 1 + 500);
    [self addChildViewController:classVc];
    [_controllerSrcollView addSubview:classVc.view];
    
    InstationTeacherViewController * teacherVc = [[InstationTeacherViewController alloc]init];
    teacherVc.view.frame = CGRectMake(MainScreenWidth * 2, -64, MainScreenWidth, MainScreenHeight * 20 + 500);
    [self addChildViewController:teacherVc];
    [_controllerSrcollView addSubview:teacherVc.view];
    
    //添加通知(通知所传达的地方必须要已经实体化，不然就不会相应通知的方法)
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_schoolID forKey:@"school_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationInstitionSchoolID" object:nil userInfo:dict];
    
    _subVcArray = @[instHomeVc,classVc,teacherVc];
    [self addClassBolck];
    [self addTeacherBolck];
}

- (void)addClassBolck {
    InstationClassViewController *vc = _subVcArray[1];
    vc.scollHight = ^(CGFloat hight) {
        _classScrollHight = [NSString stringWithFormat:@"%lf",hight];
    };
}

- (void)addTeacherBolck {
    InstationTeacherViewController *vc = _subVcArray[2];
    vc.scrollHight = ^(CGFloat hight) {
        _teacherScrollHight = [NSString stringWithFormat:@"%lf",hight];
    };
}


- (void)addDiscountView  {
    _discountView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_classScrollView.frame) + 10, MainScreenWidth, 40)];
    _discountView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:_discountView];
    
    //添加标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceBaside, 0, MainScreenWidth - SpaceBaside * 2, 40)];
    titleLabel.text = @"优惠券";
    [_discountView addSubview:titleLabel];
    
    //添加更多课程
    UIButton *moreClassButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 40)];
//    [moreClassButton setImage:Image(@"考试右") forState:UIControlStateNormal];
    moreClassButton.backgroundColor = [UIColor clearColor];
    [moreClassButton setTitleColor:BasidColor forState:UIControlStateNormal];
    moreClassButton.titleLabel.font = Font(16);
    [_discountView addSubview:moreClassButton];
    [moreClassButton addTarget:self action:@selector(discountMoreButtonClick) forControlEvents:UIControlEventTouchUpInside];

    
}


#pragma mark --- 滚动试图

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat ContentX = _classScrollView.contentOffset.x;
    
    if (ContentX < MainScreenWidth) {
        self.pageControl.currentPage = 0;
    } else if (ContentX < 2 * MainScreenWidth) {
        self.pageControl.currentPage = 1;
    } else if (ContentX < 3 * MainScreenWidth) {
        self.pageControl.currentPage = 2;
    } else if (ContentX < 4 * MainScreenWidth) {
        self.pageControl.currentPage = 3;
    }
    
    CGFloat contentCrorX = _controllerSrcollView.contentOffset.x;
    if (contentCrorX < MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 0;
        _allScrollView.contentSize = CGSizeMake(0 , [_homeScrollHight floatValue] + 250);
    } else if (contentCrorX < 2 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 1;
        _allScrollView.contentSize = CGSizeMake(0 , [_classScrollHight floatValue] + 220);
        
        
//        if([scrollView isKindOfClass:[UITableView class]]) {
//
//            //如果是tableview滑动
//        } else {
//
//            //否则是scrollView滑动
//        }
        
    } else if (contentCrorX < 3 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 2;
        _allScrollView.contentSize = CGSizeMake(0, [_teacherScrollHight floatValue] + 210);
    }
    
    
    
}

- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_infoView.frame), MainScreenWidth, 50)];
    WZView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:WZView];
    _segleMentView = WZView;
    
    NSArray *segmentedArray = @[@"首页",@"课程",@"讲师"];
    _mainSegment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _mainSegment.frame = CGRectMake(0,SpaceBaside,MainScreenWidth, 30);

    //文字设置
    NSMutableDictionary *attDicNormal = [NSMutableDictionary dictionary];
    attDicNormal[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    attDicNormal[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#888"];
    NSMutableDictionary *attDicSelected = [NSMutableDictionary dictionary];
    attDicSelected[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    attDicSelected[NSForegroundColorAttributeName] = BasidColor;
    [_mainSegment setTitleTextAttributes:attDicNormal forState:UIControlStateNormal];
    [_mainSegment setTitleTextAttributes:attDicSelected forState:UIControlStateSelected];
    _mainSegment.selectedSegmentIndex = 0;
    _mainSegment.backgroundColor = [UIColor whiteColor];
    [WZView addSubview:_mainSegment];
    
    _mainSegment.tintColor = [UIColor whiteColor];
    _mainSegment.momentary = NO;
    [_mainSegment addTarget:self action:@selector(mainChange:) forControlEvents:UIControlEventValueChanged];
    basidFrame = CGRectGetMaxY(_mainSegment.frame);
    
}


- (void)addInstationMore {
    [self addMoreView];
}

- (void)addMoreView {
    
    _allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    _allView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:_allView];
//    [self.view insertSubview:_allView belowSubview:_downView];

    
    //添加中间的按钮
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight + 44)];
    [_allButton setBackgroundColor:[UIColor clearColor]];
    [_allButton addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
    [_allView addSubview:_allButton];
    
    
    moreViewH = _titleInfoArray.count * 40 + 5 * (_titleInfoArray.count - 1);
    
    _buyView = [[UIView alloc] init];
    _buyView.frame = CGRectMake(buttonW, MainScreenHeight, buttonW, moreViewH);
    _buyView.backgroundColor = [UIColor colorWithRed:254.f / 255 green:255.f / 255 blue:255.f / 255 alpha:1];
    _buyView.layer.cornerRadius = 3;
    [_allView addSubview:_buyView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(buttonW, MainScreenHeight - 50 - moreViewH, buttonW, moreViewH);
        //在view上面添加东西
        for (int i = 0 ; i < _titleInfoArray.count ; i ++) {
            
            UIButton *button = [[UIButton alloc ] initWithFrame:CGRectMake(0, i * 40 + i * 5, 100, 40)];
            [button setTitle:_titleInfoArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:64.f / 255 green:64.f / 255 blue:64.f / 255 alpha:1] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
//            button.tag = [_SYGArray[i][@"exam_category_id"] integerValue];
            [button addTarget:self action:@selector(SYGButton:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [_buyView addSubview:button];
        }
        
        //添加中间的分割线
        for (int i = 0; i < _titleInfoArray.count; i ++) {
            UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 43 * i , buttonW, 1)];
            XButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [_buyView addSubview:XButton];
        }
    }];
}

- (void)miss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _buyView.frame = CGRectMake(buttonW, MainScreenHeight, buttonW, moreViewH);
        _allView.alpha = 0;
        _allButton.alpha = 0;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_allView removeFromSuperview];
        [_allButton removeFromSuperview];
        [_buyView removeFromSuperview];
        
    });
}

- (void)SYGButton:(UIButton *)button {
    [self miss];
    
    //这里应该要设置偏移量
    _controllerSrcollView.contentOffset = CGPointMake(0, 0);
    
}


#pragma mark --- 事件监听

- (void)moreButtonClick:(UIButton *)button {
    
}

- (void)discountMoreButtonClick {
    
    InstitionDiscountViewController *discountVc = [[InstitionDiscountViewController alloc] init];
    discountVc.schoolID = _schoolID;
    [self.navigationController pushViewController:discountVc animated:YES];
    
}

- (void)mainChange:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:
             _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            _allScrollView.contentSize = CGSizeMake(0 , [_homeScrollHight floatValue] + 250);
            break;
        case 1:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0 , [_classScrollHight floatValue] + 350);
            break;
        case 2:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0, [_teacherScrollHight floatValue] + 240);
            break;
            
        default:
            break;
    }
    
}

//添加私信或者电话
- (void)addPhoneOrMessage {
    
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"私信" otherButtonTitles:@"呼叫", nil];
    action.delegate = self;
    [action showInView:self.view];

}


- (void)attentionButtonButtonCilck:(UIButton *)button {
    NSString *title = button.titleLabel.text;
    if ([title isEqualToString:@"取消关注"]) {
        [self netWorkUseUnFollow];
    } else if ([title isEqualToString:@"关注"]) {
        [self netWorkUseFollow];
    }
}


#pragma mark --- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){//私信
        [self sendMessage];

    }else if (buttonIndex == 1){//呼叫
        [self CallPhone];
    }
}

-(void)CallPhone{

    NSString *phoneStr = [_schoolDic stringValueForKey:@"phone"];
    NSLog(@"----%@",phoneStr);
    if (phoneStr == nil || [phoneStr isEqualToString:@""]) {
        [MBProgressHUD showError:@"电话号码为空，不能拨打" toView:self.view];
        return;
    }
    NSMutableString *phoneString = [[NSMutableString alloc] initWithFormat:@"tel:%@",phoneStr];
    UIWebView *callWebView = [[UIWebView alloc] init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneString]]];
    [self.view addSubview:callWebView];
    
}

- (void)sendMessage {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    
    MessageSendViewController *MSVC = [[MessageSendViewController alloc] init];
    MSVC.TID = _uID;
    MSVC.name = [_schoolDic stringValueForKey:@"title"];
    [self.navigationController pushViewController:MSVC animated:YES];

}

#pragma mark --- 文本自适应

-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _schoolInfo.text = text;
    //设置label的最大行数
    _schoolInfo.numberOfLines = 0;
    
    CGRect labelSize = [_schoolInfo.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    
    _schoolInfo.frame = CGRectMake(50,130,MainScreenWidth - 100,labelSize.size.height);
    _infoView.frame = CGRectMake(0, 0, MainScreenWidth, 170 + labelSize.size.height );
    
    //重新添加背景 不然会变形
    _imageView.frame = CGRectStandardize(_infoView.frame);
}

#pragma mark --- 通知

- (void)getTheClassFrame {
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(getTheClassFrame:) name:@"NSNotificationInstClassScrollFrame" object:nil];
    
}

- (void)getTheClassFrame:(NSNotification *)Not {
    NSLog(@"%@",Not.userInfo);
    classFrame = [Not.userInfo[@"frame"] floatValue];
    
}

- (void)getTheTeacherFrame {
    
    
}

- (void)getTheClassOffSet {
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(getTheClassOffSet:) name:@"NSNotificationInsClassOffSet" object:nil];
    
    if (offSet) {
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * [offSet integerValue], 0);
        offSet = nil;
    }
}

- (void)getTheClassOffSet:(NSNotification *)Not {
    offSet = Not.userInfo[@"offSet"];
}

- (void)getTheTeacherOffSet {
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(getTheTeacherOffSet:) name:@"NSNotificationInsTeacherOffSet" object:nil];
    
    if (offSet) {
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * [offSet integerValue], 0);
        offSet = nil;
    }
}

- (void)getTheTeacherOffSet:(NSNotification *)Not {
    offSet = Not.userInfo[@"offSet"];
}

- (void)getHomeScrollHight:(NSNotification *)not {
    _homeScrollHight = (NSString *)not.object;
    _allScrollView.contentSize = CGSizeMake(0 , [_homeScrollHight floatValue] + 250);
}

- (void)getClassScrollHight:(NSNotification *)not {
    _classScrollHight = (NSString *)not.object;
    _allScrollView.contentSize = CGSizeMake(0 , [_classScrollHight floatValue] + 350);
}

- (void)getTeacherScrollHight:(NSNotification *)not {
    NSLog(@"%@",not.userInfo);
    NSDictionary *dict = not.userInfo;
    _teacherScrollHight = [dict stringValueForKey:@"frame"];
    NSLog(@"---gaodu%@",_teacherScrollHight);
    _allScrollView.contentSize = CGSizeMake(0 , [_teacherScrollHight floatValue] + 240);
}

#pragma mark --- 网络请求
//获取机构详情
- (void)netWorkSchoolGetInfo {
    
    NSString *endUrlStr = YunKeTang_School_school_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];

    if (_schoolID == nil) {
        return;
    } else {
        [mutabDict setObject:_schoolID forKey:@"school_id"];
    }
    
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
        _schoolDic = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        _WZLabel.text = [_schoolDic stringValueForKey:@"title"];
        _classArray = [_schoolDic arrayValueForKey:@"recommend_list"];
        _followingStr = [[_schoolDic dictionaryValueForKey:@"follow_state"] stringValueForKey:@"following"];
        [self addInfoView];
        [self addNav];
        [self addWZView];
        [self addControllerSrcollView];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//添加关注
- (void)netWorkUseFollow {
    
    NSString *endUrlStr = YunKeTang_User_user_follow;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
    if ([userID integerValue] == [_uID integerValue]) {//说明是自己
        [MBProgressHUD showError:@"不能关注自己" toView:self.view];
        return;
    }
    if (_uID == nil) {
        [MBProgressHUD showError:@"不能关注自己的机构" toView:self.view];
        return;
    } else {
        if ([_myUID integerValue] == [_uID integerValue]) {
            [MBProgressHUD showError:@"不能关注自己的机构" toView:self.view];
            return;
        } else {
            [mutabDict setObject:_uID forKey:@"user_id"];
        }
    }
    
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
            [MBProgressHUD showSuccess:@"关注成功" toView:self.view];
            [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
            return ;
        } else {
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//取消关注
- (void)netWorkUseUnFollow {
    
    NSString *endUrlStr = YunKeTang_User_user_unfollow;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:_uID forKey:@"user_id"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
    if ([userID integerValue] == [_uID integerValue]) {//说明是自己
        [MBProgressHUD showError:@"不能关注自己" toView:self.view];
        return;
    }
    
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
            [MBProgressHUD showSuccess:@"取消关注成功" toView:self.view];
            [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
            return ;
        } else {
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}





@end
