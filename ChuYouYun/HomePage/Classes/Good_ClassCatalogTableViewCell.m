//
//  Good_ClassCatalogTableViewCell.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/4/11.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import "Good_ClassCatalogTableViewCell.h"
#import "SYG.h"


@implementation Good_ClassCatalogTableViewCell



-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    //锁
    _lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 * WideEachUnit, 18 * WideEachUnit, 14 * WideEachUnit, 14 * WideEachUnit)];
    _lockImageView.backgroundColor = [UIColor whiteColor];
    _lockImageView.image = Image(@"suo2");
    [self addSubview:_lockImageView];
    
    //头像
    _palyImage = [[UIImageView alloc] initWithFrame:CGRectMake(22 * WideEachUnit, 18 * WideEachUnit, 14 * WideEachUnit, 14 * WideEachUnit)];
    _palyImage.backgroundColor = [UIColor whiteColor];
    _palyImage.image = Image(@"icon_class");
    [self addSubview:_palyImage];
    
    //标题
    _title = [[UILabel alloc] initWithFrame:CGRectMake(40 * WideEachUnit, 10 * WideEachUnit,MainScreenWidth - 80 * WideEachUnit, 30 * WideEachUnit)];
    _title.font = Font(14 * WideEachUnit);
    _title.textColor = [UIColor colorWithHexString:@"#333"];
    [self addSubview:_title];
    
    _freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_title.frame), 10 * WideEachUnit, 30 * WideEachUnit, 30 * WideEachUnit)];
    _freeLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
    _freeLabel.layer.cornerRadius = 3;
    _freeLabel.layer.borderWidth = 1;
    _freeLabel.font = Font(10);
    _freeLabel.layer.borderColor = [UIColor colorWithHexString:@"#47b37d"].CGColor;
    _freeLabel.text = @"免费";
    _freeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_freeLabel];
    
    //时间
    _time = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 90 * WideEachUnit, 20 * WideEachUnit , 80 * WideEachUnit, 10 * WideEachUnit)];
    [self addSubview:_time];
    _time.numberOfLines = 1;
    _time.textAlignment = NSTextAlignmentRight;
    _time.textColor = [UIColor grayColor];
    _time.font = Font(12 * WideEachUnit);
    
    //试看
    _isLookButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 10 * WideEachUnit, 50 * WideEachUnit, 20 * WideEachUnit)];
    _isLookButton.backgroundColor = [UIColor whiteColor];
    [_isLookButton setTitle:@"" forState:UIControlStateNormal];
    [_isLookButton setTitleColor:[UIColor colorWithHexString:@"#25b882"] forState:UIControlStateNormal];
    _isLookButton.titleLabel.font = Font(12 * WideEachUnit);
    [self addSubview:_isLookButton];
    _isLookButton.hidden = YES;
    
    //添加下载的按钮
    _downButton = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 10 * WideEachUnit, 50 * WideEachUnit, 15 * WideEachUnit)];
    [_downButton setImage:Image(@"") forState:UIControlStateNormal];
    [self addSubview:_downButton];
    
    //添加下载的文件大小
    _size = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 30 * WideEachUnit, 50 * WideEachUnit, 15 * WideEachUnit)];
    _size.textColor = [UIColor colorWithHexString:@"#888"];
    _size.font = Font(13);
    _size.text = @"";
    _size.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_size];
    
    //添加下载的按钮
    _progressView = [[UAProgressView alloc] initWithFrame:CGRectMake(MainScreenWidth - 60 * WideEachUnit, 15 * WideEachUnit, 50 * WideEachUnit, 20 * WideEachUnit)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectInset(self.progressView.bounds, self.progressView.bounds.size.width / 3.0, self.progressView.bounds.size.height / 3.0)];
    view.backgroundColor = [UIColor redColor];
    view.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
    self.progressView.centralView = view;
    
    self.progressView.fillChangedBlock = ^(UAProgressView *progressView, BOOL filled, BOOL animated){
        UIColor *color = (filled ? [UIColor whiteColor] : [UIColor redColor]);
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                progressView.centralView.backgroundColor = color;
            }];
        } else {
            progressView.centralView.backgroundColor = color;
        }
    };
    _progressView.hidden = YES;
}

- (void)dataSourceWithDict:(NSDictionary *)dict withBuyString:(NSString *)buyString WithLiveInfo:(NSDictionary *)liveInfo{
    _buyString = buyString;
    _cellDict = dict;
    _liveInfo = liveInfo;
    _title.text = [dict stringValueForKey:@"title"];
    _time.text = [dict stringValueForKey:@"duration"];
    if ([[dict stringValueForKey:@"type"] integerValue] == 3 || [[dict stringValueForKey:@"type"] integerValue] == 4) {
        _time.hidden = YES;
    }
    
    if ([[liveInfo stringValueForKey:@"is_order"] integerValue] == 1) {
        if ([[dict stringValueForKey:@"lock"] integerValue] == 1) {
            _lockImageView.image = Image(@"suo1");
            _lockImageView.hidden = NO;
        } else {
             _lockImageView.image = Image(@"suo2");
            _lockImageView.hidden = NO;
        }
    } else {
        _lockImageView.hidden = YES;
    }

    
    if ([[dict stringValueForKey:@"type"] integerValue] == 1) {
        _palyImage.image = Image(@"icon_classVideo");
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 2) {
         _palyImage.image = Image(@"icon_classMusic");
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 3) {
        _palyImage.image = Image(@"icon_classText");
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 4) {
        _palyImage.image = Image(@"icon_classDoc");
    } else if ([[dict stringValueForKey:@"type"] integerValue] == 5) {
        _palyImage.image = Image(@"icon_Test");
    }

    
    
    if ([buyString integerValue] == 1) {//已经购买整个课程
        if ([[dict stringValueForKey:@"is_free"] integerValue] == 1) {
            _freeLabel.hidden = NO;
            _freeLabel.layer.borderColor = BasidColor.CGColor;
            _freeLabel.textColor = BasidColor;
        } else {
            _freeLabel.hidden = NO;
            _freeLabel.text = @"已购";
            _freeLabel.layer.borderColor = [UIColor colorWithHexString:@"#888"].CGColor;
            _freeLabel.textColor = [UIColor colorWithHexString:@"#888"];
        }
    } else {//没有购买全部课程
        if ([[liveInfo stringValueForKey:@"price"] floatValue] == 0) {//免费的或者是管理员
            if ([[dict stringValueForKey:@"is_free"] integerValue] == 1) {
                _freeLabel.hidden = NO;
                _freeLabel.layer.borderColor = [UIColor colorWithHexString:@"#47b37d"].CGColor;
                _freeLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
            } else {
                _freeLabel.hidden = YES;
            }
        } else {
            if ([[dict stringValueForKey:@"is_free"] integerValue] == 1) {
                _freeLabel.hidden = NO;
                _freeLabel.layer.borderColor = [UIColor colorWithHexString:@"#47b37d"].CGColor;
                _freeLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
            } else {
                _freeLabel.hidden = NO;
                if ([[dict stringValueForKey:@"is_buy"] integerValue] == 1) {
                    _freeLabel.text = @"已购";
                    _freeLabel.layer.borderColor = [UIColor colorWithHexString:@"#888"].CGColor;
                    _freeLabel.textColor = [UIColor colorWithHexString:@"#888"];
                } else {
                    if ([dict[@"course_hour_price"] floatValue] == 0) {
                        _freeLabel.hidden = YES;
                    } else {
                        if (([dict[@"course_hour_price"] floatValue] * 100 / 100) >= 1) {//有小数
                            _freeLabel.text = [NSString stringWithFormat:@"￥%.02lf",[dict[@"course_hour_price"] floatValue]];
                        } else {//整数
                            _freeLabel.text = [NSString stringWithFormat:@"￥%ld",[dict[@"course_hour_price"] integerValue]];
                        }
                        
                        _freeLabel.layer.borderColor = [UIColor redColor].CGColor;
                        _freeLabel.textColor = [UIColor redColor];
                        _freeLabel.frame = CGRectMake(CGRectGetMaxX(_title.frame) + 10 * WideEachUnit, 10 * WideEachUnit, 50 * WideEachUnit, 30 * WideEachUnit);
                    }
                }
            }
        }
    }

    [self selfSubfit];
}

- (void)dataSourceWithDict:(NSDictionary *)dict withType:(NSString *)type {
    if ([type integerValue] == 0) {//列表
        _isLookButton.hidden = YES;
        
    } else if ([type integerValue] == 1) {//选择下载
        _isLookButton.hidden = NO;
        [_isLookButton setTitle:nil forState:UIControlStateNormal];
        [_isLookButton setImage:Image(@"is_download@3x") forState:UIControlStateNormal];
        _size.text = [dict stringValueForKey:@"size"];
        
        
        _title.text = [dict stringValueForKey:@"title"];
        _time.text = [dict stringValueForKey:@"duration"];
        if ([[dict stringValueForKey:@"is_free"] integerValue] == 1) {//免费
            [_isLookButton setTitle:@"" forState:UIControlStateNormal];
            [_isLookButton setImage:Image(@"") forState:UIControlStateNormal];
        } else {//不免费
            [_isLookButton setTitle:@"" forState:UIControlStateNormal];
            [_isLookButton setImage:Image(@"iconfont-mima@2x") forState:UIControlStateNormal];
        }
    } else if ([type integerValue] == 2) {//我的下载
        _isLookButton.hidden = NO;
        [_isLookButton setTitle:@"" forState:UIControlStateNormal];
        [_isLookButton setImage:Image(@"") forState:UIControlStateNormal];
        if ([[dict stringValueForKey:YunKeTang_CurrentDownExit] integerValue] == 1) {
            [_isLookButton setTitle:@"已下载" forState:UIControlStateNormal];
        } else {
            [_isLookButton setTitle:@"可下载" forState:UIControlStateNormal];
        }
        _isLookButton.layer.cornerRadius = 3;
        _isLookButton.layer.borderWidth = 1;
        _isLookButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _title.text = [dict stringValueForKey:@"title"];
        _time.text = [dict stringValueForKey:@"duration"];
    }
}


#pragma mark --- 自适应
- (void)selfSubfit {
    //赋值 and 自动换行,计算出cell的高度
    //获得当前cell高度
    //设置label的最大行数
    self.title.numberOfLines = 0;
    
    CGRect labelSize = [self.title.text boundingRectWithSize:CGSizeMake(MainScreenWidth - 160 * WideEachUnit, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 * WideEachUnit]} context:nil];
    
    self.title.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y,labelSize.size.width, 30 * WideEachUnit);
    if (labelSize.size.width > MainScreenWidth - 100 * WideEachUnit) {
        self.title.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y,MainScreenWidth - 200 * WideEachUnit, 30 * WideEachUnit);
    }
    _freeLabel.frame = CGRectMake(CGRectGetMaxX(_title.frame) + 10 * WideEachUnit, 15 * WideEachUnit, 32 * WideEachUnit, 20 * WideEachUnit);
    
    if ([[_liveInfo stringValueForKey:@"price"] floatValue] == 0) {//免费的或者是管理员
        if ([[_cellDict stringValueForKey:@"is_free"] integerValue] == 1) {
            _freeLabel.hidden = NO;
            _freeLabel.layer.borderColor = [UIColor colorWithHexString:@"#47b37d"].CGColor;
            _freeLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
        } else {
            _freeLabel.hidden = YES;
            return;
        }
    }
    
    if ([_buyString integerValue] == 0) {
        if ([[_cellDict stringValueForKey:@"is_free"] integerValue] == 1) {
            _freeLabel.hidden = NO;
            _freeLabel.layer.borderColor = [UIColor colorWithHexString:@"#47b37d"].CGColor;
            _freeLabel.textColor = [UIColor colorWithHexString:@"#47b37d"];
        } else {
            _freeLabel.hidden = NO;
            if ([[_cellDict stringValueForKey:@"is_buy"] integerValue] == 1) {
                _freeLabel.text = @"已购";
                _freeLabel.layer.borderColor = [UIColor colorWithHexString:@"#888"].CGColor;
                _freeLabel.textColor = [UIColor colorWithHexString:@"#888"];
            } else {
                if ([_cellDict[@"course_hour_price"] floatValue] == 0) {
                    _freeLabel.hidden = YES;
                } else {
                    if (([_cellDict[@"course_hour_price"] floatValue] * 100 / 100) >= 1) {//有小数
                        _freeLabel.text = [NSString stringWithFormat:@"￥%.02lf",[_cellDict[@"course_hour_price"] floatValue]];
                    } else {//整数
                        _freeLabel.text = [NSString stringWithFormat:@"￥%ld",[_cellDict[@"course_hour_price"] integerValue]];
                    }
                    _freeLabel.layer.borderColor = [UIColor redColor].CGColor;
                    _freeLabel.textColor = [UIColor redColor];
                    _freeLabel.frame = CGRectMake(CGRectGetMaxX(_title.frame) + 10 * WideEachUnit, 15 * WideEachUnit, 40 * WideEachUnit, 20 * WideEachUnit);
                    if (_freeLabel.text.length >= 6) {
                            _freeLabel.frame = CGRectMake(CGRectGetMaxX(_title.frame) + 10 * WideEachUnit, 15 * WideEachUnit, 50 * WideEachUnit, 20 * WideEachUnit);
                    }
                }
            }
        }
    }

}

//下载的时候
- (void)dataSourceWithDict:(NSDictionary *)dict withType:(NSString *)type withProgress:(CGFloat)progress {
    _isLookButton.hidden = YES;
    _progressView.hidden = NO;
    [self.progressView setProgress:progress];
}

#pragma mark --- 下载时的进度条
- (void)addd {
    UIView *view = [[UIView alloc] initWithFrame:CGRectInset(self.progressView.bounds, self.progressView.bounds.size.width / 3.0, self.progressView.bounds.size.height / 3.0)];
    view.backgroundColor = [UIColor redColor];
    view.userInteractionEnabled = NO; // Allows tap to pass through to the progress view.
    self.progressView.centralView = view;
    
    self.progressView.fillChangedBlock = ^(UAProgressView *progressView, BOOL filled, BOOL animated){
        UIColor *color = (filled ? [UIColor whiteColor] : [UIColor redColor]);
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                progressView.centralView.backgroundColor = color;
            }];
        } else {
            progressView.centralView.backgroundColor = color;
        }
    };
}

@end
