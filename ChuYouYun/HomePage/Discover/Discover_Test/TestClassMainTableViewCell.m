//
//  TestClassMainTableViewCell.m
//  dafengche
//
//  Created by 赛新科技 on 2017/9/25.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "TestClassMainTableViewCell.h"
#import "SYG.h"


@implementation TestClassMainTableViewCell

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayuot];
    }
    return self;
}


//初始化控件
-(void)initLayuot{
    
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 16 * WideEachUnit,MainScreenWidth - 20 * WideEachUnit, 15 * WideEachUnit)];
    _titleLabel.text = @"2014物业管理师考试参考答案";
    _titleLabel.font = Font(15 * WideEachUnit);
    _titleLabel.textColor = [UIColor colorWithHexString:@"#333"];
    [self addSubview:_titleLabel];
    
    //时间
    _personLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * WideEachUnit, 46 * WideEachUnit, 120 * WideEachUnit, 13 * WideEachUnit)];
    [self addSubview:_personLabel];
    _personLabel.text = @"更新时间：2016-10-10";
    _personLabel.font = Font(13 * WideEachUnit);
    _personLabel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    
    
    _subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_personLabel.frame) + 50 * WideEachUnit, 46 * WideEachUnit,120 *  WideEachUnit, 13 * WideEachUnit)];
    [self addSubview:_subjectLabel];
    _subjectLabel.text = @"更新时间：2016-10-10";
    _subjectLabel.font = Font(13 * WideEachUnit);
    _subjectLabel.textColor = [UIColor colorWithHexString:@"#9e9e9e"];
    
    
}

- (void)dataSourceWith:(NSDictionary *)dict {
    
    NSLog(@"-----%@",dict);
    
    _titleLabel.text = [dict stringValueForKey:@"exams_paper_title"];
    _personLabel.text = [NSString stringWithFormat:@"参考人数  %@",[dict stringValueForKey:@"exams_count"]];
    _subjectLabel.text = [NSString stringWithFormat:@"题数  %@",[dict stringValueForKey:@"questions_count"]];
//    NSString *timeStr = [Passport formatterDate:[dict stringValueForKey:@"ctime"]];

}



@end
