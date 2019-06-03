//
//  TestClassMainTableViewCell.h
//  dafengche
//
//  Created by 赛新科技 on 2017/9/25.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestClassMainTableViewCell : UITableViewCell


@property (strong ,nonatomic)UILabel *titleLabel;

@property (strong ,nonatomic)UILabel *personLabel;

@property (strong ,nonatomic)UILabel *subjectLabel;


-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void)dataSourceWith:(NSDictionary *)dict;

@end
