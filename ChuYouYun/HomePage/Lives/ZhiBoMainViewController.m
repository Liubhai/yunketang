//
//  ZhiBoMainViewController.m
//  dafengche
//
//  Created by 赛新科技 on 2017/5/20.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ZhiBoMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"


#import "DLViewController.h"
#import "Good_ZhiBoDetailViewController.h"
#import "ZhiBoClassViewController.h"
#import "LiveDetailCommentViewController.h"

#import "ClassAndLivePayViewController.h"


@interface ZhiBoMainViewController ()<UIScrollViewDelegate,UMSocialUIDelegate,UIWebViewDelegate> {
    UIImageView  *shareImageView;
    NSString     *shareUrl;
}

@property (strong ,nonatomic)UIScrollView *controllerSrcollView;
@property (strong ,nonatomic)UIScrollView *allScrollView;
@property (strong ,nonatomic)UIView       *navgationView;
@property (strong ,nonatomic)UILabel      *navgationTitle;
@property (strong ,nonatomic)UIImageView  *imageView;
@property (strong ,nonatomic)UIView   *mainDetailView;
@property (strong ,nonatomic)UILabel  *classTitle;
@property (strong ,nonatomic)UILabel  *studyNumber;

@property (strong ,nonatomic)UISegmentedControl *mainSegment;
@property (strong ,nonatomic)UIButton *zhiBoLikeButton;
@property (strong ,nonatomic)UIButton *buyButton;
@property (strong ,nonatomic)UIButton *priceButton;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UIView *WZView;
@property (strong ,nonatomic)UIView   *allWindowView;

@property (strong ,nonatomic)NSString *ID;
@property (strong ,nonatomic)NSString *zhiBoTitle;
@property (strong ,nonatomic)NSString *imageUrl;
@property (strong ,nonatomic)NSDictionary *zhiBoDic;
@property (strong ,nonatomic)NSString *collectStr;
@property (strong ,nonatomic)NSArray  *subVcArray;

@property (strong ,nonatomic)NSString *videoUrl;
@property (strong ,nonatomic)NSString *shareLiveUrl;

@property (assign ,nonatomic)CGFloat  detailScrollHight;
@property (assign ,nonatomic)CGFloat  classScrollHight;
@property (assign ,nonatomic)CGFloat  commentScrollHight;

@property (strong ,nonatomic)UILabel         *priceLabel;
@property (strong ,nonatomic)UILabel         *ordPrice;



@end

@implementation ZhiBoMainViewController

-(id)initWithMemberId:(NSString *)MemberId andImage:(NSString *)imgUrl andTitle:(NSString *)title andNum:(int)num andprice:(NSString *)price
{
    if (self=[super init]) {
        _ID = MemberId;
        _zhiBoTitle = title;
        _imageUrl = imgUrl;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self netWorkLiveGetInfo];
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
    [self getNSNotification];
    [self addAllScrollView];
    [self addImageView];
    [self addMainDetailView];
    [self addTitleView];
    [self addControllerSrcollView];
    [self addDownView];
    [self addNav];
    [self netWorkLiveGetInfo];
}

- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [shareImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:Image(@"站位图")];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = [UIColor clearColor];
    [_allScrollView addSubview:SYGView];
    _navgationView = SYGView;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, NavigationBarSubViewHeight, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, NavigationBarSubViewHeight, MainScreenWidth - 100, 30)];
    WZLabel.text = _zhiBoTitle;
//    WZLabel.text = @"";
    [WZLabel setTextColor:[UIColor whiteColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    _navgationTitle = WZLabel;
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 20, 50, 30)];
//    [moreButton setImage:[UIImage imageNamed:@"ico_more@3x"] forState:UIControlStateNormal];
    [moreButton setTitle:@"..." forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    [moreButton addTarget:self action:@selector(moreButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:moreButton];
}


#pragma mark --- 接收通知
- (void)getNSNotification {
    //直播主页滚动的范围
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDetailScrollHight:) name:@"Good_LiveDetailScrollHight" object:nil];
}

#pragma mark --- 添加全局的滚动视图
- (void)addAllScrollView {
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreenWidth, MainScreenHeight - 50 * WideEachUnit)];
    //    _allScrollView.pagingEnabled = YES;
    _allScrollView.delegate = self;
    _allScrollView.bounces = YES;
    _allScrollView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _allScrollView.contentSize = CGSizeMake(0, MainScreenHeight * 3);
    [self.view addSubview:_allScrollView];
}

#pragma mark --- 添加图片视图
- (void)addImageView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 200 * WideEachUnit)];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:Image(@"站位图")];
    [_allScrollView addSubview:_imageView];
}

- (void)addMainDetailView {
    _mainDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 210 * WideEachUnit, MainScreenWidth, 70 * WideEachUnit)];
    _mainDetailView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:_mainDetailView];
    
    //添加课程名字
    UILabel *classTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit)];
    classTitle.textColor = [UIColor colorWithHexString:@"#333"];
    classTitle.font = Font(18);
    classTitle.backgroundColor = [UIColor whiteColor];
    [_mainDetailView addSubview:classTitle];
    _classTitle = classTitle;
    
    //添加学习人数
    UILabel *studyNumber = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 40 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit)];
    studyNumber.textColor = [UIColor colorWithHexString:@"#888"];
    studyNumber.font = Font(15);
    [_mainDetailView addSubview:studyNumber];
    _studyNumber = studyNumber;
    
    //添加价格
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 80 * WideEachUnit, 40 * WideEachUnit, 70 * WideEachUnit, 20 * WideEachUnit)];
    priceLabel.textColor = [UIColor colorWithHexString:@"#f01414"];
    priceLabel.font = Font(16);
    priceLabel.textAlignment = NSTextAlignmentRight;
    [_mainDetailView addSubview:priceLabel];
    _priceLabel = priceLabel;
    
    //隔离带
    UIButton *mainLineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 70 * WideEachUnit, MainScreenWidth, 10 * WideEachUnit)];
    mainLineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_mainDetailView addSubview:mainLineButton];
    
}


#pragma mark --- 添加分类
- (void)addTitleView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mainDetailView.frame) + 10 * WideEachUnit , MainScreenWidth, 50)];
    WZView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:WZView];
    _WZView = WZView;
    
    NSArray *segmentedArray = @[@"详情",@"课程",@"点评"];
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
//    _mainSegment.momentary = NO;
    [_mainSegment addTarget:self action:@selector(mainChange:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark --- 添加底部的视图
- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit)];
    if (iPhoneX) {
        _downView.frame = CGRectMake(0, MainScreenHeight - 83, MainScreenWidth, 83);
    }
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:lineButton];

    CGFloat ButtonW = MainScreenWidth / 5;
    CGFloat ButtonH = 50 * WideEachUnit;

    NSArray *titleArray = @[[NSString stringWithFormat:@"¥ %@",[_zhiBoDic stringValueForKey:@""]],@"立即购买"];
    for (int i = 0 ; i < titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * ButtonW, SpaceBaside, ButtonW, ButtonH)];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.titleLabel.font = Font(14 * WideEachUnit);
        button.tag = i;
        [button addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
        
        if (i == 0) {
            button.frame = CGRectMake(0, 0, ButtonW * 2, ButtonH / 2);
            [button setTitleColor:[UIColor colorWithHexString:@"#f01414"] forState:UIControlStateNormal];
            button.titleLabel.font = Font(14 * WideEachUnit);
            _priceButton = button;
        } else if (i == 1) {
            button.backgroundColor = BasidColor;
            button.frame = CGRectMake(2 * ButtonW, 0, ButtonW * 3, ButtonH);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = Font(16 * WideEachUnit);
            [button setTitleColor:[UIColor colorWithHexString:@"#fff"] forState:UIControlStateNormal];
            _buyButton = button;
        }
    }
    
    //添加原价
    UILabel *ordPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, ButtonH / 2, ButtonW * 2, ButtonH / 2)];
    ordPrice.textAlignment = NSTextAlignmentCenter;
    ordPrice.textColor = [UIColor colorWithHexString:@"#888"];
    ordPrice.font = Font(14 * WideEachUnit);
    [_downView addSubview:ordPrice];
    _ordPrice = ordPrice;
    
    //原价
    [self ordPriceDeal];
}


#pragma mark --- 原价处理
- (void)ordPriceDeal {
    
    _ordPrice.text = [NSString stringWithFormat:@"￥%@",[_zhiBoDic stringValueForKey:@"v_price"]];
    _ordPrice.textAlignment = NSTextAlignmentCenter;
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_ordPrice.text attributes:attribtDic];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attribtStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_ordPrice.text length])];
    
    // 赋值
    _ordPrice.attributedText = attribtStr;
    
    
    //    //ios 10上不显示横线处理
    //    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //    if ([phoneVersion integerValue] >= 10) {
    //        NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //        if ([phoneVersion integerValue] >= 10) {
    //            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:_ordPrice.text];
    //            [attribtStr setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], 　　NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, _ordPrice.text.length)];
    //            　　_ordPrice.attributedText = attribtStr;
    //        }
    //    }
    
}


#pragma mark --- 添加控制器

- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_WZView.frame),  MainScreenWidth, MainScreenHeight * 30 + 500)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 3,0);
    [_allScrollView addSubview:_controllerSrcollView];
    
    Good_ZhiBoDetailViewController *zhiBoDetailVc= [[Good_ZhiBoDetailViewController alloc] initWithNumID:_ID WithOrderSwitch:_order_switch];
    zhiBoDetailVc.view.frame = CGRectMake(0, 10, MainScreenWidth, MainScreenHeight * 30);
    [self addChildViewController:zhiBoDetailVc];
    [_controllerSrcollView addSubview:zhiBoDetailVc.view];
    
    ZhiBoClassViewController * zhiBoClassVc = [[ZhiBoClassViewController alloc] initWithNumID:_ID];
    zhiBoClassVc.view.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, MainScreenHeight * 2 + 500);
    [self addChildViewController:zhiBoClassVc];
    [_controllerSrcollView addSubview:zhiBoClassVc.view];
    
     LiveDetailCommentViewController *zhiBoCommentVc = [[LiveDetailCommentViewController alloc] initWithNumID:_ID];
     zhiBoCommentVc.view.frame = CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight * 2 + 500);
     [self addChildViewController:zhiBoCommentVc];
     [_controllerSrcollView addSubview:zhiBoCommentVc.view];

    _subVcArray = @[zhiBoDetailVc,zhiBoClassVc,zhiBoCommentVc];
    
    [self addDetailBlock];
    [self addClassViewBlock];
    [self addCommentViewBlock];
}

#pragma mark --- 添加Bolck

- (void)addDetailBlock {//注意（因为是第一个 所以要在得到的时候就设定滚动的范围 不然会卡住）
    Good_ZhiBoDetailViewController *vc = _subVcArray[0];
    vc.detailScroll = ^(CGFloat hight) {
        _detailScrollHight = hight;
        _allScrollView.contentSize = CGSizeMake(MainScreenWidth, _detailScrollHight + 370 * WideEachUnit);
        if (iPhoneX) {
            _allScrollView.contentSize = CGSizeMake(MainScreenWidth, _detailScrollHight + 470 * WideEachUnit);
        }
    };
}

- (void)addClassViewBlock {
    ZhiBoClassViewController *vc = _subVcArray[1];
    vc.vcHight = ^(CGFloat hight) {
        _classScrollHight = hight;
    };
}

- (void)addCommentViewBlock {
    LiveDetailCommentViewController *vc = _subVcArray[2];
    vc.getCommentHight = ^(CGFloat commentHight) {
        _commentScrollHight = commentHight;
    };
}

#pragma mark --- 分段

- (void)mainChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
            _allScrollView.contentSize = CGSizeMake(MainScreenWidth, _detailScrollHight + 300 * WideEachUnit);
            break;
        case 1:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth,0);
            _mainSegment.selectedSegmentIndex = 1;
            _allScrollView.contentSize = CGSizeMake(0 , _classScrollHight + CGRectGetMaxY(_WZView.frame));
            break;
        case 2:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            break;
            
        default:
            break;
    }
    
}

#pragma mark --- 滚动试图

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentCrorX = _controllerSrcollView.contentOffset.x;
    if (contentCrorX < MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 0;
        _allScrollView.contentSize = CGSizeMake(0 , _detailScrollHight + 410 * WideEachUnit);
        if (iPhoneX) {
             _allScrollView.contentSize = CGSizeMake(0 , _detailScrollHight + 580 * WideEachUnit);
        }
    } else if (contentCrorX < 2 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 1;
        _allScrollView.contentSize = CGSizeMake(0 , _classScrollHight + CGRectGetMaxY(_mainDetailView.frame) + 170 * WideEachUnit);
    } else if (contentCrorX < 3 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 2;
        _allScrollView.contentSize = CGSizeMake(0 , _commentScrollHight + 400 * WideEachUnit);
    }
    
    
    
    //设置顶部滚动的导航栏
    CGFloat contentCrorY = _allScrollView.contentOffset.y;
//    scrollContentY = contentCrorY;
    NSLog(@"Y----%lf",contentCrorY);
    NSLog(@"----%lf",CGRectGetMaxY(_mainDetailView.frame));
    if (contentCrorY > CGRectGetMaxY(_mainDetailView.frame)) {//出现
        _navgationView.backgroundColor = BasidColor;
        _navgationTitle.textColor = [UIColor whiteColor];
        [_allScrollView bringSubviewToFront:_navgationView];
        _navgationView.frame = CGRectMake(0, contentCrorY, MainScreenWidth, 64);
        _WZView.frame = CGRectMake(0, contentCrorY + 64, MainScreenWidth, 50 * WideEachUnit);
        [_allScrollView bringSubviewToFront:_WZView];
    } else {
        _navgationView.backgroundColor = [UIColor clearColor];
        _navgationTitle.textColor = [UIColor clearColor];
        _navgationView.frame = CGRectMake(0, 0, MainScreenWidth, 64);
        _WZView.frame = CGRectMake(0,CGRectGetMaxY(_mainDetailView.frame) + 10 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit);
        [_allScrollView bringSubviewToFront:_WZView];
    }
}

#pragma mark --- 事件监听
- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButtonCilck {
    
    UIView *allWindowView = [[UIView alloc] initWithFrame:CGRectMake(0,0, MainScreenWidth, MainScreenHeight)];
    allWindowView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    allWindowView.layer.masksToBounds =YES;
    [allWindowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allWindowViewClick:)]];
    //获取当前UIWindow 并添加一个视图
    UIApplication *app = [UIApplication sharedApplication];
    [app.keyWindow addSubview:allWindowView];
    //    [app.keyWindow makeKeyAndVisible];
    _allWindowView = allWindowView;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 120 * WideEachUnit,55 * WideEachUnit,100 * WideEachUnit,67 * WideEachUnit)];
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    
    NSArray *imageArray = @[@"ico_collect@3x",@"class_share"];
    NSArray *titleArray = @[@"+收藏",@"分享"];
    if ([_collectStr integerValue] == 1) {
        imageArray = @[@"ic_collect_press@3x",@"class_share",@"class_down"];
        titleArray = @[@"-收藏",@"分享"];
    }
    CGFloat ButtonW = 100 * WideEachUnit;
    CGFloat ButtonH = 33 * WideEachUnit;
    for (int i = 0 ; i < 2 ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0 * WideEachUnit, ButtonH * i, ButtonW, ButtonH)];
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#333"] forState:UIControlStateNormal];
        button.titleLabel.font = Font(14);
        [button setImage:Image(imageArray[i]) forState:UIControlStateNormal];
        button.imageEdgeInsets =  UIEdgeInsetsMake(0,0,0,20 * WideEachUnit);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 20 * WideEachUnit, 0, 0);
        [button addTarget:self action:@selector(buttonCilck:) forControlEvents:UIControlEventTouchUpInside];
        [moreView addSubview:button];
    }
    
}

- (void)buttonCilck:(UIButton *)button {
    if (button.tag == 0) {//收藏
        if (UserOathToken == nil) {
            [_allWindowView removeFromSuperview];
            DLViewController *DLVC = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        } else {
            [self netWorkVideoCollect];
        }
    } else if (button.tag == 1) {//分享
        [self netWorkVideoGetShareUrl];
    }
    [_allWindowView removeFromSuperview];
}

- (void)SYGCollect {
    
    QKHTTPManager * manager = [QKHTTPManager manager];
    if ([_collectStr intValue]==1) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"2" forKey:@"sctype"];
        [dic setValue:@"0" forKey:@"type"];
        [dic setValue:_ID forKey:@"source_id"];
        if (UserOathToken != nil) {
            [dic setObject:UserOathToken forKey:@"oauth_token"];
            [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
        } else {
            [MBProgressHUD showError:@"请先登陆" toView:self.view];
            return;
        }
        
        [manager collectLive:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
            [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
            _collectStr = @"0";
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"取消收藏失败" toView:self.view];
        }];
    }else if ([_collectStr intValue]==0){
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        [dic setValue:@"2" forKey:@"sctype"];
        [dic setValue:@"1" forKey:@"type"];
        [dic setValue:_ID forKey:@"source_id"];
        [dic setObject:UserOathToken forKey:@"oauth_token"];
        [dic setObject:UserOathTokenSecret forKey:@"oauth_token_secret"];
        
        [manager collectLive:dic success:^(AFHTTPRequestOperation *operation, id responseObject){
            [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"实心五角星@2x"] forState:UIControlStateNormal];
            [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
            _collectStr = @"1";
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"收藏失败" toView:self.view];
        }];
    }
}



- (void)downButtonClick:(UIButton *)button {
    
    if (button.tag == 0) {//价格
    } else if (button.tag == 1) {//购买
        if ([_buyButton.titleLabel.text isEqualToString:@"立即购买"]) {
            if (UserOathToken == nil) {
                DLViewController *DLVC = [[DLViewController alloc] init];
                UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
                [self.navigationController presentViewController:Nav animated:YES completion:nil];
                return;
            } else {
                ClassAndLivePayViewController *payVc = [[ClassAndLivePayViewController alloc] init];
                payVc.dict = _zhiBoDic;
                payVc.cid = _ID;
                payVc.typeStr = @"2";
                [self.navigationController pushViewController:payVc animated:YES];
            }
        } else if ([_buyButton.titleLabel.text isEqualToString:@"已购买"]) {
            [MBProgressHUD showError:@"已经购买过了" toView:self.view];
            return;
        }
    }
}

- (void)LiveShare {
//    NSString *shareUrl = [NSString stringWithFormat:@"http://www.igenwoxue.com/index.php?app=live&mod=Index&act=view&id=%@",_ID];
    
//    NSString *str1 = @"app=live&mod=Index&act=view&id=";
//    NSString *str2 = [NSString stringWithFormat:@"%@%@",str1,_ID];
//    NSString *shareUrl = [NSString stringWithFormat:@"%@%@",basidUrl,str2];
    
    [UMSocialWechatHandler setWXAppId:@"wxbbb961a0b0bf577a" appSecret:@"eb43d9bc799c4f227eb3a56224dccc88" url:shareUrl];
    [UMSocialQQHandler setQQWithAppId:@"1105368823" appKey:@"Q6Q6hJa2Cs8EqtLt" url:_shareLiveUrl];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3997129963" secret:@"da07bcf6c9f30281e684f8abfd0b4fca" RedirectURL:_shareLiveUrl];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"574e8829e0f55a12f8001790"
                                      shareText:_zhiBoTitle
                                     shareImage:shareImageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
    
}

#pragma mark --- 通知
- (void)getDetailScrollHight:(NSNotification *)not {
    NSString *detailSrollHightStr = (NSString *)not.object;
    CGFloat detailSrollHight = [detailSrollHightStr floatValue];
    _detailScrollHight = detailSrollHight;
    _allScrollView.contentSize = CGSizeMake(MainScreenWidth, detailSrollHight + 300 * WideEachUnit);
    if (iPhoneX) {
        _allScrollView.contentSize = CGSizeMake(MainScreenWidth, detailSrollHight + 300 * WideEachUnit + 100 * WideEachUnit);
    }
}

#pragma mark --- 手势添加

- (void)allWindowViewClick:(UITapGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

#pragma mark --- 网络请求
//直播详情
- (void)netWorkLiveGetInfo {
    
    NSString *endUrlStr = YunKeTang_Live_live_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"live_id"];
    
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
            if ([[dict dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _zhiBoDic = [dict dictionaryValueForKey:@"data"];
            } else {
                _zhiBoDic = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        if ([_zhiBoDic isEqual:[NSArray array]]) {
            return ;
        }
        [self netWorkLiveGetInfo_After];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


#pragma mark --- 网络请求的背后配置
- (void)netWorkLiveGetInfo_After {
    _videoUrl = [_zhiBoDic stringValueForKey:@"cover"];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_videoUrl]];
    _collectStr = [NSString stringWithFormat:@"%@",[_zhiBoDic stringValueForKey:@"is_collect"]];
    
    if ([_collectStr integerValue] == 0) {
        [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
    }else{
        [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"实心五角星@2x"] forState:UIControlStateNormal];
    }
    
    _classTitle.text = [_zhiBoDic stringValueForKey:@"video_title"];
    _studyNumber.text = [NSString stringWithFormat:@"在学%@人",[_zhiBoDic stringValueForKey:@"video_order_count"]];
    if ([_order_switch integerValue] == 1) {
        _studyNumber.text = [NSString stringWithFormat:@"在学%@人",[_zhiBoDic stringValueForKey:@"video_order_count_mark"]];
    }
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",[_zhiBoDic stringValueForKey:@"price"]];
    if ([[_zhiBoDic stringValueForKey:@"price"] floatValue] == 0) {
        _priceLabel.text = @"免费";
        _priceLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
    }
    
    NSString *moneyStr = [_zhiBoDic stringValueForKey:@"price"];
    if ([moneyStr integerValue] == 0) {
        [_priceButton setTitle:@"免费" forState:UIControlStateNormal];
        [_priceButton setTitleColor:[UIColor colorWithHexString:@"#47b37d"] forState:UIControlStateNormal];
    } else {
        [_priceButton setTitle:[NSString stringWithFormat:@"¥ %@",moneyStr] forState:UIControlStateNormal];
    }
    
    NSString *numstr = [NSString stringWithFormat:@"%@",[_zhiBoDic stringValueForKey:@"is_buy"]];
    if ([numstr isEqualToString:@"1"]) {
        [_buyButton setTitle:@"已购买" forState:UIControlStateNormal];
    }
    [self ordPriceDeal];//处理原价
}


//课程收藏
- (void)netWorkVideoCollect {
    
    NSString *endUrlStr = YunKeTang_Video_video_collect;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setValue:@"2" forKey:@"sctype"];
    if ([_collectStr integerValue] == 1) {//已经收藏（为取消收藏操作）
        [mutabDict setValue:@"0" forKey:@"type"];
    } else {//没有收藏 （为收藏操作）
        [mutabDict setValue:@"1" forKey:@"type"];
    }
    [mutabDict setValue:_ID forKey:@"source_id"];
    
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
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            if ([_collectStr integerValue] == 1) {
                _collectStr = @"0";
                [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"空心五角星@2x"] forState:UIControlStateNormal];
            } else {
                _collectStr = @"1";
                [_zhiBoLikeButton setBackgroundImage:[UIImage imageNamed:@"实心五角星@2x"] forState:UIControlStateNormal];
            }
        } else {
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取课程分享的链接
- (void)netWorkVideoGetShareUrl {
    
    NSString *endUrlStr = YunKeTang_Video_video_getShareUrl;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"2" forKey:@"type"];
    [mutabDict setObject:_ID forKey:@"vid"];
    if (_schoolID) {
        [mutabDict setObject:_schoolID forKey:@"mhm_id"];
    }
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _shareLiveUrl = [dict stringValueForKey:@"share_url"];
            [self LiveShare];
        } else {
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}



@end
