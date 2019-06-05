//
//  TeacherMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/15.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TeacherMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"


#import "TeacherHomeViewController.h"
#import "TeacherArticleViewController.h"
#import "TeacherCommentViewController.h"
#import "TeacherClassViewController.h"
#import "MessageSendViewController.h"
#import "YYViewController.h"

#import "DLViewController.h"





@interface TeacherMainViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UIScrollViewDelegate>



@property (strong ,nonatomic)UIView *infoView;
@property (strong ,nonatomic)UIScrollView *allScrollView;
@property (strong ,nonatomic)UIScrollView *controllerSrcollView;
@property (strong ,nonatomic)UIScrollView *classScrollView;
@property (strong ,nonatomic)UIImageView  *imageView;
@property (strong ,nonatomic)UISegmentedControl *mainSegment;
@property (strong ,nonatomic)UIView *segleMentView;
@property (strong ,nonatomic)UILabel *teacherInfo;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UIButton *attentionButton;


@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSString *myUID;
@property (strong ,nonatomic)NSString *uID;//关注时用到
@property (strong ,nonatomic)NSString *teacherID;
@property (strong ,nonatomic)NSDictionary *teacherDic;
@property (strong ,nonatomic)NSString *following;
@property (strong ,nonatomic)NSString *nameStr;

@property (strong ,nonatomic)NSString *oneHightStr;
@property (strong ,nonatomic)NSString *twoHightStr;
@property (strong ,nonatomic)NSString *fourHightStr;
@property (strong ,nonatomic)NSString *homeMoreButtonSet;


@end



@implementation TeacherMainViewController

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
    self.navigationController.navigationBar.hidden = YES;
    
}

-(instancetype)initWithNumID:(NSString *)ID{
    
    self = [super init];
    if (self) {
        _ID = ID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    

    [self addAllScrollView];
//    [self addInfoView];
//    [self addWZView];
//    [self addDownView];
//    [self addControllerSrcollView];
    [self netWorkTeacherGetInfo];
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeScrollHight:) name:@"TeacherHomeScrollHight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCommentScrollHight:) name:@"TeacherCommentScrollHight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeMoreButtonCilck:) name:@"TeacherHomeMoreButtonCilck" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHomeMovePhotoCilck:) name:@"TeacherHomeMoveToPhoto" object:nil];
    
    //计算偏移量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTeacherClassScrollFrame:) name:@"NSNotificationTeacherClassScrollFrame" object:nil];
}


- (void)addAllScrollView {
    
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreenWidth, MainScreenHeight)];
    //    _allScrollView.pagingEnabled = YES;
    _allScrollView.delegate = self;
    _allScrollView.bounces = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _allScrollView.contentSize = CGSizeMake(0, 1000);
    [self.view addSubview:_allScrollView];
    if (@available(iOS 11.0, *)) {
        _allScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)addInfoView {
    
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 160 * WideEachUnit)];
    _infoView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:_infoView];
    
    //背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_infoView.bounds];
    imageView.image = Image(@"my_bg100");
    [_infoView addSubview:imageView];
    _imageView = imageView;
    
    
    //机构头像
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 70 * WideEachUnit, 60 * WideEachUnit, 60 * WideEachUnit)];
    headerImageView.image = Image(@"你好");
    headerImageView.layer.cornerRadius = 6 * WideEachUnit;
    headerImageView.layer.masksToBounds = YES;
    NSString *urlStr = [_teacherDic stringValueForKey:@"headimg"];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    [_infoView addSubview:headerImageView];
    
    //添加名字
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(85 * WideEachUnit, 80 * WideEachUnit,MainScreenWidth - 100 * WideEachUnit, 20 * WideEachUnit)];
    Name.text = [_teacherDic stringValueForKey:@"name"];
    Name.textColor = [UIColor whiteColor];
    [_infoView addSubview:Name];
    _nameStr = _teacherDic[@"name"];
    
    //添加关注的按钮
    _attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 80 * WideEachUnit, 80 * WideEachUnit, 70 * WideEachUnit, 30 * WideEachUnit)];
    if ([_following integerValue] == 0) {
        [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    } else {
        [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    _attentionButton.titleLabel.font = Font(13 * WideEachUnit);
    [_attentionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_attentionButton setImage:Image(@"icon_focus@3x") forState:UIControlStateNormal];
    _attentionButton.backgroundColor = [UIColor whiteColor];
    _attentionButton.layer.cornerRadius = 15 * WideEachUnit;
    [_attentionButton addTarget:self action:@selector(attentionButtonButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:_attentionButton];
    
    //添加介绍
    _teacherInfo = [[UILabel alloc] initWithFrame:CGRectMake(85 * WideEachUnit, 105 * WideEachUnit, MainScreenWidth - 100 * WideEachUnit, 20 * WideEachUnit)];
    _teacherInfo.textColor = [UIColor whiteColor];
    _teacherInfo.font = Font(12);
    if ([_teacherDic[@"label"] isEqual:[NSNull null]] || _teacherDic[@"label"] == nil ) {
        _teacherInfo.text = @"";
    } else {
    }

    if ([_teacherInfo.text isEqual:[NSNull null]] || _teacherDic[@"label"] == nil) {
        
    } else {
        _teacherInfo.font = Font(13 * WideEachUnit);
    }

    if ([_teacherInfo.text isEqual:[NSNull null]] || _teacherDic[@"label"] == nil) {
    } else {
         _teacherInfo.textColor = [UIColor whiteColor];
    }
    [_infoView addSubview:_teacherInfo];
//    _teacherInfo.text = @"0个课程 | 0人关注";
    NSString *courseCount = [_teacherDic stringValueForKey:@"video_count"];
    NSString *follower_count = [[_teacherDic dictionaryValueForKey:@"follow_state"] stringValueForKey:@"follower"];
    _teacherInfo.text = [NSString stringWithFormat:@"%@个课程 | %@人关注",courseCount,follower_count];
    //添加关注按钮

    
    //添加粉丝、浏览、评价的界面
    UIView *kinsOfView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_teacherInfo.frame) + 20 * WideEachUnit, MainScreenWidth, 40 * WideEachUnit)];
    kinsOfView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [_infoView addSubview:kinsOfView];
    kinsOfView.hidden = YES;

    
    CGFloat labelW = MainScreenWidth / 3;
    CGFloat labelH = 20 * WideEachUnit;
    NSString *Str0 = [NSString stringWithFormat:@"%@年教龄",_teacherDic[@"teacher_age"]];
    NSString *Str1 = [NSString stringWithFormat:@"%@个课程",_teacherDic[@"video_count"]];
    NSString *Str2 = [NSString stringWithFormat:@"%@人关注",_teacherDic[@"ext_info"][@"count_info"][@"follower_count"]];
    
    NSArray *titleArray = @[Str0,Str1,Str2];

    
    for (int i = 0 ; i < 3 ; i ++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelW, 10 * WideEachUnit, labelW, labelH)];
        label.text = titleArray[i];
        label.font = Font(12 * WideEachUnit);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [kinsOfView addSubview:label];
        
        if (i == 0) {
            if ([_teacherDic[@"teacher_age"] isEqual:[NSNull null]] || _teacherDic[@"label"] == nil) {
                label.text = @"教龄";
            }
        } else if (i == 1) {
            if ([_teacherDic[@"video_count"] isEqual:[NSNull null]] || _teacherDic[@"label"] == nil) {
                label.text = @"课程";
            }
        } else if (i == 2) {
            if ([_teacherDic[@"ext_info"][@"count_info"][@"follower_count"] isEqual:[NSNull null]] || _teacherDic[@"label"] == nil) {
                label.text = @"关注";
            }
        }
    }

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5 * WideEachUnit, 20 * WideEachUnit, 40 * WideEachUnit, 40 * WideEachUnit)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [_infoView addSubview:backButton];
    
    
    //最终确定infoView 的位置
//    _infoView.frame = CGRectMake(0, 0, MainScreenWidth, CGRectGetMaxY(kinsOfView.frame));
    //重新添加背景 不然会变形
    _imageView.frame = CGRectStandardize(_infoView.frame);

}




#pragma mark -- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segleMentView.frame) + 10 * WideEachUnit,  MainScreenWidth, MainScreenHeight * 30 + 500 * WideEachUnit)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 3,0);
    [_allScrollView addSubview:_controllerSrcollView];
    
    TeacherHomeViewController *teacherHomeVc= [[TeacherHomeViewController alloc] initWithNumID:_ID];
    teacherHomeVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    [self addChildViewController:teacherHomeVc];
    [_controllerSrcollView addSubview:teacherHomeVc.view];
    
    TeacherClassViewController * classVc = [[TeacherClassViewController alloc] initWithNumID:_ID];
    classVc.view.frame = CGRectMake(MainScreenWidth * 1, 0, MainScreenWidth, MainScreenHeight * 20 + 500 * WideEachUnit);
    [self addChildViewController:classVc];
    [_controllerSrcollView addSubview:classVc.view];
    
    
    TeacherCommentViewController * teacherCommentVc = [[TeacherCommentViewController alloc] initWithNumID:_ID];
    teacherCommentVc.view.frame = CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight * 2 + 500 * WideEachUnit);
    [self addChildViewController:teacherCommentVc];
    [_controllerSrcollView addSubview:teacherCommentVc.view];
    if (@available(iOS 11.0, *)) {
        _controllerSrcollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_infoView.frame), MainScreenWidth, 50 * WideEachUnit)];
    WZView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:WZView];
    _segleMentView = WZView;
    
    
//    NSArray *titleArray = @[@"简介",@"课程",@"点评"];
//    _mainSegment = [[UISegmentedControl alloc] initWithItems:titleArray];
//    _mainSegment.frame = CGRectMake(2 * SpaceBaside * WideEachUnit,SpaceBaside * WideEachUnit,MainScreenWidth - 4 * SpaceBaside * WideEachUnit, 30 * WideEachUnit);
//    _mainSegment.selectedSegmentIndex = 0;
//    [_mainSegment setTintColor:[UIColor colorWithRed:32.f / 255 green:105.f / 255 blue:207.f / 255 alpha:1]];
//    [_mainSegment addTarget:self action:@selector(mainChange:) forControlEvents:UIControlEventValueChanged];
//    [WZView addSubview:_mainSegment];
    
    NSArray *segmentedArray = @[@"简介",@"课程",@"点评"];
    _mainSegment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _mainSegment.frame = CGRectMake(0,SpaceBaside,MainScreenWidth, 30 * WideEachUnit);
    
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
//    basidFrame = CGRectGetMaxY(_mainSegment.frame);
    
//    basidFrame = CGRectGetMaxY(_mainSegment.frame);
    
}

- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50 * WideEachUnit , MainScreenWidth, 50 * WideEachUnit)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:lineButton];
    
    
    CGFloat ButtonW = MainScreenWidth / 2;
//    buttonW = ButtonW;
    CGFloat ButtonH = 30 * WideEachUnit;
    
    NSArray *title = @[@"关注",@"私信"];
    NSArray *image = @[@"机构关注@2x",@"机构信息@2x"];
    if ([_teacherDic[@"follow_state"][@"following"] integerValue] == 0) {
        image = @[@"icon_focus@3x",@"icon_message@3x"];
        title = @[@"关注",@"私信"];
    } else {
        image = @[@"机构关注@2x",@"icon_message@3x"];
        title = @[@"已关注",@"私信"];
    }
    
    for (int i = 0 ; i < title.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * ButtonW, SpaceBaside, ButtonW, ButtonH)];
        [button setTitle:title[i] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        [button setImage:Image(image[i]) forState:UIControlStateNormal];
        button.titleLabel.font = Font(14 * WideEachUnit);
        button.tag = i * 1000;
        [button addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
        
        if (i == 0) {
            _attentionButton = button;
        } else if (i == 2) {
            button.backgroundColor = BasidColor;
            button.frame = CGRectMake(2 * ButtonW, 0, ButtonW, 50 * WideEachUnit);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = Font(16 * WideEachUnit);
        }
        
    }
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 0.5, 17, 1, 16)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:button];
    
}


#pragma mark --- 滚动试图

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentCrorX = _controllerSrcollView.contentOffset.x;
    CGFloat contentCrorY = _controllerSrcollView.contentOffset.y;
    
    
    if (contentCrorX < MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 0;
        _allScrollView.contentSize = CGSizeMake(0 , [_oneHightStr floatValue] + CGRectGetMaxY(_infoView.frame) + 50 * WideEachUnit);
    }
    else if (contentCrorX < 2 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 1;
        _allScrollView.contentSize = CGSizeMake(0 , [_twoHightStr floatValue] + CGRectGetMaxY(_infoView.frame) + 50 * WideEachUnit);
        
        
        
    }  else if (contentCrorX < 3 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 2;
        _allScrollView.contentSize = CGSizeMake(0 , [_fourHightStr floatValue] + 270 * WideEachUnit);
    }
    
}


- (void)mainChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            _allScrollView.contentSize = CGSizeMake(0 , 1000);
            _allScrollView.contentSize = CGSizeMake(0 , [_oneHightStr floatValue] + CGRectGetMaxY(_infoView.frame) + 50 * WideEachUnit);
            break;
        case 1:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 1, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0 , [_twoHightStr floatValue] + CGRectGetMaxY(_infoView.frame) + 50 * WideEachUnit);
            break;
        case 2:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0 , [_fourHightStr floatValue] + 270 * WideEachUnit);
            break;
        default:
            break;
    }
}

-(void)setIntroductionText:(NSString*)text{
    //文本赋值
    _teacherInfo.text = text;
    //设置label的最大行数
    _teacherInfo.numberOfLines = 0;
    if ([_teacherInfo.text isEqual:[NSNull null]]) {
        _teacherInfo.frame = CGRectMake(50 * WideEachUnit,130 * WideEachUnit,MainScreenWidth - 100 * WideEachUnit,30 * WideEachUnit);
        return;
    }
    
    CGRect labelSize = [_teacherInfo.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 100 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil];
    
    _teacherInfo.frame = CGRectMake(50 * WideEachUnit,130 * WideEachUnit,MainScreenWidth - 100 * WideEachUnit,labelSize.size.height);
    
    //重新添加背景 不然会变形
    _imageView.frame = CGRectStandardize(_infoView.frame);

}


#pragma mark --- 通知
- (void)getHomeScrollHight:(NSNotification *)not {
    
    NSString *hightStr = not.object;
    _oneHightStr = hightStr;
    _controllerSrcollView.contentOffset = CGPointMake(0, 0);
    _allScrollView.contentSize = CGSizeMake(0 , 1000);
    _allScrollView.contentSize = CGSizeMake(0 , [_oneHightStr floatValue] + CGRectGetMaxY(_infoView.frame) + 50 * WideEachUnit + 500);
}

- (void)getCommentScrollHight:(NSNotification *)not {
    
    NSString *hightStr = not.object;
    _fourHightStr = hightStr;
    _allScrollView.contentSize = CGSizeMake(0 , [hightStr floatValue] + 270 * WideEachUnit);
    if (_mainSegment.selectedSegmentIndex == 0) {
        _allScrollView.contentSize = CGSizeMake(0 , [_oneHightStr floatValue] + 270 * WideEachUnit);
    }
}
- (void)getTeacherClassScrollFrame:(NSNotification *)not {
    NSDictionary *dict = (NSDictionary *)not.userInfo;
    _twoHightStr = [dict stringValueForKey:@"frame"];
    _allScrollView.contentSize = CGSizeMake(0 , [_twoHightStr floatValue] + 270 * WideEachUnit);
    if (_mainSegment.selectedSegmentIndex == 0) {
        _allScrollView.contentSize = CGSizeMake(0 , [_oneHightStr floatValue] + 270 * WideEachUnit);
    }
}

- (void)getHomeMoreButtonCilck:(NSNotification *)not {
    NSLog(@"%@",not.object);
    _homeMoreButtonSet = (NSString *)not.object;
    
    if ([_homeMoreButtonSet integerValue] == 2) {
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
        _mainSegment.selectedSegmentIndex = 1;
        _allScrollView.contentOffset = CGPointMake(0, 0);
    } else if ([_homeMoreButtonSet integerValue] == 3) {
        _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
        _mainSegment.selectedSegmentIndex = 2;
        _allScrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)getHomeMovePhotoCilck:(NSNotification *)not {
    _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth, 0);
    _mainSegment.selectedSegmentIndex = 1;
    _allScrollView.contentOffset = CGPointMake(0, 0);
}

#pragma mark ---- 时间监听

- (void)downButtonClick:(UIButton *)button {
    switch (button.tag) {
        case 0:
            if (UserOathToken == nil) {
                DLViewController *DLVC = [[DLViewController alloc] init];
                UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
                [self.navigationController presentViewController:Nav animated:YES completion:nil];
                return;
            }
            if ([button.titleLabel.text isEqualToString:@"关注"]) {
                [self netWorkUseFollow];
            } else {
                [self netWorkUseUnFollow];
            }
            break;
        case 1000:
            [self gotoSendMessage];
            break;
        case 2000:
            [self gotoSubscribe];
            break;
        default:
            break;
    }
}

- (void)attentionButtonButtonCilck {
    if (UserOathToken == nil) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if ([_following integerValue] == 0) {
        [self netWorkUseFollow];
    } else {
        [self netWorkUseUnFollow];
    }
}

- (void)gotoSendMessage {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    MessageSendViewController *MSVC = [[MessageSendViewController alloc] init];
    MSVC.TID = _uID;
    MSVC.name = _nameStr;
    NSLog(@"--%@",_nameStr);
    [self.navigationController pushViewController:MSVC animated:YES];
    
}

- (void)gotoSubscribe {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"oauthToken"] == nil) {//没有登录的情况下
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    YYViewController *YY = [[YYViewController alloc]init];
    YY.TID = _ID;
    YY.name = _nameStr;
    YY.lineonPrice = [NSString stringWithFormat:@"%@",[_teacherDic stringValueForKey:@"online_price"]];
    YY.lineoffprice = [NSString stringWithFormat:@"%@",[_teacherDic stringValueForKey:@"offline_price"]];
    [self.navigationController pushViewController:YY animated:YES];
    
}


#pragma mark ---网络请求
//获取讲师详情
- (void)netWorkTeacherGetInfo {
    
    NSString *endUrlStr = YunKeTang_Teacher_teacher_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"teacher_id"];
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
        _teacherDic = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        NSLog(@"讲师详情---%@",_teacherDic);
        _following = [NSString stringWithFormat:@"%@",[[[_teacherDic dictionaryValueForKey:@"ext_info"] dictionaryValueForKey:@"follow_state"] stringValueForKey:@"following"]];
        _uID = [_teacherDic stringValueForKey:@"uid"];
        
        if ([_following isEqualToString:@"0"]) {
            [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        }else{
            [_attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        }
        [self addInfoView];
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
    [mutabDict setValue:_uID forKey:@"user_id"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"User_id"];
    if ([userID isEqualToString:_uID]) {//说明是自己
        [MBProgressHUD showError:@"不能关注自己" toView:self.view];
        return;
    }
    
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
            [MBProgressHUD showSuccess:@"关注成功" toView:self.view];
            [_attentionButton setTitle:@"取消关注" forState:UIControlStateNormal];
            _following = @"1";
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
    if ([userID isEqualToString:_uID]) {//说明是自己
        [MBProgressHUD showError:@"不能关注自己" toView:self.view];
        return;
    }
    
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
            [MBProgressHUD showSuccess:@"取消关注成功" toView:self.view];
            [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
            _following = @"0";
            return ;
        } else {
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



@end
