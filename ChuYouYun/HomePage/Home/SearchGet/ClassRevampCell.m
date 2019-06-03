//
//  ClassRevampCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/2/21.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "ClassRevampCell.h"
#import "UIButton+WebCache.h"
#import "SYG.h"
#import "Passport.h"

@implementation ClassRevampCell


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    int width;
    if (MainScreenWidth > 375) {
        
        width = 375;
    }else
    {
        width = MainScreenWidth;
    }
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 10 * WideEachUnit, 120 * WideEachUnit, 80 * WideEachUnit)];
    _imageButton.userInteractionEnabled = NO;
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"站位图"] forState:UIControlStateNormal];
    [self.contentView addSubview:_imageButton];
    
    //添加课程的标识
    _logoLiveOrClassButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    _logoLiveOrClassButton.backgroundColor = [UIColor clearColor];
    [_imageButton addSubview:_logoLiveOrClassButton];
    
    //添加是否购买的标示图
    _isBuyButton = [[UIButton alloc] initWithFrame:CGRectMake(90 * WideEachUnit, 65 * WideEachUnit, 30 * WideEachUnit, 15 * WideEachUnit)];
    _isBuyButton.backgroundColor = [UIColor clearColor];
    [_isBuyButton setImage:Image(@"is_buy") forState:UIControlStateNormal];
    [_imageButton addSubview:_isBuyButton];
    _isBuyButton.hidden = YES; // 默认为隐藏
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(15 * WideEachUnit, 65, 20, 20)];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"mv"] forState:UIControlStateNormal];
    [self.contentView addSubview:_playButton];
    _playButton.hidden = YES;
    
    _audition = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageButton.frame) + 13 * WideEachUnit, 10 * WideEachUnit, 40 * WideEachUnit, 14 * WideEachUnit)];
    [_audition setTitle:@"试听" forState:UIControlStateNormal];
    [_audition setTitleColor:BasidColor forState:UIControlStateNormal];
    _audition.layer.borderWidth = 1;
    _audition.titleLabel.font= Font(12 * WideEachUnit);
    _audition.layer.borderColor = BasidColor.CGColor;
    [self.contentView addSubview:_audition];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_audition.frame) + 10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - width / 5 * 2 - 13 - 50, 20 * WideEachUnit)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18 * WideEachUnit];
    _titleLabel.font = Font(18 * WideEachUnit);
    [self.contentView addSubview:_titleLabel];
    

    
    
//    _teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(width / 5 * 2 + 13, 42, 70, 30 + 5)];
//    _teacherLabel.font = [UIFont systemFontOfSize:14];
//    _teacherLabel.numberOfLines = 1;
//    [self.contentView addSubview:_teacherLabel];
//    _teacherLabel.textColor = [UIColor grayColor];
    
    
    _studyNum = [[UILabel alloc] initWithFrame:CGRectMake(140 * WideEachUnit, 42 * WideEachUnit,  MainScreenWidth - 150 * WideEachUnit, 12 * WideEachUnit)];
    _studyNum.font = [UIFont systemFontOfSize:12 * WideEachUnit];
    _studyNum.text = @"报名人数：90";
    [self.contentView addSubview:_studyNum];
    _studyNum.textColor = [UIColor colorWithHexString:@"#888"];
    
    _kinsOf = [[UILabel alloc] initWithFrame:CGRectMake(140 * WideEachUnit,70 * WideEachUnit , MainScreenWidth - 150 * WideEachUnit , 20 * WideEachUnit)];
    _kinsOf.font = [UIFont systemFontOfSize:16 * WideEachUnit];
    _kinsOf.textColor = BasidColor;
    _kinsOf.text = @"36";
    [self.contentView addSubview:_kinsOf];
}

- (void)dataWithDict:(NSDictionary *)dict withType:(NSString *)type {
    NSString *urlStr = [dict stringValueForKey:@"imageurl"];
    [_imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    if ([[dict stringValueForKey:@"type"] integerValue] == 1) {//课程
        [_logoLiveOrClassButton setImage:Image(@"course_ident@3x") forState:UIControlStateNormal];
    } else {//直播
        [_logoLiveOrClassButton setImage:Image(@"course_ident_live@3x") forState:UIControlStateNormal];
    }
    if ([[dict stringValueForKey:@"is_buy"] integerValue] == 0) {
        _isBuyButton.hidden = YES;
    } else {
        _isBuyButton.hidden = NO;
    }
    
    _titleLabel.text = [dict stringValueForKey:@"video_title"];
    
    if ([[dict stringValueForKey:@"is_tlimit"] integerValue] == 0) {
        _audition.hidden = YES;
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_imageButton.frame) + 10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - CGRectGetMaxX(_imageButton.frame) - 20 * WideEachUnit, 20 * WideEachUnit);
    } else {
        [_audition setTitle:@"试听" forState:UIControlStateNormal];
    }
    
    NSString *introStr = [Passport filterHTML:[dict stringValueForKey:@"video_intro"]];
    _teacherLabel.text = introStr;
    
    if ([dict[@"teacher_name"] isEqual:[NSNull null]]) {
        _teacherLabel.text = @"老师：";
    } else if ([dict[@"teacher_name"] isEqualToString:@""]) {
        _teacherLabel.text = @"老师：";
    } else if (dict[@"teacher_name"] != nil){
        _teacherLabel.text = [NSString stringWithFormat:@"%@",dict[@"teacher_name"]];
    } else {
        _teacherLabel.text = @"老师：";
    }
    
    _studyNum.text = [NSString stringWithFormat:@"报名人数：%@",[dict stringValueForKey:@"video_order_count"]];
    
    if ([type integerValue ] == 2) {
        _studyNum.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_order_count"]];
    }
    
    NSString *studyStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_order_count" defaultValue:@"0"]];
    NSString *timeStr = [Passport formatterDate:[dict stringValueForKey:@"beginTime"]];
    NSString *sectionStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"section_count"]];
    NSString *priceStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"price"]];
    
    //    [dict stringValueForKey:@"" defaultValue:@""]
    if ([type integerValue] == 1) {
        //        if ([sectionStr isEqualToString:@"(null)"]) {
        //            sectionStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_section_count"]];
        //        }
        _studyNum.text = [NSString stringWithFormat:@"%@人在学 · 共%@节",studyStr,sectionStr];
        if ([priceStr floatValue] == 0) {
            _kinsOf.text = [NSString stringWithFormat:@"免费"];
            _kinsOf.textColor = [UIColor colorWithHexString:@"#47b37d"];
        } else {
            _kinsOf.text = [NSString stringWithFormat:@"¥%@",priceStr];
            _kinsOf.textColor = BasidColor;
        }
        
    } else if ([type integerValue] == 2) {
        _studyNum.text = [NSString stringWithFormat:@"%@人在学 · %@开课",studyStr,timeStr];
        if ([priceStr floatValue] == 0) {
            _kinsOf.text = [NSString stringWithFormat:@"免费"];
            _kinsOf.textColor = [UIColor colorWithHexString:@"#47b37d"];
        } else {
            _kinsOf.text = [NSString stringWithFormat:@"¥%@",priceStr];
        }
    } else if ([type integerValue] == 3) {//下载
        _logoLiveOrClassButton.hidden = YES;
        NSString *urlStr = [dict stringValueForKey:@"cover"];
        [_imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
        _kinsOf.text = [NSString stringWithFormat:@"已下载%@个任务",[dict stringValueForKey:YunKeTang_CurrentDownCount]];
        _kinsOf.textColor = [UIColor colorWithHexString:@"#888"];
        _kinsOf.font = Font(13);
        _studyNum.hidden = YES;
    }
}


- (void)dataWithDict:(NSDictionary *)dict withType:(NSString *)type withOrderSwitch:(NSString *)orderSwitch{
    NSString *urlStr = [dict stringValueForKey:@"imageurl"];
    [_imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:urlStr] forState:UIControlStateNormal placeholderImage:Image(@"站位图")];
    if ([[dict stringValueForKey:@"type"] integerValue] == 1) {//课程
        [_logoLiveOrClassButton setImage:Image(@"course_ident@3x") forState:UIControlStateNormal];
    } else {//直播
        [_logoLiveOrClassButton setImage:Image(@"course_ident_live@3x") forState:UIControlStateNormal];
    }
    
    if ([[dict stringValueForKey:@"is_buy"] integerValue] == 0) {
        _isBuyButton.hidden = YES;
    } else {
        _isBuyButton.hidden = NO;
    }
    
    _titleLabel.text = [dict stringValueForKey:@"video_title"];
    
    if ([[dict stringValueForKey:@"is_tlimit"] integerValue] == 0) {
        _audition.hidden = YES;
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_imageButton.frame) + 10 * WideEachUnit, 10 * WideEachUnit, MainScreenWidth - CGRectGetMaxX(_imageButton.frame) - 20 * WideEachUnit, 20 * WideEachUnit);
    } else {
        [_audition setTitle:@"试听" forState:UIControlStateNormal];
    }
    
    NSString *introStr = [Passport filterHTML:[dict stringValueForKey:@"video_intro"]];
    _teacherLabel.text = introStr;
    
    if ([dict[@"teacher_name"] isEqual:[NSNull null]]) {
        _teacherLabel.text = @"老师：";
    } else if ([dict[@"teacher_name"] isEqualToString:@""]) {
        _teacherLabel.text = @"老师：";
    } else if (dict[@"teacher_name"] != nil){
        _teacherLabel.text = [NSString stringWithFormat:@"%@",dict[@"teacher_name"]];
    } else {
        _teacherLabel.text = @"老师：";
    }

    _studyNum.text = [NSString stringWithFormat:@"报名人数：%@",[dict stringValueForKey:@"video_order_count"]];
    
    if ([type integerValue ] == 2) {
        _studyNum.text = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_order_count"]];
    }
    
    NSString *studyStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_order_count" defaultValue:@"0"]];
    if ([orderSwitch integerValue] == 1) {
        studyStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_order_count_mark" defaultValue:@"0"]];
    }
    NSString *timeStr = [Passport formatterDate:[dict stringValueForKey:@"beginTime"]];
    NSString *sectionStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"section_count"]];
    NSString *priceStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"price"]];
   
//    [dict stringValueForKey:@"" defaultValue:@""]
    if ([type integerValue] == 1) {
//        if ([sectionStr isEqualToString:@"(null)"]) {
//            sectionStr = [NSString stringWithFormat:@"%@",[dict stringValueForKey:@"video_section_count"]];
//        }
        _studyNum.text = [NSString stringWithFormat:@"%@人在学 · 共%@节",studyStr,sectionStr];
        if ([priceStr floatValue] == 0) {
            _kinsOf.text = [NSString stringWithFormat:@"免费"];
            _kinsOf.textColor = [UIColor colorWithHexString:@"#47b37d"];
        } else {
            _kinsOf.text = [NSString stringWithFormat:@"¥%@",priceStr];
            _kinsOf.textColor = BasidColor;
        }
        
    } else if ([type integerValue] == 2) {

        if ([timeStr isEqualToString:@"1970-01-01"]) {
            _studyNum.text = [NSString stringWithFormat:@"%@人在学",studyStr];
        } else {
            _studyNum.text = [NSString stringWithFormat:@"%@人在学 · %@开课",studyStr,timeStr];
        }
        
        if ([priceStr floatValue] == 0) {
            _kinsOf.text = [NSString stringWithFormat:@"免费"];
            _kinsOf.textColor = [UIColor colorWithHexString:@"#47b37d"];
        } else {
            _kinsOf.text = [NSString stringWithFormat:@"¥%@",priceStr];
        }
    }
}


@end
