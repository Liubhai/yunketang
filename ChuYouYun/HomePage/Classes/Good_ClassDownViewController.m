
//
//  Good_ClassDownViewController.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/2.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_ClassDownViewController.h"
#import "AppDelegate.h"
#import "SYG.h"
#import "rootViewController.h"
#import "BigWindCar.h"
#import "GLNetWorking.h"
//缓存的模型
#import "SYGClassTool.h"

#import "Good_ClassCatalogTableViewCell.h"
#import "ZFDownloadManager.h"



@interface Good_ClassDownViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    UILabel *lable;
    
    BOOL _isOn0;
    BOOL _isOn1;
    BOOL _isOn2;
    BOOL _isOn3;
    BOOL _isOn4;
    BOOL _isOn5;
    int _number;
    
    UIButton *button0;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;
    
    BOOL     isScene;//是否配置（人脸识别）
    NSInteger indexPathSection;//
    NSInteger indexPathRow;//记录当前数据的相关
    NSInteger downIndexPathSection;
    NSInteger downIndexPathRow;
    
    UIImage   *faceImage;
}

@property (strong ,nonatomic)UITableView     *tableView;
@property (strong ,nonatomic)UIView          *tableViewHeaderView;
@property (strong ,nonatomic)UIImageView     *imageView;

@property (strong ,nonatomic)NSDictionary    *dataSource;
@property (strong ,nonatomic)NSArray         *dataArray;
@property (strong ,nonatomic)NSMutableArray  *newsDataArray;
@property (strong ,nonatomic)NSMutableArray  *sectionArray;
@property (strong ,nonatomic)NSMutableArray  *boolArray;

@property (strong ,nonatomic)NSString        *sectionID;
@property (strong ,nonatomic)NSString        *downUrl;
@property (strong ,nonatomic)NSString        *downTitle;
@property (strong ,nonatomic)NSTimer         *timer;

@property (strong ,nonatomic)NSMutableArray  *saveDataArray;
//下载第三方相关
@property (nonatomic, strong)ZFDownloadManager  *downloadManage;
@property (assign ,nonatomic)NSInteger           downSecition;
@property (assign ,nonatomic)NSInteger           downRow;
@property (assign ,nonatomic)CGFloat             downProgress;
@property (assign ,nonatomic)NSInteger           downIndex;



@end

@implementation Good_ClassDownViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
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
    [self addTableViewHeaderView];
    [self addTableView];
//    [self addWZView];
//    [self addControllerSrcollView];
    if ([_isDown integerValue] == 1) {//已经在我的下载界面了
        _newsDataArray = (NSMutableArray *)[_videoDataSource arrayValueForKey:YunKeTang_CurrentDownList];
        _sectionArray = (NSMutableArray *)[_videoDataSource arrayValueForKey:YunKeTang_CurrentDownTitleList];
    } else {
        [self netWorkVideoGetCatalog];
    }

    [_tableView reloadData];
}
- (void)interFace {
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _sectionArray = [NSMutableArray array];
    _newsDataArray = [NSMutableArray array];
    _saveDataArray = [NSMutableArray array];
    _isOn0 = NO;
    _isOn1 = NO;
    _isOn2 = NO;
    _isOn3 = NO;
    _isOn4 = NO;
    _isOn5 = NO;
}

- (void)addNav {
    
    UIView *SYGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, NavigationBarHeight)];
    SYGView.backgroundColor = BasidColor;
    [self.view addSubview:SYGView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"ic_back@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [SYGView addSubview:backButton];
    
    //添加中间的文字
    UILabel *titleText = [[UILabel  alloc] initWithFrame:CGRectMake(50, 25,MainScreenWidth - 100, 30)];
    titleText.text = @"选择下载";
    [titleText setTextColor:[UIColor whiteColor]];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.font = [UIFont systemFontOfSize:20];
    [SYGView addSubview:titleText];
    
    //添加横线
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 63, MainScreenWidth, 1)];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SYGView addSubview:button];
    
    if (iPhoneX) {
        backButton.frame = CGRectMake(5, 40, 40, 40);
        titleText.frame = CGRectMake(50, 45, MainScreenWidth - 100, 30);
        button.frame = CGRectMake(0, 87, MainScreenWidth, 1);
    }
}

- (void)addTableViewHeaderView {
    _tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 100 * WideEachUnit)];
    _tableViewHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableViewHeaderView];
    
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(125 * WideEachUnit, 10,MainScreenWidth - 140 * WideEachUnit, 36 * WideEachUnit)];
    title.text = [_videoDataSource stringValueForKey:@"video_title"];
    title.font = Font(15 * WideEachUnit);
    title.textColor = [UIColor colorWithHexString:@"#333"];
    [_tableViewHeaderView addSubview:title];
//
//    //添加线
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0 * WideEachUnit, 36 * WideEachUnit,MainScreenWidth - 30 * WideEachUnit, 1 * WideEachUnit)];
//    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [_tableViewHeaderView addSubview:line];
    
    
    //添加图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, 105 * WideEachUnit, 80 * WideEachUnit)];
    NSString *urlStr = [_videoDataSource stringValueForKey:@"cover"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:Image(@"站位图")];
    [_tableViewHeaderView addSubview:imageView];
    
    
    //添加课程价格
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(125 * WideEachUnit, 56 * WideEachUnit,MainScreenWidth - 140 * WideEachUnit, 20 * WideEachUnit)];
    price.font = Font(14 * WideEachUnit);
    price.textColor = [UIColor colorWithHexString:@"#fc0203"];
    price.textColor = [UIColor colorWithHexString:@"#888"];
    price.text = [NSString stringWithFormat:@"%@在学.共%@节",[_videoDataSource stringValueForKey:@"video_order_count"],[_videoDataSource stringValueForKey:@"section_count"]];
//    price.text = [NSString stringWithFormat:@"¥%@",[_videoDataSource stringValueForKey:@"price"]];
    if ([_orderSwitch integerValue] == 1) {
        price.text = [NSString stringWithFormat:@"%@在学.共%@节",[_videoDataSource stringValueForKey:@"video_order_count_mark"],[_videoDataSource stringValueForKey:@"section_count"]];
    }
    price.hidden = YES;
    [_tableViewHeaderView addSubview:price];
    
}

- (void)addTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50 * WideEachUnit;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = _tableViewHeaderView;
    
    //iOS 11 适配
    if (currentIOS >= 11.0) {
        Passport *ps = [[Passport alloc] init];
        [ps adapterOfIOS11With:_tableView];
    }
}

#pragma mark  --- 表格视图

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50 * WideEachUnit;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 50 * WideEachUnit)];
    tableHeadView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableHeadView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableHeadView.tag = section;
    
    //添加标题
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 0, MainScreenWidth - 50 * WideEachUnit, 50 * WideEachUnit)];
    sectionTitle.text = _sectionArray[section];
    sectionTitle.textColor = [UIColor colorWithHexString:@"333"];
    sectionTitle.font = Font(14 * WideEachUnit);
    [tableHeadView addSubview:sectionTitle];
    
    //添加箭头
    UIButton *arrowsButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 50 * WideEachUnit, 0, 40 * WideEachUnit, 50 * WideEachUnit)];
    [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];//灰色乡下@2x
    [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];//灰色乡下@2x
    arrowsButton.enabled = NO;
    if (section == 0) {
        if (_isOn0) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    } else if (section == 1) {
        if (_isOn1) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    }  else if (section == 2) {
        if (_isOn2) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    }  else if (section == 3) {
        if (_isOn3) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    }  else if (section == 4) {
        if (_isOn4) {
            [arrowsButton setImage:Image(@"灰色乡下@2x") forState:UIControlStateNormal];
        } else {
            [arrowsButton setImage:Image(@"向上@2x") forState:UIControlStateNormal];
        }
    }
    [tableHeadView addSubview:arrowsButton];
    
    //给整个View添加手势
    [tableHeadView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeadViewClick:)]];
    
    return tableHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_isDown integerValue] == 1) {
        return _sectionArray.count;
    } else {//平常
        return _dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isOn0) {
        if (section == 0) {
            return 0;
        }
    }
    if (_isOn1) {
        if (section == 1) {
            return 0;
        }
    }
    if (_isOn2) {
        if (section == 2) {
            return 0;
        }
    }
    if (_isOn3) {
        if (section == 3) {
            return 0;
        }
    }
    if (_isOn4) {
        if (section == 4) {
            return 0;
        }
    }
    if (_isOn5) {
        if (section == 5) {
            return 0;
        }
    }

    NSArray *sectionArray = _newsDataArray[section];
    return sectionArray.count;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"culture";
    //自定义cell类
    Good_ClassCatalogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Good_ClassCatalogTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSArray *cellArray = _newsDataArray[indexPath.section];
    NSDictionary *dict = [cellArray objectAtIndex:indexPath.row];
    if ([_isDown integerValue] == 1) {//下载界面
        [cell dataSourceWithDict:dict withType:@"2"];
    } else {
        [cell dataSourceWithDict:dict withType:@"1"];
    }

    [cell.downButton addTarget:self action:@selector(cellDownButtonCilck:) forControlEvents:UIControlEventTouchUpInside];
    indexPathSection = indexPath.section;
    indexPathRow = indexPath.row;
    cell.downButton.tag = indexPathSection * 10 + indexPathRow;
    if (_downProgress > 0 && _downProgress < 1) {//说明正在下载中
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    _downRow = indexPath.row;
    _downSecition = indexPath.section;
    NSDictionary *dict = _newsDataArray[_downSecition][_downRow];
    if ([_isDown integerValue] == 1) {
        if ([[dict stringValueForKey:YunKeTang_CurrentDownExit] integerValue] == 1) {//去观看
            
            return;
        } else {//去下载
            _downUrl = dict[@"video_address"];
            _downTitle = [dict stringValueForKey:@"title"];
            [self isSureDown];
        }
    }
}

#pragma mark --- 手势
- (void)tableHeadViewClick:(UITapGestureRecognizer *)not {
    NSInteger notTag = not.view.tag;
    if (notTag == 0) {
        _isOn0 = !_isOn0;
    } else if (notTag == 1) {
        _isOn1 = !_isOn1;
    } else if (notTag == 2) {
        _isOn2 = !_isOn2;
    } else if (notTag == 3) {
        _isOn3 = !_isOn3;
    } else if (notTag == 4) {
        _isOn4 = !_isOn4;
    } else if (notTag == 5) {
        _isOn5 = !_isOn5;
    }
    [_tableView reloadData];
}

#pragma mark --- 弹出框
//是否 真要下载
- (void)isSureDown {
    
    NSDictionary *dict = _newsDataArray[_downSecition][_downRow];
    NSString *messageStr = [NSString stringWithFormat:@"确定要下载%@改课程？",[dict stringValueForKey:@"title"]];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:messageStr];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:16 * WideEachUnit]
                  range:NSMakeRange(0, messageStr.length)];
    [alertController setValue:hogan forKey:@"attributedMessage"];
    
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self videoDown];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}




#pragma mark --- 事件点击

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cellDownButtonCilck:(UIButton *)button {//下载
    NSInteger sectionNum = button.tag / 10;
    NSInteger rowNum = button.tag % 10;
    _downSecition = sectionNum;
    _downRow = rowNum;
    NSArray *buttonArray = [_newsDataArray objectAtIndex:sectionNum];
    NSDictionary *dict = [buttonArray objectAtIndex:rowNum];
    _downUrl = [dict stringValueForKey:@"video_address"];
    _downTitle = [dict stringValueForKey:@"title"];
    [self videoDown];
}

#pragma mark --- 下载

-(void)videoDown{
    
    if ([[GLNetWorking isConnectionAvailable] isEqualToString:@"4G"] || [[GLNetWorking isConnectionAvailable] isEqualToString:@"3G"] || [[GLNetWorking isConnectionAvailable] isEqualToString:@"2G"]) {
        UIAlertView *_downAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"如果您正在使用2G/3G/4G,如果继续运营商可能会收取流量费用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_downAlertView show];
        });
    } else {
        [self downLoadVideo];
    }
}

-(void)downLoadVideo{
    
    if (_downUrl.length == 0) {
        [MBProgressHUD showError:@"下载地址为空" toView:self.view];
        return;
    }
    NSURL *imagegurl = [NSURL URLWithString:_downUrl];
    NSData *data = [NSData dataWithContentsOfURL:imagegurl];
    UIImage *videoImage = [[UIImage alloc] initWithData:data];
    //此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:_downUrl filename:_downTitle fileimage:videoImage];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 1;
    
    //保存数据
    [self saveDataSource];
//    [self saveVideoDataSource];
}

#pragma mark --- 已经下载文件以及正在下载的文件进行监听
- (void)downFileHandle {
    //这里应该处理 （获取到当前的下载进度）
    NSMutableArray *downloadingArray = self.downloadManage.downinglist;
    for (int i = 0 ; i < downloadingArray.count ; i ++) {
        ZFFileModel *model = [downloadingArray objectAtIndex:i];
        if ([model.fileName isEqualToString:_downTitle]) {//为当前下载的课程
            _downIndex = i;
        }
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
}

#pragma mark ---- Timer
- (void)updateProgress:(NSTimer *)timer {
    NSMutableArray *downloadingArray = self.downloadManage.downinglist;
    ZFFileModel *downModel = [downloadingArray objectAtIndex:_downIndex];
    _downProgress = (float)[downModel.fileReceivedSize longLongValue] / [downModel.fileSize longLongValue];
    //刷新指定下载的那一行
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_downRow inSection:_downSecition];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    if (_downProgress == 1) {
        [_timer invalidate];
        _timer = nil;
        _downProgress = 0;
    }
}

#pragma mark --- UIAlertView 相关
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        [self downLoadVideo];
    }else
        return;
}

#pragma mark ---保存数据相关
- (void)saveDataSource {
    
    //标记是否下载
    NSMutableDictionary *cellDict = (NSMutableDictionary *) _newsDataArray[_downSecition][_downRow];
    [cellDict setObject:@"1" forKey:YunKeTang_CurrentDownExit];
    NSMutableArray *secitionArray1 = _newsDataArray[_downSecition];
    NSMutableArray *replaceArray = [NSMutableArray array];
    for (int i = 0 ; i < secitionArray1.count ; i ++) {
        NSMutableDictionary *replaceDict = [secitionArray1 objectAtIndex:i];
        [replaceDict removeObjectForKey:@"wid"];
        [replaceArray addObject:replaceDict];
    }
    [replaceArray replaceObjectAtIndex:_downRow withObject:cellDict];
    [_newsDataArray replaceObjectAtIndex:_downSecition withObject:replaceArray];
    
    //改变字典的值
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *saveArray = [userDefaults objectForKey:YunKeTang_VideoDataSource];
    NSMutableDictionary *selfVideoSourceDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (saveArray.count == 0) {//说明当前还是空的
        [selfVideoSourceDict setObject:@"1" forKey:YunKeTang_CurrentDownCount];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"id"] forKey:@"id"];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_title"] forKey:@"video_title"];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"cover"] forKey:@"cover"];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"price"] forKey:@"price"];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_order_count"] forKey:@"video_order_count"];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_order_count_mark"] forKey:@"video_order_count_mark"];
        [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"section_count"] forKey:@"section_count"];
        [selfVideoSourceDict setObject:_newsDataArray forKey:YunKeTang_CurrentDownList];
        [selfVideoSourceDict setObject:_sectionArray forKey:YunKeTang_CurrentDownTitleList];
        [_saveDataArray addObject:selfVideoSourceDict];
    } else {//说明是有值的
        _saveDataArray = [NSMutableArray arrayWithArray:saveArray];
        BOOL isExit = NO;
        NSInteger isExitNumber = 0;
        for (int i = 0 ; i < saveArray.count ; i ++) {
            NSDictionary *dict = [saveArray objectAtIndex:i];
            NSString *videoID = [dict stringValueForKey:@"id"];
            if ([videoID isEqualToString:[_videoDataSource stringValueForKey:@"id"]]) {
                isExit = YES;
                
                if ([[[[[dict arrayValueForKey:YunKeTang_CurrentDownList] objectAtIndex:_downSecition] objectAtIndex:_downRow] stringValueForKey:YunKeTang_CurrentDownExit] integerValue] == 1) {
                    return;
                }
                
                isExitNumber = i;
                if ([[dict stringValueForKey:@"YunKeTang_CurrentDownCount"] integerValue] == 0) {
                     [selfVideoSourceDict setObject:@"1" forKey:YunKeTang_CurrentDownCount];
                } else {
                    
                }
                [selfVideoSourceDict setObject:[dict stringValueForKey:YunKeTang_CurrentDownCount] forKey:YunKeTang_CurrentDownCount];
                [selfVideoSourceDict setObject:[dict stringValueForKey:@"id"] forKey:@"id"];
                [selfVideoSourceDict setObject:[dict stringValueForKey:@"video_title"] forKey:@"video_title"];
                [selfVideoSourceDict setObject:[dict stringValueForKey:@"cover"] forKey:@"cover"];
                [selfVideoSourceDict setObject:[dict stringValueForKey:@"price"] forKey:@"price"];
                [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_order_count"] forKey:@"video_order_count"];
                [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_order_count_mark"] forKey:@"video_order_count_mark"];
                [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"section_count"] forKey:@"section_count"];
                [selfVideoSourceDict setObject:[dict arrayValueForKey:YunKeTang_CurrentDownTitleList] forKey:YunKeTang_CurrentDownTitleList];
                
                NSMutableDictionary *indexDict = [NSMutableDictionary dictionaryWithDictionary:[[[dict arrayValueForKey:YunKeTang_CurrentDownList] objectAtIndex:_downSecition] objectAtIndex:_downRow]];
                [indexDict setObject:@"1" forKey:YunKeTang_CurrentDownExit];
                NSMutableArray *secitionArray = [NSMutableArray arrayWithArray:[[dict arrayValueForKey:YunKeTang_CurrentDownList] objectAtIndex:_downSecition]];
                [secitionArray replaceObjectAtIndex:_downRow withObject:indexDict];
                NSMutableArray *array = [NSMutableArray arrayWithArray:[dict arrayValueForKey:YunKeTang_CurrentDownList]];
                [array replaceObjectAtIndex:_downSecition withObject:secitionArray];
                [selfVideoSourceDict setObject:array forKey:YunKeTang_CurrentDownList];
            }
        }
        
        if (isExit) {//说明相同 （就不添加了）应该添加下载的课时
            NSInteger downCount = [[selfVideoSourceDict objectForKey:YunKeTang_CurrentDownCount] integerValue];
            NSInteger newDownCount = downCount + 1;
            NSString *newDownCountStr = [NSString stringWithFormat:@"%ld",newDownCount];
            [selfVideoSourceDict setObject:newDownCountStr forKey:YunKeTang_CurrentDownCount];
            
            [_saveDataArray replaceObjectAtIndex:isExitNumber withObject:selfVideoSourceDict];
        } else {
            [selfVideoSourceDict setObject:@"1" forKey:YunKeTang_CurrentDownCount];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"id"] forKey:@"id"];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_title"] forKey:@"video_title"];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"cover"] forKey:@"cover"];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"price"] forKey:@"price"];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_order_count"] forKey:@"video_order_count"];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"video_order_count_mark"] forKey:@"video_order_count_mark"];
            [selfVideoSourceDict setObject:[_videoDataSource stringValueForKey:@"section_count"] forKey:@"section_count"];
            [selfVideoSourceDict setObject:_newsDataArray forKey:YunKeTang_CurrentDownList];
            [selfVideoSourceDict setObject:_sectionArray forKey:YunKeTang_CurrentDownTitleList];
            [_saveDataArray addObject:selfVideoSourceDict];
        }
    }
    NSArray *data = (NSArray *)_saveDataArray;
    [userDefaults setObject:data forKey:YunKeTang_VideoDataSource]; //这里会崩溃应该字典里面有null
}

#pragma mark --- 保存数据有关
- (void)saveVideoDataSource {
    //取出本地的数据
    NSArray *classArray = [SYGClassTool classWithDic:nil];
    BOOL isHave = NO;
    for (int i = 0 ; i < classArray.count ; i ++) {
        NSMutableDictionary *indexDict = [classArray objectAtIndex:i];
        if ([[indexDict stringValueForKey:@"id"] integerValue] == [[_videoDataSource stringValueForKey:@"id"] integerValue]) {//说明是同一个课程
            isHave = YES;
        }
    }
    if (isHave) {
        [_videoDataSource setObject:@"1" forKey:YunKeTang_CurrentDownCount];
        
        
    } else {
        NSMutableArray *mutabArray = [NSMutableArray arrayWithCapacity:0];
        [mutabArray addObject:_videoDataSource];
       [SYGClassTool saveClasses:mutabArray];
    }
    
}

#pragma mark --- 获取下载的数据



#pragma mark --- 网络请求
//获取列表
- (void)netWorkVideoGetCatalog {
    
    NSString *endUrlStr = YunKeTang_Video_video_getCatalog;
    NSString *allUrlStr = [YunKeTang_Api_Tool YunKeTang_GetFullUrl:endUrlStr];
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mutabDict setObject:_ID forKey:@"id"];
    
    if (UserOathToken) {
        NSString *oath_token_Str = [NSString stringWithFormat:@"%@%@",UserOathToken,UserOathTokenSecret];
        [mutabDict setObject:oath_token_Str forKey:OAUTH_TOKEN];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:allUrlStr]];
    [request setHTTPMethod:NetWay];
    NSString *encryptStr = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetEncryptStr:mutabDict];
    [request setValue:encryptStr forHTTPHeaderField:HeaderKey];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        _dataSource = [YunKeTang_Api_Tool YunKeTang_Api_Tool_GetDecodeStr:responseObject];
        if ([_dataSource isKindOfClass:[NSArray class]]) {
            _dataArray = (NSArray *)_dataSource;
            if (_dataArray.count == 0) {
                self.imageView.hidden = NO;
            } else {
                self.imageView.hidden = YES;
            }
            
            for (int i = 0 ; i < _dataArray.count; i ++ ) {
                NSArray *classArray = [[_dataArray objectAtIndex:i] arrayValueForKey:@"child"];
                if (classArray.count == 0) {
                } else {
                    [_newsDataArray addObject:classArray];
                }
                
                NSString *title = [[_dataArray objectAtIndex:i] stringValueForKey:@"title"];
                [_sectionArray addObject:title];
                
                NSMutableArray *boolArray = [NSMutableArray array];
                for (int k = 0 ; k < classArray.count ; k ++) {
                    
                    if (i == 0 && k == 0) {
                        [boolArray addObject:[NSNumber numberWithBool:YES]];
                    } else {
                        [boolArray addObject:[NSNumber numberWithBool:NO]];
                    }
                }
                [_boolArray addObject:boolArray];
            }
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    }];
    [op start];
}




@end
