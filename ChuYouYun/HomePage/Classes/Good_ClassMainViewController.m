//
//  Good_ClassMainViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/10.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_ClassMainViewController.h"
#import "rootViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "BigWindCar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "MyHttpRequest.h"
#import "ZhiyiHTTPRequest.h"
#import "ZFDownloadManager.h"
#import "ZFDownloadingCell.h"
#import "ZFDownloadedCell.h"

#import "WMPlayer.h"

#import "Good_ClassDetailViewController.h"
#import "Good_ClassCatalogViewController.h"
#import "Good_ClassCommentViewController.h"
#import "Good_ClassServiceViewController.h"
#import "Good_ClassDownViewController.h"
#import "DLViewController.h"
#import "ClassAndLivePayViewController.h"
#import "ClassNeedTestViewController.h"
#import "VideoMarqueeViewController.h"
#import "Good_ClassNotesViewController.h"
#import "Good_ClassAskQuestionsViewController.h"
#import "TestCurrentViewController.h"


#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"


#import <AliyunPlayerSDK/AliVcMediaPlayer.h>
#import <AliyunVodPlayerSDK/AliyunVodDownLoadManager.h>
#import "AliyunVodPlayerView.h"

#import <BCEDocumentReader/BCEDocumentReader.h>





@import MediaPlayer;
@interface Good_ClassMainViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,UMSocialUIDelegate,AliyunVodPlayerViewDelegate,BCEDocumentReaderDelegate> {
    CGRect   playerFrame;
    WMPlayer *wmPlayer;
    BOOL     isShouleVedio;//是否应该缓存视频
    BOOL     isWebViewBig;//文档 是否放大
    BOOL     isTextViewBig;//文本视图放大
    BOOL     isVideoExit;
    BOOL     isExitTestView;
    CGFloat  detailSrollHight;
    CGFloat  catalogScrollHight;
    CGFloat  commentScrollHight;
    CGFloat  notesScrollHight;
    CGFloat  askScrollHight;
    CGFloat  scrollContentY;
}

@property (strong ,nonatomic)UIView   *navigationView;
@property (strong ,nonatomic)UIView   *videoView;//视频的地方
@property (strong ,nonatomic)UIView   *mainDetailView;
@property (strong ,nonatomic)UILabel  *videoTitleLabel;
@property (strong ,nonatomic)UILabel  *classTitle;
@property (strong ,nonatomic)UILabel  *studyNumber;

@property (strong ,nonatomic)UIScrollView *allScrollView;
@property (strong ,nonatomic)UIScrollView *controllerSrcollView;
@property (strong ,nonatomic)UIScrollView *classScrollView;
@property (strong ,nonatomic)UIImageView  *videoCoverImageView;
@property (strong ,nonatomic)UIImageView  *imageView;
@property (strong ,nonatomic)UISegmentedControl *mainSegment;
@property (strong ,nonatomic)UIView *segleMentView;
@property (strong ,nonatomic)UILabel *teacherInfo;
@property (strong ,nonatomic)UIView *downView;
@property (strong ,nonatomic)UIButton *attentionButton;
@property (strong ,nonatomic)UIButton *backButton;
@property (strong ,nonatomic)UIButton *moreButton;
@property (strong ,nonatomic)UIButton *buyButton;
@property (strong ,nonatomic)UIButton *playButton;
@property (strong ,nonatomic)UIView   *allWindowView;
@property (strong ,nonatomic)UIWindow *appWindow;
@property (strong ,nonatomic)UIImageView *shareImageView;

@property (strong ,nonatomic)UIWebView *webView;
@property (strong ,nonatomic)UITextView *textView;
@property (strong ,nonatomic)AVAudioPlayer *musicPlayer;

@property (strong ,nonatomic)NSDictionary  *videoDataSource;
@property (strong ,nonatomic)NSDictionary  *serviceDict;
@property (strong ,nonatomic)NSDictionary  *videoDict;
@property (strong ,nonatomic)NSDictionary  *notifitonDic;
@property (strong ,nonatomic)NSString      *shareVideoUrl;
@property (strong ,nonatomic)NSTimer       *timer;
@property (strong ,nonatomic)NSTimer       *popupTimer;
@property (strong ,nonatomic)NSString      *collectStr;
@property (strong ,nonatomic)NSString      *serviceOpen;

@property (assign, nonatomic)NSInteger       timeNum;
@property (strong ,nonatomic)NSArray         *subVcArray;
@property (strong ,nonatomic)UILabel         *priceLabel;
@property (strong ,nonatomic)UILabel         *ordPrice;

//配置是否登录能看免费课程
@property (strong ,nonatomic)NSString        *free_course_opt;
@property (assign ,nonatomic)NSInteger       popupTime;
@property (strong ,nonatomic)NSDictionary    *marqueeDict;
@property (strong ,nonatomic)NSString        *marqueeOpenStr;
//下载数据相关
@property (nonatomic, strong)ZFDownloadManager  *downloadManage;
@property (strong ,nonatomic)NSDictionary       *ailDownDict;
@property (strong ,nonatomic)NSDictionary       *seleCurrentDict;



@property (strong ,nonatomic)AliVcMediaPlayer   *mediaPlayer;
@property (nonatomic,strong, nullable)AliyunVodPlayerView *playerView;
//控制锁屏
@property (nonatomic, assign)BOOL isLock;
@property (nonatomic, assign)BOOL isStatusHidden;

//百度文档
@property (strong ,nonatomic)BCEDocumentReader   *reader;
@property (strong ,nonatomic)NSDictionary        *baiDuDocDict;

@end

@implementation Good_ClassMainViewController

#pragma mark --- 懒加载
//-(WMPlayer *)wmPlayer {//视频和音频视图
//    if (!_wmPlayer) {
//        _wmPlayer = [[WMPlayer alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit) videoURLStr:nil];
//        [_videoView addSubview:self.wmPlayer];
//    }
//    return _wmPlayer;
//}

-(UIWebView *)webView {//文档视图
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 30 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit,210 * WideEachUnit)];
    }
    return _webView;
}

-(UITextView *)textView {//文本视图
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 0 * WideEachUnit, MainScreenWidth - 0 * WideEachUnit,210 * WideEachUnit)];
    }
    return _textView;
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
    [self netWorkVideoGetInfo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = [AppDelegate delegate];
    rootViewController * nv = (rootViewController *)app.window.rootViewController;
    [nv isHiddenCustomTabBarByBoolean:NO];
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self releaseWMPlayer];//移除播放器
    [self AliPlayerDealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self interFace];
    [self addShareImageView];
    [self addNotification];
    [self addAllScrollView];
    [self addInfoView];
    [self addMainDetailView];
    [self addNav];
    [self addWZView];
    [self addControllerSrcollView];
//    [self addClassCatalogVcBolck];
//    [self addCommentVcBolck];
    [self addDownView];
    [self netWorkVideoGetInfo];
    [self netWorkVideoGetFreeTime];
//    [self netWorkConfigGetVideoKey];
    [self netWorkConfigFreeCourseLoginSwitch];
    [self netWorkGetThirdServiceUrl];
    [self netWorkVideoGetMarquee];
}

- (void)addNav {
    
    //添加view
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
    SYGView.backgroundColor = [UIColor clearColor];
    [_allScrollView addSubview:SYGView];
//    bringSubviewToFront
//    [SYGView bringSubviewToFront];
    SYGView.layer.zPosition = 10;
    _navigationView = SYGView;
    _navigationView.userInteractionEnabled = YES;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    _backButton = backButton;
    
    //添加中间的文字
    UILabel *WZLabel = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    WZLabel.text = _videoTitle;
    [WZLabel setTextColor:[UIColor clearColor]];
    WZLabel.textAlignment = NSTextAlignmentCenter;
    WZLabel.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:WZLabel];
    _videoTitleLabel = WZLabel;
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60, 20, 50, 30)];
//    [moreButton setImage:[UIImage imageNamed:@"ico_more@3x"] forState:UIControlStateNormal];
    [moreButton setTitle:@"..." forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    [moreButton addTarget:self action:@selector(moreButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:moreButton];
    _moreButton = moreButton;
    
}

- (void)interFace {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    isWebViewBig = NO;
    isTextViewBig = NO;
    isVideoExit = NO;
    isExitTestView = NO;
}

- (void)addShareImageView {
    _shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [_shareImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:Image(@"站位图")];
}
- (void)addNotification {
    
    
    //添加通知 (课程详情传过来)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDetailHight:) name:@"Good_ClassDetailHight" object:nil];
    //添加通知 (课程评论传过来)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCommentHight:) name:@"Good_ClassCommentHight" object:nil];
    
    //添加通知 (课程目录传过来)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVideoDataSource:) name:@"NotificationVideoDataSource" object:nil];
    
    //旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
    
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    //答题正确
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TheAnswerRight:) name:@"TheAnswerRight" object:nil];
    
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AilYunPlayerEnd:) name:@"AilYunPlayerPlayEnd" object:nil];
    
    
}

- (void)addAllScrollView {
    
    _allScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  MainScreenWidth * 10, MainScreenHeight - 50 * WideEachUnit)];
    //    _allScrollView.pagingEnabled = YES;
    _allScrollView.delegate = self;
    _allScrollView.bounces = YES;
    _allScrollView.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _allScrollView.contentSize = CGSizeMake(0, 10000);
    [self.view addSubview:_allScrollView];
    
}

- (void)addInfoView {
    
    _videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit)];
    _videoView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:_videoView];
    
    
    //背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_videoView.bounds];
    imageView.image = Image(@"视频播放2");
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:Image(@"站位图")];
    [_videoView addSubview:imageView];
    _videoCoverImageView = imageView;
    
    
    //添加提醒文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 80 * WideEachUnit, MainScreenWidth - 20 * WideEachUnit, 20 * WideEachUnit)];
    label.text = @"上次观看至哪里";
//    label.text = @"开始学习";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = Font(16 * WideEachUnit);
    label.textAlignment = NSTextAlignmentCenter;
    [_videoCoverImageView addSubview:label];
    label.hidden = YES;
    
    //添加按钮
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth / 2 - 60 * WideEachUnit, 110, 120 * WideEachUnit, 24 * WideEachUnit)];
    [_playButton setImage:Image(@"ico_start@3x") forState:UIControlStateNormal];
    _playButton.backgroundColor = [UIColor clearColor];
//    _playButton.center = _videoView.center;
    [_videoView addSubview:_playButton];
    _playButton.hidden = YES;
    
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
    
}

- (void)addWZView {
    UIView *WZView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mainDetailView.frame) + 10 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit)];
    WZView.backgroundColor = [UIColor whiteColor];
    [_allScrollView addSubview:WZView];
    _segleMentView = WZView;
    
//    NSArray *titleArray = @[@"详情",@"目录",@"点评"];
//    _mainSegment = [[UISegmentedControl alloc] initWithItems:titleArray];
//    _mainSegment.frame = CGRectMake(2 * SpaceBaside * WideEachUnit,SpaceBaside * WideEachUnit,MainScreenWidth - 4 * SpaceBaside * WideEachUnit, 30 * WideEachUnit);
//    _mainSegment.selectedSegmentIndex = 0;
//    [_mainSegment setTintColor:BasidColor];
//    [_mainSegment addTarget:self action:@selector(mainChange:) forControlEvents:UIControlEventValueChanged];
//    [WZView addSubview:_mainSegment];
    
    
    NSArray *segmentedArray = @[@"详情",@"目录",@"点评"];
    if ([_serviceOpen integerValue] == 1) {
//        segmentedArray = @[@"详情",@"目录",@"点评",@"客服"];
        segmentedArray = @[@"详情",@"目录",@"点评",@"笔记",@"提问"];
    } else {
        segmentedArray = @[@"详情",@"目录",@"点评",@"笔记",@"提问"];
    }
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
    
}


- (void)addControllerSrcollView {
    
    _controllerSrcollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segleMentView.frame) + 10 * WideEachUnit,  MainScreenWidth, MainScreenHeight * 30 + 500 * WideEachUnit)];
    _controllerSrcollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _controllerSrcollView.pagingEnabled = YES;
    _controllerSrcollView.scrollEnabled = YES;
    _controllerSrcollView.delegate = self;
    _controllerSrcollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 5,0);
    [_allScrollView addSubview:_controllerSrcollView];
    
    Good_ClassDetailViewController *classDetailVc= [[Good_ClassDetailViewController alloc] initWithNumID:_ID];
    classDetailVc.view.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight * 30);
    [self addChildViewController:classDetailVc];
    [_controllerSrcollView addSubview:classDetailVc.view];
    
    Good_ClassCatalogViewController *classCatalogVc = [[Good_ClassCatalogViewController alloc] initWithNumID:_ID];
    classCatalogVc.view.frame = CGRectMake(MainScreenWidth * 1, 0, MainScreenWidth, MainScreenHeight * 2 + 500 * WideEachUnit);
    [self addChildViewController:classCatalogVc];
    [_controllerSrcollView addSubview:classCatalogVc.view];
    
    Good_ClassCommentViewController *classCommentVc = [[Good_ClassCommentViewController alloc] initWithNumID:_ID];
    classCommentVc.view.frame = CGRectMake(MainScreenWidth * 2, 0, MainScreenWidth, MainScreenHeight * 10 + 500 * WideEachUnit);
    [self addChildViewController:classCommentVc];
    [_controllerSrcollView addSubview:classCommentVc.view];
    
    
    Good_ClassNotesViewController *classNotesVc = [[Good_ClassNotesViewController alloc] initWithNumID:_ID];
    classNotesVc.view.frame = CGRectMake(MainScreenWidth * 3, 0, MainScreenWidth, MainScreenHeight * 10 + 500 * WideEachUnit);
    [self addChildViewController:classNotesVc];
    [_controllerSrcollView addSubview:classNotesVc.view];
    
    Good_ClassAskQuestionsViewController *classAskVc = [[Good_ClassAskQuestionsViewController alloc] initWithNumID:_ID];
    classAskVc.view.frame = CGRectMake(MainScreenWidth * 4, 0, MainScreenWidth, MainScreenHeight * 10 + 500 * WideEachUnit);
    [self addChildViewController:classAskVc];
    [_controllerSrcollView addSubview:classAskVc.view];
    

    if ([_serviceOpen integerValue] == 1) {
//        Good_ClassServiceViewController *classServiceVc = [[Good_ClassServiceViewController alloc] initWithNumID:_ID];
//        classServiceVc.view.frame = CGRectMake(MainScreenWidth * 3, 0, MainScreenWidth, MainScreenHeight * 10 + 500 * WideEachUnit);
//        [self addChildViewController:classServiceVc];
//        [_controllerSrcollView addSubview:classServiceVc.view];
//        _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 4,0);
        _subVcArray = @[classDetailVc,classCatalogVc,classCommentVc,classNotesVc,classAskVc];
    } else {
        _controllerSrcollView.contentSize = CGSizeMake(MainScreenWidth * 5,0);
        _subVcArray = @[classDetailVc,classCatalogVc,classCommentVc,classNotesVc,classAskVc];
    }
    


//    [self addClassDetailVcBolck];
    [self addClassCatalogVcBolck];
    [self addCommentVcBolck];
    [self addNoteVcBolck];
    [self addAskVcBolck];
    [self addClassCatalogVcDataSourceBolck];
    [self addClassCatalogVcDidSeleBolck];
}


- (void)addDownView {
    
    _downView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 50 * WideEachUnit , MainScreenWidth, 50 * WideEachUnit)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    //添加线
    UIButton *lineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
    lineButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_downView addSubview:lineButton];
    
    
    CGFloat ButtonW = MainScreenWidth / 5;
    //    buttonW = ButtonW;
    CGFloat ButtonH = 50 * WideEachUnit;
    
    NSArray *title = @[@"关注",@"立即购买"];
    NSArray *image = @[@"机构关注@2x",@"机构信息@2x"];
    if ([_videoDict[@"follow_state"][@"following"] integerValue] == 0) {
        image = @[@"icon_focus@3x",@"icon_message@3x"];
        title = @[@"关注",@"私信"];
    } else {
        image = @[@"机构关注@2x",@"icon_message@3x"];
        title = @[@"已关注",@"私信"];
    }
    
    title = @[[NSString stringWithFormat:@"¥ %@",_price],@"立即购买"];
    if ([_price floatValue] == 0) {
        title = @[@"免费",@"立即购买"];
    }
    
    for (int i = 0 ; i < title.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * ButtonW, SpaceBaside, ButtonW, ButtonH)];
        [button setTitle:title[i] forState:UIControlStateNormal];
        [button setTitleColor:BlackNotColor forState:UIControlStateNormal];
        button.titleLabel.font = Font(14 * WideEachUnit);
        button.tag = i;
        [button addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:button];
        
        if (i == 0) {
            button.frame = CGRectMake(0, 0, ButtonW * 2, ButtonH / 2);
            [button setTitleColor:[UIColor colorWithHexString:@"#f01414"] forState:UIControlStateNormal];
            if ([_price floatValue] == 0) {
                [button setTitleColor:[UIColor colorWithHexString:@"#47b37d"] forState:UIControlStateNormal];
            }
            button.titleLabel.font = Font(14 * WideEachUnit);
            _attentionButton = button;
            
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
}

#pragma mark --- 原价处理
- (void)ordPriceDeal {
    
    _ordPrice.text = [NSString stringWithFormat:@"￥%@",[_videoDataSource stringValueForKey:@"v_price"]];
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

#pragma mark --- 滚动试图

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 因为video的尺寸一直在变 所以后面就不能用video的尺寸来滚动的范围
    CGFloat contentCrorX = _controllerSrcollView.contentOffset.x;
    if (contentCrorX < MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 0;
        if (currentIOS >= 11.0) {
            _allScrollView.contentSize = CGSizeMake(0, detailSrollHight + 210 * WideEachUnit + 200 * WideEachUnit + 10 * WideEachUnit);
        } else {
            _allScrollView.contentSize = CGSizeMake(0 * WideEachUnit , detailSrollHight + 210 * WideEachUnit + 200 * WideEachUnit + 10 * WideEachUnit);
        }
    } else if (contentCrorX < 2 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 1;
//        _allScrollView.contentSize = CGSizeMake(0, catalogScrollHight + CGRectGetMaxY(_videoView.frame) + 150 * WideEachUnit);// 因为这句代码video的尺寸一直在变 所以是不可以的
        _allScrollView.contentSize = CGSizeMake(0, catalogScrollHight + 210 * WideEachUnit + 150 * WideEachUnit);
    }  else if (contentCrorX < 3 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 2;
        _allScrollView.contentSize = CGSizeMake(0 , commentScrollHight + 210 * WideEachUnit + 160 * WideEachUnit + 100 * WideEachUnit + 30 * WideEachUnit);// 100 * WideEachUnit 是tabeView 的头部
    } else if (contentCrorX < 4 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 3;
        _allScrollView.contentSize = CGSizeMake(0 , notesScrollHight + 210 * WideEachUnit + 160 * WideEachUnit + 100 * WideEachUnit + 30 * WideEachUnit - 140 * WideEachUnit);
    } else if (contentCrorX < 5 * MainScreenWidth) {
        _mainSegment.selectedSegmentIndex = 4;
        _allScrollView.contentSize = CGSizeMake(0 , askScrollHight + 210 * WideEachUnit + 160 * WideEachUnit + 100 * WideEachUnit + 30 * WideEachUnit - 140 * WideEachUnit);
    }
    
    
    //设置顶部滚动的导航栏
    CGFloat contentCrorY = _allScrollView.contentOffset.y;
    scrollContentY = contentCrorY;
    NSLog(@"Y----%lf",contentCrorY);
    NSLog(@"----%lf",CGRectGetMaxY(_mainDetailView.frame));

    if (!isVideoExit) {//没有播放视频
        if (contentCrorY > CGRectGetMaxY(_mainDetailView.frame)) {//出现
            _navigationView.backgroundColor = BasidColor;
            _videoTitleLabel.textColor = [UIColor whiteColor];
            [_allScrollView bringSubviewToFront:_navigationView];
            _navigationView.frame = CGRectMake(0, contentCrorY, MainScreenWidth, 64);
            _segleMentView.frame = CGRectMake(0, contentCrorY + 64, MainScreenWidth, 50 * WideEachUnit);
            [_allScrollView bringSubviewToFront:_segleMentView];
        } else {
            _navigationView.backgroundColor = [UIColor clearColor];
            _videoTitleLabel.textColor = [UIColor clearColor];
            _navigationView.frame = CGRectMake(0, 0, MainScreenWidth, 64);
            _segleMentView.frame = CGRectMake(0,CGRectGetMaxY(_mainDetailView.frame) + 10 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit);
            [_allScrollView bringSubviewToFront:_segleMentView];
        }
    } else {//有播放视频
        if (contentCrorY > 70 * WideEachUnit) {
            _navigationView.backgroundColor = [UIColor clearColor];
            _videoTitleLabel.textColor = [UIColor clearColor];
            _navigationView.frame = CGRectMake(0, contentCrorY, MainScreenWidth, 64);
            [_allScrollView bringSubviewToFront:_videoView];
            [_allScrollView bringSubviewToFront:_navigationView];
            _videoView.frame = CGRectMake(0, contentCrorY, MainScreenWidth, 210 * WideEachUnit);
            _segleMentView.frame = CGRectMake(0,contentCrorY + 210 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit);
            [_allScrollView bringSubviewToFront:_segleMentView];
        } else {
            _navigationView.backgroundColor = [UIColor clearColor];
            _videoTitleLabel.textColor = [UIColor clearColor];
            _navigationView.frame = CGRectMake(0, contentCrorY, MainScreenWidth, 64);
            [_allScrollView bringSubviewToFront:_videoView];
            [_allScrollView bringSubviewToFront:_navigationView];
            _videoView.frame = CGRectMake(0, contentCrorY + 0 * WideEachUnit, MainScreenWidth, 210 * WideEachUnit);
            _segleMentView.frame = CGRectMake(0,CGRectGetMaxY(_mainDetailView.frame) + 10 * WideEachUnit, MainScreenWidth, 50 * WideEachUnit);
//            if (currentIOS >= 11.0) {
//                _mainDetailView.frame = CGRectMake(0, CGRectGetMaxY(_videoView.frame) + 10 * WideEachUnit, MainScreenWidth, 70 * WideEachUnit);
//            }
            [_allScrollView bringSubviewToFront:_segleMentView];
        }
    }
    
    
    
}


- (void)mainChange:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            _controllerSrcollView.contentOffset = CGPointMake(0, 0);
//            _allScrollView.contentSize = CGSizeMake(0 , detailSrollHight + CGRectGetMaxY(_videoView.frame) + 100 * WideEachUnit);
            break;
        case 1:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 1, 0);
            //设置滚动的范围
            _allScrollView.contentSize = CGSizeMake(0, catalogScrollHight + CGRectGetMaxY(_videoView.frame) + 210 * WideEachUnit);
            break;
        case 2:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 2, 0);
            _allScrollView.contentSize = CGSizeMake(0, commentScrollHight + CGRectGetMaxY(_videoView.frame) + 70 * WideEachUnit);
            //设置滚动的范围
            break;
        case 3:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 3, 0);
            _allScrollView.contentSize = CGSizeMake(0, notesScrollHight + CGRectGetMaxY(_videoView.frame) + 70 * WideEachUnit);
            //设置滚动的范围
            break;
        case 4:
            _controllerSrcollView.contentOffset = CGPointMake(MainScreenWidth * 4, 0);
            _allScrollView.contentSize = CGSizeMake(0, askScrollHight + CGRectGetMaxY(_videoView.frame) + 70 * WideEachUnit);
            //设置滚动的范围
            break;
            
        default:
            break;
    }
    
}



#pragma mark -- 事件监听
- (void)backPressed {
    [self releaseWMPlayer];
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
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
    _allWindowView = allWindowView;
    _appWindow = app.keyWindow;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth - 120 * WideEachUnit,55 * WideEachUnit,100 * WideEachUnit,100 * WideEachUnit)];
    moreView.frame = CGRectMake(MainScreenWidth - 120 * WideEachUnit,55 * WideEachUnit,100 * WideEachUnit,67 * WideEachUnit);
    moreView.backgroundColor = [UIColor whiteColor];
    moreView.layer.masksToBounds = YES;
    [allWindowView addSubview:moreView];
    
    NSArray *imageArray = @[@"ico_collect@3x",@"class_share",@"class_down"];
    NSArray *titleArray = @[@"+收藏",@"分享",@"下载"];
    if ([_collectStr integerValue] == 1) {
        imageArray = @[@"ic_collect_press@3x",@"class_share",@"class_down"];
        titleArray = @[@"-收藏",@"分享",@"下载"];
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
    if (UserOathToken == nil) {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        [_allWindowView removeFromSuperview];
        return;
    }
    if (button.tag == 0) {//收藏
        [self netWorkVideoCollect];
    } else if (button.tag == 1) {//分享
        [self netWorkVideoGetShareUrl];
    } else if (button.tag == 2) {//下载
        if ([[_videoDataSource stringValueForKey:@"is_buy"] integerValue] == 1) {
            Good_ClassDownViewController *vc = [[Good_ClassDownViewController alloc] init];
            vc.ID = _ID;
            vc.orderSwitch = _orderSwitch;
            vc.videoDataSource = (NSMutableDictionary *) _videoDataSource;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
           [_allWindowView removeFromSuperview];
            [MBProgressHUD showError:@"购买之后才能下载课程" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
    }
   [_allWindowView removeFromSuperview];
}

- (void)downButtonClick:(UIButton *)button {
    if (!UserOathToken) {
        DLViewController *DLVC = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:DLVC];
        [self.navigationController presentViewController:Nav animated:YES completion:nil];
        return;
    }
    if (button.tag == 1) {//购买
        if ([_buyButton.titleLabel.text isEqualToString:@"已购买"]) {
        } else {
            ClassAndLivePayViewController *vc = [[ClassAndLivePayViewController alloc] init];
            vc.dict = _videoDataSource;
            vc.typeStr = @"1";
            vc.cid = [_videoDataSource stringValueForKey:@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark --- 分享相关
- (void)VideoShare {
    NSLog(@"%@  %@",_videoTitle,_shareVideoUrl);
    [UMSocialWechatHandler setWXAppId:@"wxbbb961a0b0bf577a" appSecret:@"eb43d9bc799c4f227eb3a56224dccc88" url:_shareVideoUrl];
    [UMSocialQQHandler setQQWithAppId:@"1105368823" appKey:@"Q6Q6hJa2Cs8EqtLt" url:_shareVideoUrl];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3997129963" secret:@"da07bcf6c9f30281e684f8abfd0b4fca" RedirectURL:_shareVideoUrl];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"574e8829e0f55a12f8001790"
                                      shareText:[NSString stringWithFormat:@"%@",_videoTitle]
                                     shareImage:_shareImageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,nil]
                                       delegate:self];
}

#pragma mark --- bolck

- (void)addClassDetailVcBolck {
    Good_ClassDetailViewController *vc = _subVcArray[0];
    vc.vcHight = ^(CGFloat hight) {
        detailSrollHight = hight;
    };
}

- (void)addClassCatalogVcBolck {
    Good_ClassCatalogViewController *vc = _subVcArray[1];
    vc.vcHight = ^(CGFloat hight) {
        catalogScrollHight = hight;
    };
}

- (void)addCommentVcBolck {
    Good_ClassCommentViewController *vc = _subVcArray[2];
    vc.vcHight = ^(CGFloat hight) {
        commentScrollHight = hight;
        NSLog(@"-----%lf",hight);
    };
}

- (void)addNoteVcBolck {
    Good_ClassNotesViewController *vc = _subVcArray[3];
    vc.vcHight = ^(CGFloat hight) {
        notesScrollHight = hight;
        NSLog(@"-----%lf",hight);
    };
}

- (void)addAskVcBolck {
    Good_ClassAskQuestionsViewController *vc = _subVcArray[4];
    vc.vcHight = ^(CGFloat hight) {
        askScrollHight = hight;
        NSLog(@"-----%lf",hight);
    };
}

- (void)addClassCatalogVcDataSourceBolck {
    Good_ClassCatalogViewController *vc = _subVcArray[1];
    vc.videoDataSource = ^(NSDictionary *videoDataSource) {
        _seleCurrentDict = videoDataSource;
        if ([[videoDataSource stringValueForKey:@"is_baidudoc"] integerValue] == 1) {
            [self netWorkVideoGetBaiduDocReadToken];
//            [self addBaiDuDoc];
            return ;
        }
        if ([[videoDataSource stringValueForKey:@"video_type"] integerValue] == 6) {//考试
            if ([[_seleCurrentDict stringValueForKey:@"lock"] integerValue] != 1) {
                return ;
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"考试提示" message:@"是否现在前去考试？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [self netWorkExamsGetPaperInfo];
                }];
                [alertController addAction:sureAction];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                return ;
            }
        }
        //判断是否需要弹题出来
        isExitTestView = NO;
        [self judgeNeedTest];
        if ([[videoDataSource stringValueForKey:@"video_address"] rangeOfString:YunKeTang_EdulineOssCnShangHai].location != NSNotFound) {
            _ailDownDict = videoDataSource;
            if ([[_ailDownDict stringValueForKey:@"type"] integerValue] == 4) {//阿里的文档
                if ([[_ailDownDict stringValueForKey:@"price"] floatValue] == 0) {
                    if ([_free_course_opt integerValue] == 1) {//还是需要登录
                        if (!UserOathToken) {
                            DLViewController *vc = [[DLViewController alloc] init];
                            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
                            [self.navigationController presentViewController:Nav animated:YES completion:nil];
                            return;
                        }
                    } else if ([_free_course_opt integerValue] == 0) {
                        
                    }
                }
                _videoUrl = [_ailDownDict stringValueForKey:@"video_address"];
                [self addWebView];
            } else {
                 [self addAliYunPlayer];
            }
            return ;
        } else {
//            [self getVideoDataSource:videoDataSource];
             _ailDownDict = videoDataSource;
            _notifitonDic = videoDataSource;
            _videoUrl = [_notifitonDic stringValueForKey:@"video_address"];
            [self dealKindsOfType:videoDataSource];
        }
    };
}

- (void)addClassCatalogVcDidSeleBolck {
    Good_ClassCatalogViewController *vc = _subVcArray[1];
    vc.didSele = ^(NSString *seleStr) {
        [self releaseWMPlayer];
        [self AliPlayerDealloc];
    };
}


#pragma mark --- 通知（处理事情）

- (void)getDetailHight:(NSNotification *)not {
    NSString *scollHightStr = (NSString *)not.object;
    CGFloat scollHight = [scollHightStr floatValue];
    if ([MoreOrSingle integerValue] == 1) {
        scollHight = scollHight + 40 * WideEachUnit;
    }
    detailSrollHight = scollHight;
    _allScrollView.contentSize = CGSizeMake(0 , scollHight + CGRectGetMaxY(_videoView.frame) + 190 * WideEachUnit);
}

- (void)getCommentHight:(NSNotification *)not {
    NSString *scollHightStr = (NSString *)not.object;
    CGFloat scollHight = [scollHightStr floatValue];
    commentScrollHight = scollHight;
    if ([scollHightStr floatValue] < 10 * WideEachUnit) {//说明没有
        commentScrollHight = MainScreenWidth - CGRectGetMaxY(_videoView.frame) + 100 * WideEachUnit;
    }
}

- (void)becomeActive{
    NSLog(@"播放器状态:%ld",(long)self.playerView.playerViewState);
    if (self.playerView && self.playerView.playerViewState == AliyunVodPlayerStatePause){
        [self.playerView start];
    }
    if (wmPlayer.player) {
        [wmPlayer.player play];
    }
}

- (void)resignActive{
    if (self.playerView){
        [self.playerView pause];
    }
    if (wmPlayer.player) {
        [wmPlayer.player pause];
    }
}


//得到传值过来的处理
- (void)getVideoDataSource:(NSDictionary *)dict {
    _videoDict = dict;
    _videoUrl = [_videoDict stringValueForKey:@"video_address"];
    
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer setFireDate:[NSDate distantPast]];
    
    
    _notifitonDic = dict;
    _videoUrl = [_notifitonDic stringValueForKey:@"video_address"];
    
    //将之前的移除
    if (wmPlayer != nil|| wmPlayer.superview !=nil){
        [self releaseWMPlayer];
        [wmPlayer removeFromSuperview];
    }
    [_textView removeFromSuperview];
    [_webView removeFromSuperview];
    
    //配置数据的处理
    if (UserOathToken) {//登录的时候
        
    } else {//未登录的时候
        if ([_free_course_opt integerValue] == 1) {//即使免费的也需要登录
            DLViewController *vc = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        }
    }
    
    if ([_notifitonDic stringValueForKey:@"type"] == nil) {
        [MBProgressHUD showError:@"暂时不支持" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 1) {//视频
        if ( [[_videoDataSource stringValueForKey:@"is_buy"] integerValue] != 0) {//购买了的
            [_timer invalidate];
            self.timer = nil;
        } else {
            if ([[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//购买了单课时
                [_timer invalidate];
                self.timer = nil;
            } else {
                if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1) {//免费看
                    [_timer invalidate];
                    self.timer = nil;
                } else {//试看。受限制
                    if (_timeNum == 0) {
                        [MBProgressHUD showError:@"需先购买此课程" toView:[UIApplication sharedApplication].keyWindow];
                        return;
                    } else {
                        self.timer = nil;
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(videoTimeMonitor) userInfo:nil repeats:YES];
                    }
                }
            }
        }
        [self addPlayer];

    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 2) {//音频
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//购买了的
        }else {//没有购买
            [MBProgressHUD showError:@"购买才能听此音频" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }

        [self addPlayer];
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 3) {//文本
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//购买了的
        }else {//没有购买
            [MBProgressHUD showError:@"购买才能看此文本" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self addTextView];
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 4) {//文档
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//购买了的
        }else {//没有购买
            [MBProgressHUD showError:@"购买才能看此文档" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self addWebView];
    }
}

- (void)dealKindsOfType:(NSDictionary *)dict {
    _videoDict = dict;
    _videoUrl = [_videoDict stringValueForKey:@"video_address"];
    
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.timer setFireDate:[NSDate distantPast]];
    
    
    _notifitonDic = dict;
    _videoUrl = [_notifitonDic stringValueForKey:@"video_address"];
    
    //将之前的移除
    if (wmPlayer != nil|| wmPlayer.superview !=nil){
        [self releaseWMPlayer];
        [wmPlayer removeFromSuperview];
    }
    
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
    [_textView removeFromSuperview];
    [_webView removeFromSuperview];
    
    //配置数据的处理
    if (UserOathToken) {//登录的时候
        
    } else {//未登录的时候
        if ([_free_course_opt integerValue] == 1) {//即使免费的也需要登录
            DLViewController *vc = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        }
    }
    
    if ([_notifitonDic stringValueForKey:@"type"] == nil) {
        [MBProgressHUD showError:@"暂时不支持" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 1) {//视频
        if ( [[_videoDataSource stringValueForKey:@"is_buy"] integerValue] != 0) {//购买了的
            [_timer invalidate];
            self.timer = nil;
        } else {
            if ([[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//购买了单课时
                [_timer invalidate];
                self.timer = nil;
            } else {
                if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1) {//免费看
                    [_timer invalidate];
                    self.timer = nil;
                } else {//试看。受限制
                    if (_timeNum == 0) {
                        [MBProgressHUD showError:@"需先购买此课程" toView:[UIApplication sharedApplication].keyWindow];
                        return;
                    } else {
                        self.timer = nil;
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(videoTimeMonitorAndAliPlayer) userInfo:nil repeats:YES];
                    }
                }
            }
        }
        [self addAliYunPlayer];
        
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 2) {//音频
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//购买了的
        }else {//没有购买
            [MBProgressHUD showError:@"购买才能听此音频" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        
        [self addAliYunPlayer];
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 3) {//文本
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//购买了的
        }else {//没有购买
            [MBProgressHUD showError:@"购买才能看此文本" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self addTextView];
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 4) {//文档
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//购买了的
        }else {//没有购买
            [MBProgressHUD showError:@"购买才能看此文档" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self addWebView];
    }
}

- (void)AilYunPlayerEnd:(NSNotification *)not {
    NSString *notStr = (NSString *)not.object;
    if ([notStr integerValue] == 100) {
        
    }
}

- (void)TheAnswerRight:(NSNotification *)not {
    [_playerView resume];
}

#pragma mark --- 播放器的相关设置

// 支持设备自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}

// 支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
//        _wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    
    //在这里设置提醒试看试图的大小 （跟着视频大小的变化一起变化）
    _imageView.frame = CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (currentIOS >= 11.0) {
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.view.frame.size.width - 40);
            make.width.mas_equalTo(self.view.frame.size.height);
            
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(-80);
            make.width.mas_equalTo(self.view.frame.size.height - 80);
            make.left.mas_equalTo(30);
        } else {
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.view.frame.size.width-40);
            make.width.mas_equalTo(self.view.frame.size.height);
        }
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-self.view.frame.size.height/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    wmPlayer.isFullscreen = YES;
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
}

-(void)toNormal{
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        wmPlayer.playerLayer.frame = wmPlayer.bounds;
        
        //设置提醒试图的大小
        _imageView.frame = CGRectMake(0, 0, playerFrame.size.width, playerFrame.size.height);
        
        [_videoView addSubview:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
        
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
}


-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self toNormal];
    }
}

/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (wmPlayer == nil|| wmPlayer.superview == nil){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (wmPlayer.isFullscreen) {
                [self toNormal];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        default:
            break;
    }
}


-(void)releaseWMPlayer{
    [wmPlayer.player.currentItem cancelPendingSeeks];
    [wmPlayer.player.currentItem.asset cancelLoading];
    
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer = nil;
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    wmPlayer.videoURLStr = nil;
    
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
    
}

-(void)dealloc{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"player deallco");
}


- (void)AliPlayerDealloc {
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
}


#pragma mark --- 添加播放器或者文本视图
- (void)addPlayer { //视频和音频
    [self AliPlayerDealloc];
    isVideoExit = NO;
    [_imageView removeFromSuperview];
    _imageView = nil;
    if (_videoUrl == nil) {
        return;
    }
    if (wmPlayer!=nil||wmPlayer.superview !=nil){
        [self releaseWMPlayer];
        [wmPlayer removeFromSuperview];
    }
    [_textView removeFromSuperview];
    [_webView removeFromSuperview];
    
    playerFrame = CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit);
    wmPlayer = [[WMPlayer alloc] initWithFrame:playerFrame videoURLStr:_videoUrl];
    wmPlayer.closeBtn.hidden = YES;
    [_videoView addSubview:wmPlayer];
    
    wmPlayer.closeBtn.hidden = YES;
    [wmPlayer.player play];
    wmPlayer.playOrPauseBtn.selected = NO;
    
    //设置尺寸
    [_allScrollView bringSubviewToFront:_videoView];
    _videoView.frame = CGRectMake(0, scrollContentY, MainScreenWidth, 210 * WideEachUnit);
    isVideoExit = YES;
    //隐藏最上面的导航栏 (设置为透明色)
    _navigationView.backgroundColor = [UIColor clearColor];
    _videoTitleLabel.textColor = [UIColor clearColor];
    [_allScrollView bringSubviewToFront:_navigationView];
    
    
//    //添加视频投屏
//    MPVolumeView *volume = [[MPVolumeView alloc] initWithFrame:CGRectMake(MainScreenWidth - 100 * WideEachUnit, 50 * WideEachUnit, 50 * WideEachUnit, 50 * WideEachUnit)];
//    volume.showsVolumeSlider = NO;
//    volume.backgroundColor = [UIColor redColor];
//    [volume sizeToFit];
//    [wmPlayer addSubview:volume];
    
}

- (void)addAliYunPlayer {
    if (wmPlayer!=nil||wmPlayer.superview !=nil){
        [self releaseWMPlayer];
        [wmPlayer removeFromSuperview];
    }
    
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
    
    
//    [self onFinishWithAliyunVodPlayerView:_playerView];
    
    //把之前的时间移除
    [_timer invalidate];
    self.timer = nil;
    
    //配置数据的处理
    if (UserOathToken) {//登录的时候
        
    } else {//未登录的时候
        if ([_free_course_opt integerValue] == 1) {//即使免费的也需要登录
            DLViewController *vc = [[DLViewController alloc] init];
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:Nav animated:YES completion:nil];
            return;
        }
    }
    
    //添加顺序播放
    if ([[_videoDataSource stringValueForKey:@"is_order"] integerValue] == 1) {
        if ([[_seleCurrentDict stringValueForKey:@"lock"] integerValue] == 1) {//可以播放
            
        } else {//不可以播放
            [MBProgressHUD showError:@"该课时暂时无法观看" toView:self.view];
            return;
        }
    }
    
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat topHeight = 0;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ) {
        width = ScreenWidth;
        height = ScreenWidth * 9 / 16.0;
        topHeight = 20;
    }else{
        width = ScreenWidth;
        height = ScreenHeight;
        topHeight = 20;
    }
    
    /****************UI播放器集成内容**********************/
    _playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,topHeight, width, height) andSkin:AliyunVodPlayerViewSkinRed];
    _playerView.frame = CGRectMake(0, 0, _videoView.frame.size.width, _videoView.frame.size.height);
    
    //        _playerView.circlePlay = YES;
    _playerView.delegate = self;
    [_playerView setDelegate:self];
    [_playerView setAutoPlay:YES];

    [_playerView setPrintLog:YES];

    _playerView.isScreenLocked = false;
    _playerView.fixedPortrait = false;
    self.isLock = self.playerView.isScreenLocked||self.playerView.fixedPortrait?YES:NO;
    
    [_videoView addSubview:_playerView];
    NSURL *url = [NSURL URLWithString:_ailDownDict[@"video_address"]];
     [self.playerView playViewPrepareWithURL:url];
    self.playerView.userInteractionEnabled = YES;
    
    
    //设置尺寸
    [_allScrollView bringSubviewToFront:_videoView];
    _videoView.frame = CGRectMake(0, scrollContentY, MainScreenWidth, 210 * WideEachUnit);
    isVideoExit = YES;
    //隐藏最上面的导航栏 (设置为透明色)
    _navigationView.backgroundColor = [UIColor clearColor];
    _videoTitleLabel.textColor = [UIColor clearColor];
    [_allScrollView bringSubviewToFront:_navigationView];
    
    //判断跑马灯
    [self detectionMarquee];
    
    if ([[_ailDownDict stringValueForKey:@"type"] integerValue] == 1) {//视频
        if ( [[_videoDataSource stringValueForKey:@"is_buy"] integerValue] != 0) {//购买了的
            [_timer invalidate];
            self.timer = nil;
        } else {
            if ([[_ailDownDict stringValueForKey:@"is_buy"] integerValue] == 1) {//购买了单课时
                [_timer invalidate];
                self.timer = nil;
            } else {
                if ([[_ailDownDict stringValueForKey:@"is_free"] integerValue] == 1) {//免费看
                    [_timer invalidate];
                    self.timer = nil;
                } else {//试看。受限制
                    if (_timeNum == 0) {
                        [MBProgressHUD showError:@"需先购买此课程" toView:[UIApplication sharedApplication].keyWindow];
                        return;
                    } else {
                        self.timer = nil;
                        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(videoTimeMonitorAndAliPlayer) userInfo:nil repeats:YES];
                    }
                }
            }
        }
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 2) {//音频
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//购买了的
        }else {//没有购买
            [MBProgressHUD showError:@"购买才能听此音频" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 3) {//文本
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//购买了的
        }else {//没有购买
            [MBProgressHUD showError:@"购买才能看此文本" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self addTextView];
    } else if ([[_notifitonDic stringValueForKey:@"type"] integerValue] == 4) {//文档
        if ([[_notifitonDic stringValueForKey:@"is_free"] integerValue] == 1 || [[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0 || [[_notifitonDic stringValueForKey:@"is_buy"] integerValue] == 1) {//购买了的
        }else {//没有购买
            [MBProgressHUD showError:@"购买才能看此文档" toView:[UIApplication sharedApplication].keyWindow];
            return;
        }
        [self addWebView];
    }
}

- (void)addTextView {//文本
    isVideoExit = NO;
    self.textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_videoView addSubview:self.textView];
    
    NSString *textStr = [Passport filterHTML:_videoUrl];
    self.textView.text = textStr;
    self.textView.editable = NO;
    self.textView.userInteractionEnabled = YES;
    isTextViewBig = NO;
    
    //添加手势
    [self.textView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textClick:)]];
    isVideoExit = YES;
}

- (void)addWebView {//文档
    isVideoExit = NO;
    [_webView removeFromSuperview];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth,MainScreenHeight / 2)];
//    if (iPhone4SOriPhone4) {
//        _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/5);
//    } else if (iPhone5o5Co5S) {
//        _webView.frame = CGRectMake(0, 70, MainScreenWidth, MainScreenWidth*3/5);
//    } else if (iPhone6) {
//        _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, 210 * WideEachUnit);
//    } else if (iPhone6Plus) {
//        _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
//    } else if (iPhoneX) {
//        _webView.frame = CGRectMake(0, 88, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
//    }
    _webView.frame = CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit);
    _webView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_videoView addSubview:_webView];
    
    
    [_webView setUserInteractionEnabled:YES];//是否支持交互
    _webView.delegate = self;
    [_webView setOpaque:YES];//opaque是不透明的意思
    [_webView setScalesPageToFit:YES];//自适应
    
    NSURL *url = nil;
    url = [NSURL URLWithString:_videoUrl];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    isWebViewBig = NO;
    isVideoExit = YES;
    //添加手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fakeTapGestureHandler:)];
    [tapGestureRecognizer setDelegate:self];
    [_webView.scrollView addGestureRecognizer:tapGestureRecognizer];
}

//百度文档
- (void)addBaiDuDoc {
    
    self.reader = [[BCEDocumentReader alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit)];
    self.reader.delegate = self;
    [self.view addSubview:self.reader];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[_baiDuDocDict stringValueForKey:@"docId"] forKey:@"docId"];
    [dict setObject:[_baiDuDocDict stringValueForKey:@"token"] forKey:@"token"];
    [dict setObject:[_baiDuDocDict stringValueForKey:@"host"] forKey:@"host"];
    [dict setObject:[_baiDuDocDict stringValueForKey:@"format"] forKey:@"docType"];
    [dict setObject:[_seleCurrentDict stringValueForKey:@"title"] forKey:@"title"];
    [dict setObject:@"1" forKey:@"startPageNum"];
    [dict setObject:@"6" forKey:@"totalPageNum"];
//    NSDictionary* parameters = @{
//                                 BDocPlayerSDKeyDocID: @"<docId>",
//                                 BDocPlayerSDKeyToken: @"<token>",
//                                 BDocPlayerSDKeyHost: @"<host>",
//                                 BDocPlayerSDKeyDocType: @"<docType>",
//                                 BDocPlayerSDKeyTotalPageNum: @"<totalPageNum>",
//                                 BDocPlayerSDKeyDocTitle: @"<title>",
//                                 BDocPlayerSDKeyPageNumber : @""
//                                 };
    
    
    NSError* error;
    [self.reader loadDoc:dict error:&error];
    
    
    
}

- (void)docLoadingStart:(NSError*)error {
    
}

- (void)docLoadingEnded:(NSError*)error {
    
}


#pragma mark --- 手势添加

- (void)allWindowViewClick:(UITapGestureRecognizer *)tap {
    [_allWindowView removeFromSuperview];
}

- (void)fakeTapGestureHandler:(UITapGestureRecognizer *)tap {
    
    isWebViewBig = !isWebViewBig;
    if (isWebViewBig == YES) {
        [UIView animateWithDuration:0.25 animations:^{
            self.webView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
            [self.view addSubview:self.webView];
            //方法 隐藏导航栏
            self.navigationController.navigationBar.hidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.webView.frame = CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit);
            [_videoView addSubview:self.webView];
            self.navigationController.navigationBar.hidden = YES;
        }];
    }
}

//文本手势
- (void)textClick:(UITapGestureRecognizer *)tap {
    
    isTextViewBig = !isTextViewBig;
    if (isTextViewBig == YES) {
        [UIView animateWithDuration:0.25 animations:^{
            self.textView.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
            [self.view addSubview:self.textView];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.textView.frame = CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit);
            [_videoView addSubview:self.textView];
        }];
    }
}


#pragma mark --- 播放器的时间监听
- (void)videoTimeMonitor {
    if (_videoDataSource == nil) {
        
    } else {
        if ([[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0) {
            return;
        }
    }
    if ([[_videoDataSource stringValueForKey:@"is_free"] integerValue] == 1) {//如果免费
        return;
    }
    //监听播放时间
    CMTime cmTime = wmPlayer.player.currentTime;
    float videoDurationSeconds = CMTimeGetSeconds(cmTime);
    
    if (videoDurationSeconds  > _timeNum) {
        [wmPlayer.player pause];
        wmPlayer.playOrPauseBtn.selected = YES;//这句代码是暂停播放后播放按钮显示为暂停状态
        
        if (_imageView == nil || _imageView.subviews == nil) {
            //判断当前的播放器是小屏还是全屏
            if (wmPlayer.isFullscreen == YES) {//全屏
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenHeight, MainScreenWidth)];
            } else {//小屏
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(wmPlayer.frame))];
            }
            
            _imageView.image = [UIImage imageNamed:@"试看结束@2x"];
            [wmPlayer addSubview:_imageView];
            
            wmPlayer.playOrPauseBtn.enabled = NO;
            wmPlayer.playOrPauseBtn.selected = NO;
            wmPlayer.progressSlider.enabled = NO;
        }
    } else {//时间还没有到的
        wmPlayer.playOrPauseBtn.enabled = YES;
        wmPlayer.progressSlider.enabled = YES;
        if (_imageView.subviews.count == 0) {
            [_imageView removeFromSuperview];
        }
    }
}

- (void)videoTimeMonitorAndAliPlayer {
    if (_videoDataSource == nil) {
        
    } else {
        if ([[_videoDataSource stringValueForKey:@"is_play_all"] integerValue] != 0) {
            return;
        }
    }
    if ([[_videoDataSource stringValueForKey:@"is_free"] integerValue] == 1) {//如果免费
        return;
    }
    
    //监听播放时间
    NSString *ailTimeStr = [NSString stringWithFormat:@"%f",self.playerView.currentTime];
    float videoDurationSeconds = [ailTimeStr floatValue];
    
    if (videoDurationSeconds  > _timeNum) {
        [self.playerView pause];
        wmPlayer.playOrPauseBtn.selected = YES;//这句代码是暂停播放后播放按钮显示为暂停状态
        
        if (_imageView == nil || _imageView.subviews == nil) {
            //判断当前的播放器是小屏还是全屏
            if (self.playerView.frame.size.width == MainScreenWidth) {//说明是小屏的时候
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(self.playerView.frame))];
                _imageView.image = [UIImage imageNamed:@"试看结束@2x"];
                [self.playerView addSubview:_imageView];
            } else {
                _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, CGRectGetHeight(self.playerView.frame))];
                _imageView.image = [UIImage imageNamed:@"试看结束@2x"];
                [self.playerView addSubview:_imageView];
            }
            self.playerView.userInteractionEnabled = NO;
        } else {
            _imageView.hidden = NO;
            [self.playerView addSubview:_imageView];
            self.playerView.userInteractionEnabled = NO;
        }
    } else {//时间还没有到的
        wmPlayer.playOrPauseBtn.enabled = YES;
        wmPlayer.progressSlider.enabled = YES;
        if (_imageView.subviews.count == 0) {
            [_imageView removeFromSuperview];
        }
    }
}

#pragma mark ---- 本地拿数据 （专门针对阿里云视频）
- (void)getAilVideo {
    
    NSString *downVideoName = [_ailDownDict stringValueForKey:@"video_title"];
    self.downloadManage = [ZFDownloadManager sharedDownloadManager];
    NSMutableArray *finishedList = self.downloadManage.finishedlist;
    ZFFileModel *indexModel = nil;
    if (finishedList.count) {
        indexModel = [finishedList objectAtIndex:0];
    } else {
//        return;
    }
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *cacheListPath = [paths stringByAppendingPathComponent:@"ZFDownLoad/CacheList/"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSArray *subPaths = [fileManager subpathsAtPath:cacheListPath];
    
    for (NSString *fileName in subPaths) {
        if ([fileName rangeOfString:@"阿里"].location != NSNotFound) {//就是当前视频
                NSString *currentFlieName = [NSString  stringWithFormat:@"%@/%@.mp4",cacheListPath,@"课时01 免费的阿里视频"];
            
        }
    }
    
    if ([indexModel.fileName rangeOfString:@"m3u8"].location != NSNotFound) {//就是下载的m3u8格式的视频
        if ([fileManager fileExistsAtPath:[cacheListPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m3u8",indexModel.fileName]]]) {
            NSString *pathLast = [NSString stringWithFormat:@"%@/%@",cacheListPath,indexModel.fileName];
            NSString * tttt = [NSString  stringWithFormat:@"%@.m3u8",pathLast];
            
            
            NSString *content = [NSString stringWithContentsOfFile:tttt
                                                          encoding:NSUTF8StringEncoding
                                                             error:nil];
            
            
//            BigWindCar_playViewController *plav = [[BigWindCar_playViewController alloc]initWithPath:tttt withName:[NSString stringWithFormat:@"%@",indexModel.fileName]];
//            [self.navigationController pushViewController:plav animated:YES];
            
        
            return;
        }
    }
}

#pragma mark ---- 判断是够需要弹题
- (void)judgeNeedTest {
    if ([_seleCurrentDict stringValueForKey:@"qid"] == nil || [[_seleCurrentDict stringValueForKey:@"qid"] isEqualToString:@""]) {//没有弹题
        
    } else {//有弹题
        _popupTime = [[_seleCurrentDict stringValueForKey:@"popup_time"] integerValue];
        _popupTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(videoTimeNeedTest) userInfo:nil repeats:YES];
    }
}

//弹题的处理
- (void)videoTimeNeedTest {
    //监听播放时间
    NSString *ailTimeStr = [NSString stringWithFormat:@"%f",self.playerView.currentTime];
    float videoDurationSeconds = [ailTimeStr floatValue];
    
    if (videoDurationSeconds  > _popupTime) {//此时应该弹题
        if (isExitTestView) {
            return;
        } else {
            [self.playerView pause];
            //弹题处理
            ClassNeedTestViewController *vc = [[ClassNeedTestViewController alloc] initWithDict:_seleCurrentDict];
            [self.view addSubview:vc.view];
            vc.dict = _seleCurrentDict;
            [self addChildViewController:vc];
            isExitTestView = YES;
        }

    }
}



#pragma mark ---- aliPalyerDelegate


- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView lockScreen:(BOOL)isLockScreen{
    self.isLock = isLockScreen;
}


- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onVideoQualityChanged:(AliyunVodPlayerVideoQuality)quality{
    
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView fullScreen:(BOOL)isFullScreen{
    NSLog(@"isfullScreen --%d",isFullScreen);
    
    self.isStatusHidden = isFullScreen;
    [self refreshUIWhenScreenChanged:isFullScreen];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView onVideoDefinitionChanged:(NSString *)videoDefinition {
    
}

- (void)onCircleStartWithVodPlayerView:(AliyunVodPlayerView *)playerView {
    
}

- (void)refreshUIWhenScreenChanged:(BOOL)isFullScreen{
    if (isFullScreen) {
        //自己项目里面的一些配置
        _moreButton.hidden = YES;
        _backButton.hidden = YES;
        _controllerSrcollView.userInteractionEnabled = NO;
        _videoView.frame = CGRectMake(0, 0, MainScreenHeight, MainScreenWidth);
        if (iPhone6) {
            _videoView.frame = CGRectMake(0, 0, 667, 375);
        } else if (iPhone6Plus) {
            _videoView.frame = CGRectMake(0, 0, 736, 414);
        } else if (iPhoneX) {
            _videoView.frame = CGRectMake(0, 0, 812, 375);
        } else if (iPhone5o5Co5S) {
            _videoView.frame = CGRectMake(0, 0, 568, 320);
        }
        _allScrollView.contentOffset = CGPointMake(0, 0);
        _mainDetailView.hidden = YES;
        _segleMentView.hidden = YES;

    } else {
        _moreButton.hidden = NO;
        _backButton.hidden = NO;
        _controllerSrcollView.userInteractionEnabled = YES;
        _videoView.frame = CGRectMake(0, 0, MainScreenWidth, 210 * WideEachUnit);
        _controllerSrcollView.userInteractionEnabled = YES;
        _mainDetailView.hidden = NO;
        _segleMentView.hidden = NO;
    }
    
    //试看图片尺寸配置
    if (_imageView == nil || _imageView.subviews == nil) {
        
    } else {
        _imageView.frame = _videoView.frame;
    }
}


#pragma mark --- UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView {
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    [MBProgressHUD showError:@"加载成功" toView:self.view];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    [MBProgressHUD showError:@"加载失败" toView:self.view];
}

#pragma mark ---Marquee

- (void)detectionMarquee {
    if ([_marqueeOpenStr integerValue] == 1) {
        VideoMarqueeViewController *vc = [[VideoMarqueeViewController alloc] initWithDict:_marqueeDict];
        [_playerView addSubview:vc.view];
        [self addChildViewController:vc];
        return;
    }
}

#pragma mark --- 网络请求
- (void)netWorkVideoGetInfo {
    
    NSString *endUrlStr = YunKeTang_Video_video_getInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"id"];
    
    NSString *oath_token_Str = nil;
    if (UserOathToken) {
        oath_token_Str = [NSString stringWithFormat:@"%@:%@",UserOathToken,UserOathTokenSecret];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    if (UserOathToken) {
        [request setValue:oath_token_Str forHTTPHeaderField:OAUTH_TOKEN];
    }
  
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _videoDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[_videoDataSource stringValueForKey:@"code"] integerValue] == 1) {
            if ([[_videoDataSource dictionaryValueForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                _videoDataSource = [_videoDataSource dictionaryValueForKey:@"data"];
            } else {
                _videoDataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            }
        }
        _imageUrl = [_videoDataSource stringValueForKey:@"cover"];
        [_videoCoverImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
        _classTitle.text = [_videoDataSource stringValueForKey:@"video_title"];
        _studyNumber.text = [NSString stringWithFormat:@"在学%@人",[_videoDataSource stringValueForKey:@"video_order_count"]];
        _priceLabel.text = [NSString stringWithFormat:@"¥%@",[_videoDataSource stringValueForKey:@"price"]];
        if ([[_videoDataSource stringValueForKey:@"price"] floatValue] == 0) {
            _priceLabel.text = @"免费";
            _priceLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
        }
        if ([_orderSwitch integerValue] == 1) {
            _studyNumber.text = [NSString stringWithFormat:@"在学%@人",[_videoDataSource stringValueForKey:@"video_order_count_mark"]];
        }
        _collectStr = [_videoDataSource stringValueForKey:@"iscollect"];
        if ([[_videoDataSource stringValueForKey:@"is_buy"] integerValue] == 1) {//已经购买
            [_buyButton setTitle:@"已购买" forState:UIControlStateNormal];
        } else {
            [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        }
        [self ordPriceDeal];//处理原价
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"请求错误" toView:self.view];
        [self backPressed];
    }];
    [op start];
}

//获取视频试看的时长
- (void)netWorkVideoGetFreeTime {
    
    NSString *endUrlStr = YunKeTang_Video_video_getFreeTime;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"id"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr_Before:responseObject];
        if ([[dict stringValueForKey:@"code"] integerValue] == 1) {
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            _timeNum = [[dict stringValueForKey:@"video_free_time"] integerValue];
        } else {
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
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
    } else {
        DLViewController *vc = [[DLViewController alloc] init];
        UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:vc];
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
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
            [_allWindowView removeFromSuperview];
            if ([_collectStr integerValue] == 1) {
                _collectStr = @"0";
            } else {
                _collectStr = @"1";
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
    [mutabDict setObject:@"0" forKey:@"type"];
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
            _shareVideoUrl = [dict stringValueForKey:@"share_url"];
            [self VideoShare];
        } else {
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//获取视频加密
- (void)netWorkConfigGetVideoKey {
    
    NSString *endUrlStr = YunKeTang_config_getVideoKey;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"10" forKey:@"count"];
    
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        } else {
            [MBProgressHUD showError:[dict stringValueForKey:@"msg"] toView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//获取是否免费能试看配置的接口
- (void)netWorkConfigFreeCourseLoginSwitch {
    
    NSString *endUrlStr = YunKeTang_config_freeCourseLoginSwitch;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *ggg = [Passport getHexByDecimal:[timeSp integerValue]];
    
    NSString *tokenStr =  [Passport md5:[NSString stringWithFormat:@"%@%@",timeSp,ggg]];
    [mutabDict setObject:ggg forKey:@"hextime"];
    [mutabDict setObject:tokenStr forKey:@"token"];
    
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
            dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
            if ([[dict stringValueForKey:@"free_course_opt"] integerValue] == 1) {
                _free_course_opt = @"1";
            } else if ([[dict stringValueForKey:@"free_course_opt"] integerValue] == 0) {
                _free_course_opt = @"0";
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}


//配置客服按钮
- (void)netWorkGetThirdServiceUrl {
    
    NSString *endUrlStr = YunKeTang_Basic_Basic_getThirdServiceUrl;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:@"5" forKey:@"count"];
    
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
        _serviceDict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if ([_serviceDict isKindOfClass:[NSArray class]]) {
        } else {
            _serviceOpen = [_serviceDict stringValueForKey:@"is_open"];
            if ([[_serviceDict stringValueForKey:@"is_open"] integerValue] == 1) {//重新加载一次
                [_segleMentView removeFromSuperview];
                [_mainSegment removeFromSuperview];
                [self addWZView];
                [self addControllerSrcollView];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//配置跑马灯
- (void)netWorkVideoGetMarquee {
    
    NSString *endUrlStr = YunKeTang_Video_video_getMarquee;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
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
        NSLog(@"----%@",dict);
        _marqueeOpenStr = [dict stringValueForKey:@"is_open"];
        _marqueeDict = dict;
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}

//考试试题的详情
- (void)netWorkExamsGetPaperInfo {
    NSString *endUrlStr = YunKeTang_Exams_exams_getPaperInfo;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];

    if ([_seleCurrentDict stringValueForKey:@"eid"] == nil) {
        [MBProgressHUD showError:@"考试为空" toView:self.view];
        return;
    } else {
        [mutabDict setObject:[_seleCurrentDict stringValueForKey:@"eid"] forKey:@"paper_id"];
    }
    [mutabDict setObject:@"2" forKey:@"exams_type"];
    
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
    
    [MBProgressHUD showMessag:@"加载中...." toView:[UIApplication sharedApplication].keyWindow];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if ([dict dictionaryValueForKey:@"paper_options"].allKeys.count == 0) {
            [MBProgressHUD showError:@"考试数据为空" toView:self.view];
            return ;
        }
        if ([[dict dictionaryValueForKey:@"paper_options"] dictionaryValueForKey:@"options_questions"].allKeys.count == 0) {
            [MBProgressHUD showError:@"考试数据为空" toView:self.view];
            return ;
        }
//        if ([_examsType integerValue] == 1) {//练习模式
//            TestCurrentViewController *vc = [[TestCurrentViewController alloc] init];
//            vc.examsType = _examsType;
//            vc.dataSource = _dataSource;
//            vc.testDict = _testDict;
//            [self.navigationController pushViewController:vc animated:YES];
//        } else {//考试模式
//
//        }
        
        TestCurrentViewController *vc = [[TestCurrentViewController alloc] init];
        vc.examsType = @"2";
        vc.dataSource = dict;
        vc.testDict = _seleCurrentDict;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showError:@"加载失败" toView:self.view];
    }];
    [op start];
}


//考试试题的详情
- (void)netWorkVideoGetBaiduDocReadToken {
    NSString *endUrlStr = YunKeTang_Video_video_getBaiduDocReadToken;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [mutabDict setObject:[_seleCurrentDict stringValueForKey:@"cid"] forKey:@"cid"];
    
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
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        NSDictionary *dict = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        
        NSLog(@"---%@",dict);
        _baiDuDocDict = dict;
        [self addBaiDuDoc];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showError:@"加载失败" toView:self.view];
    }];
    [op start];
}





@end
