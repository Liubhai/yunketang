//
//  VoteView.m
//  NewCCDemo
//
//  Created by cc on 2017/1/11.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "VoteView.h"
#import "CC _header.h"


@interface VoteView()

@property(nonatomic,strong)UIImageView              *questionImage;
@property(nonatomic,strong)UIView                   *bgView;
@property(nonatomic,strong)UILabel                  *label;
@property(nonatomic,strong)UIView                   *lineView;
@property(nonatomic,strong)UIButton                 *closeBtn;
@property(nonatomic,strong)UIView                   *labelBgView;
@property(nonatomic,strong)UILabel                  *centerLabel;

@property(nonatomic,strong)UIButton                 *aButton;
@property(nonatomic,strong)UIButton                 *bButton;
@property(nonatomic,strong)UIButton                 *cButton;
@property(nonatomic,strong)UIButton                 *dButton;
@property(nonatomic,strong)UIButton                 *eButton;
@property(nonatomic,strong)UIButton                 *rightButton;
@property(nonatomic,strong)UIButton                 *wrongButton;

@property(nonatomic,copy)  CloseBtnClicked          closeblock;
@property(nonatomic,copy)  VoteBtnClickedSingle     voteSingleBlock;
@property(nonatomic,copy)  VoteBtnClickedMultiple   voteMultipleBlock;
@property(nonatomic,copy)  VoteBtnClickedSingleNOSubmit     singleNOSubmit;
@property(nonatomic,copy)  VoteBtnClickedMultipleNOSubmit   multipleNOSubmit;
@property(nonatomic,assign)NSInteger                count;

//@property(nonatomic,strong)UIImageView              *rightLogo;
//@property(nonatomic,strong)UIView                   *selectBorder;
@property(nonatomic,strong)UIButton                 *submitBtn;
@property(nonatomic,assign)NSInteger                selectIndex;
@property(nonatomic,strong)NSMutableArray           *selectIndexArray;
@property(nonatomic,strong)UIView                   *view;
@property(nonatomic,assign)BOOL                     single;

@end

//答题
@implementation VoteView

-(instancetype) initWithCount:(NSInteger)count singleSelection:(BOOL)single closeblock:(CloseBtnClicked)closeblock voteSingleBlock:(VoteBtnClickedSingle)voteSingleBlock voteMultipleBlock:(VoteBtnClickedMultiple)voteMultipleBlock singleNOSubmit:(VoteBtnClickedSingleNOSubmit)singleNOSubmit multipleNOSubmit:(VoteBtnClickedMultipleNOSubmit)multipleNOSubmit {
    self = [super init];
    if(self) {
        self.single             = single;
        self.count              = count;
        self.closeblock         = closeblock;
        self.voteSingleBlock    = voteSingleBlock;
        self.voteMultipleBlock  = voteMultipleBlock;
        self.singleNOSubmit     = singleNOSubmit;
        self.multipleNOSubmit   = multipleNOSubmit;
        [self initUI];
    }
    return self;
}

-(void)submitBtnClicked {
    if(self.single) {
        if(self.voteSingleBlock) {
            self.voteSingleBlock(_selectIndex);
        }
    } else {
        if(self.voteMultipleBlock) {
            self.voteMultipleBlock(self.selectIndexArray);
        }
    }
}

-(void)initUI {
    WS(ws)
    self.backgroundColor = CCRGBAColor(0, 0, 0, 0.5);
    
    _selectIndex = 0;
    _selectIndexArray = [[NSMutableArray alloc] init];
    
    _view = [[UIView alloc]init];
    _view.backgroundColor = CCRGBColor(255,81,44);
    _view.layer.cornerRadius = CCGetRealFromPt(6);
    [self addSubview:_view];
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws).offset(CCGetRealFromPt(75));
        make.right.mas_equalTo(ws).offset(-CCGetRealFromPt(75));
        make.top.mas_equalTo(ws).offset(CCGetRealFromPt(668));
        make.bottom.mas_equalTo(ws).offset(-CCGetRealFromPt(166));
    }];

    self.bgView = [UIView new];
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    self.bgView.layer.cornerRadius = CCGetRealFromPt(6);
    [_view addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.view).offset(1);
        make.top.mas_equalTo(ws.view).offset(1);
        make.right.mas_equalTo(ws.view).offset(-1);
        make.bottom.mas_equalTo(ws.view).offset(-(1 + CCGetRealFromPt(4)));
    }];
    
    [self.bgView addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(70));
        make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(80));
        make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(26));
        make.height.mas_equalTo(1);
    }];
    
    [self.bgView addSubview:self.questionImage];
    [_questionImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.bgView);
        make.bottom.mas_equalTo(ws.view.mas_top).offset(CCGetRealFromPt(54));
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(110), CCGetRealFromPt(110)));
    }];
    
    [self.bgView addSubview:self.closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.bgView);//.offset(CCGetRealFromPt(0));
        make.right.mas_equalTo(ws.bgView);//.offset(-CCGetRealFromPt(0));
        make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(80), CCGetRealFromPt(80)));
    }];
    
    [self.bgView addSubview:self.label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(ws.bgView);
        make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(66));
        make.height.mas_equalTo(CCGetRealFromPt(36));
    }];
    
    [self.bgView addSubview:self.labelBgView];
    [_labelBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(105));
        make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(105));
        make.top.mas_equalTo(ws.label.mas_bottom).offset(CCGetRealFromPt(24));
        make.height.mas_equalTo(CCGetRealFromPt(40));
    }];
    
    [_labelBgView addSubview:self.centerLabel];
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(ws.labelBgView);
    }];

    [self.bgView addSubview:self.submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(160));
        make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(160));
        make.bottom.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(50));
        make.height.mas_equalTo(CCGetRealFromPt(80));
    }];
    [self.submitBtn setEnabled:NO];
    
    if(self.count >= 3) {
        if(self.count >= 3) {
            _aButton = [self createButtonWithStr:@"A" imageName:nil tag:0];
            [self.bgView addSubview:self.aButton];
            [_aButton mas_makeConstraints:^(MASConstraintMaker *make) {
                if(ws.count == 5) {
                    make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(22));
                    make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(478));
                } else if(ws.count == 4) {
                    make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(55));
                    make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(445));
                } else if(ws.count == 3) {
                    make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(100));
                    make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(400));
                }
                make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(214));
                make.bottom.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(186));
            }];

            _bButton = [self createButtonWithStr:@"B" imageName:nil tag:1];
            [self.bgView addSubview:self.bButton];
            [_bButton mas_makeConstraints:^(MASConstraintMaker *make) {
                if(ws.count == 5) {
                    make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(136));
                    make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(364));
                } else if(ws.count == 4) {
                    make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(185));
                    make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(315));
                } else if(ws.count == 3) {
                    make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(250));
                    make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(250));
                }
                make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(214));
                make.bottom.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(186));
            }];

            _cButton = [self createButtonWithStr:@"C" imageName:nil tag:2];
            [self.bgView addSubview:self.cButton];
            [_cButton mas_makeConstraints:^(MASConstraintMaker *make) {
                if(ws.count == 5) {
                    make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(250));
                    make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(250));
                } else if(ws.count == 4) {
                    make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(315));
                    make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(185));
                } else if(ws.count == 3) {
                    make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(400));
                    make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(100));
                }
                make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(214));
                make.bottom.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(186));
            }];
        }
        if(self.count >= 4) {
            _dButton = [self createButtonWithStr:@"D" imageName:nil tag:3];
            [self.bgView addSubview:self.dButton];
            [_dButton mas_makeConstraints:^(MASConstraintMaker *make) {
                if(ws.count == 5) {
                    make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(364));
                    make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(136));
                } else if(ws.count == 4) {
                    make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(445));
                    make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(55));
                }
                make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(214));
                make.bottom.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(186));
            }];
        }
        
        if(self.count == 5) {
            _eButton = [self createButtonWithStr:@"E" imageName:nil tag:4];
            [self.bgView addSubview:self.eButton];
            [_eButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(478));
                make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(22));
                make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(214));
                make.bottom.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(186));
            }];
        }
    } else if(self.count == 2) {
        _rightButton = [self createButtonWithStr:nil imageName:@"qs_choose_right" tag:0];
        [self.bgView addSubview:self.rightButton];
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(160));
            make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(340));
            make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(214));
            make.bottom.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(186));
        }];
        
        _wrongButton = [self createButtonWithStr:nil imageName:@"qs_choose_wrong" tag:1];
        [self.bgView addSubview:self.wrongButton];
        [_wrongButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(340));
            make.right.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(160));
            make.top.mas_equalTo(ws.bgView).offset(CCGetRealFromPt(214));
            make.bottom.mas_equalTo(ws.bgView).offset(-CCGetRealFromPt(186));
        }];
    }
    
    [self layoutIfNeeded];
}

-(UIButton *)closeBtn {
    if(!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = CCClearColor;
        _closeBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"qs_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

-(void)closeBtnClicked {
    if(self.closeblock) {
        self.closeblock();
    }
}

-(UILabel *)label {
    if(!_label) {
        _label = [UILabel new];
        _label.text = @"请选择答案";
        _label.textColor = CCRGBColor(51,51,51);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:FontSize_36];
    }
    return _label;
}

-(UILabel *)centerLabel {
    if(!_centerLabel) {
        _centerLabel = [UILabel new];
        _centerLabel.text = @"题干部分请参考文档或直播视频";
        _centerLabel.textColor = CCRGBColor(102,102,102);
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.font = [UIFont systemFontOfSize:FontSize_24];
    }
    return _centerLabel;
}

- (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIView *)labelBgView {
    if(!_labelBgView) {
        _labelBgView = [UIView new];
        _labelBgView.backgroundColor = CCRGBAColor(255,224,217,0.3);
        _labelBgView.layer.masksToBounds = YES;
        _labelBgView.layer.cornerRadius = CCGetRealFromPt(20);
    }
    return _labelBgView;
}

-(UIView *)lineView {
    if(!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = CCRGBAColor(255,102,51,0.5);
    }
    return _lineView;
}

-(UIImageView *)questionImage {
    if(!_questionImage) {
        _questionImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qs_pic_nav"]];
        _questionImage.backgroundColor = CCClearColor;
        _questionImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _questionImage;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    return;
}

-(UIButton *)submitBtn {
    if(_submitBtn == nil) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _submitBtn.backgroundColor = CCRGBColor(255,102,51);
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_32]];
        [_submitBtn setTitleColor:CCRGBAColor(255, 255, 255, 1) forState:UIControlStateNormal];
        [_submitBtn setTitleColor:CCRGBAColor(255, 255, 255, 0.4) forState:UIControlStateDisabled];
        [_submitBtn.layer setMasksToBounds:YES];
//        [_submitBtn.layer setBorderWidth:CCGetRealFromPt(2)];
//        [_submitBtn.layer setBorderColor:[CCRGBColor(252,92,61) CGColor]];
        [_submitBtn.layer setCornerRadius:CCGetRealFromPt(6)];
        [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_submitBtn setBackgroundImage:[self createImageWithColor:CCRGBColor(255,102,51)] forState:UIControlStateNormal];
        [_submitBtn setBackgroundImage:[self createImageWithColor:CCRGBAColor(255,102,51,0.8)] forState:UIControlStateDisabled];
    }
    return _submitBtn;
}

-(void)buttonClicked:(UIButton *)sender {
    [self.submitBtn setEnabled:YES];
    if(self.single == YES) {
        UIView *view = [self.bgView viewWithTag:_selectIndex + 10];
        UIImageView *imageView = [self.bgView viewWithTag:_selectIndex + 20];
        [imageView removeFromSuperview];
        [view removeFromSuperview];
        
        UIView *selectBorder = [[UIView alloc] init];
        selectBorder.backgroundColor = CCClearColor;
        selectBorder.layer.borderWidth = 1;
        selectBorder.layer.borderColor = [CCRGBColor(255,192,171) CGColor];
        selectBorder.layer.cornerRadius = sender.layer.cornerRadius;
        [self.bgView addSubview:selectBorder];
        selectBorder.tag = sender.tag + 10;
        [selectBorder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(sender);
        }];
        
        UIImageView *rightLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qs_choose"]];
        rightLogo.contentMode = UIViewContentModeScaleAspectFit;
        [self.bgView addSubview:rightLogo];
        rightLogo.tag = sender.tag + 20;
        _selectIndex = sender.tag;
        
        [rightLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(selectBorder).offset(CCGetRealFromPt(76));
            make.bottom.mas_equalTo(selectBorder).offset(-CCGetRealFromPt(76));
            make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(32),CCGetRealFromPt(32)));
        }];
        if(self.singleNOSubmit) {
            self.singleNOSubmit(_selectIndex);
        }
    } else {
        NSNumber *number = [NSNumber numberWithInteger:sender.tag];
        NSUInteger index = [self.selectIndexArray indexOfObject:number];
        if(index != NSNotFound) {
            UIView *view = [self.bgView viewWithTag:sender.tag + 10];
            UIImageView *imageView = [self.bgView viewWithTag:sender.tag + 20];
            [view removeFromSuperview];
            [imageView removeFromSuperview];
            [self.selectIndexArray removeObjectAtIndex:index];
        } else {
            UIView *selectBorder = [[UIView alloc] init];
            selectBorder.backgroundColor = CCClearColor;
            selectBorder.layer.borderWidth = 1;
            selectBorder.layer.borderColor = [CCRGBColor(255,192,171) CGColor];
            selectBorder.layer.cornerRadius = sender.layer.cornerRadius;
            [self.bgView addSubview:selectBorder];
            selectBorder.tag = sender.tag + 10;
            [selectBorder mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(sender);
            }];
//            selectBorder.userInteractionEnabled = YES;
            
            UIImageView *rightLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qs_choose"]];
            rightLogo.contentMode = UIViewContentModeScaleAspectFit;
            [self.bgView addSubview:rightLogo];
            rightLogo.tag = sender.tag + 20;
//            rightLogo.userInteractionEnabled = YES;
            
            [rightLogo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(selectBorder).offset(CCGetRealFromPt(76));
                make.bottom.mas_equalTo(selectBorder).offset(-CCGetRealFromPt(76));
                make.size.mas_equalTo(CGSizeMake(CCGetRealFromPt(32),CCGetRealFromPt(32)));
            }];
            
            [self.selectIndexArray addObject:number];
        }
        if(self.multipleNOSubmit) {
            self.multipleNOSubmit(_selectIndexArray);
        }
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint aPoint = [self convertPoint:point toView:self.aButton];
    CGPoint bPoint = [self convertPoint:point toView:self.bButton];
    CGPoint cPoint = [self convertPoint:point toView:self.cButton];
    CGPoint dPoint = [self convertPoint:point toView:self.dButton];
    CGPoint ePoint = [self convertPoint:point toView:self.eButton];
    if([self.aButton pointInside:aPoint withEvent:event]){
        return self.aButton;
    } else if ([self.bButton pointInside:bPoint withEvent:event]){
        return self.bButton;
    } else if ([self.cButton pointInside:cPoint withEvent:event]){
        return self.cButton;
    } else if ([self.dButton pointInside:dPoint withEvent:event]){
        return self.dButton;
    } else if ([self.eButton pointInside:ePoint withEvent:event]){
        return self.eButton;
    }
    return [super hitTest:point withEvent:event];
}

-(UIButton *)createButtonWithStr:(NSString *)str imageName:(NSString *)imageName tag:(NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentMode = UIViewContentModeScaleAspectFit;
    [button setBackgroundImage:[self createImageWithColor:CCRGBColor(255,240,236)] forState:UIControlStateNormal];
    [button setBackgroundImage:[self createImageWithColor:CCRGBColor(255,231,224)] forState:UIControlStateSelected];
    [button setBackgroundImage:[self createImageWithColor:CCRGBColor(255,231,224)] forState:UIControlStateHighlighted];
    [button.layer setMasksToBounds:YES];
    button.tag = tag;
    [button.layer setCornerRadius:CCGetRealFromPt(8)];
    [button.layer setBorderColor:[CCRGBColor(255,240,236) CGColor]];
    [button.layer setBorderWidth:1];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if(str) {
        UILabel *label = [UILabel new];
        label.text = str;
        label.textColor = CCRGBColor(255,100,61);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:FontSize_72];
        [button addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(button);
//            make.top.mas_equalTo(button).offset(CCGetRealFromPt(12));
//            make.right.mas_equalTo(button).offset(-CCGetRealFromPt(4));
        }];
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button addSubview:imageView];
        if([imageName isEqualToString:@"qs_choose_right"]) {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(button).offset(CCGetRealFromPt(15));
//                make.right.mas_equalTo(button).offset(CCGetRealFromPt(-15));
//                make.top.mas_equalTo(button).offset(CCGetRealFromPt(20));
//                make.bottom.mas_equalTo(button).offset(CCGetRealFromPt(-20));
                make.edges.mas_equalTo(button);
            }];
        } else if([imageName isEqualToString:@"qs_choose_wrong"]){
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(button).offset(CCGetRealFromPt(16));
//                make.right.mas_equalTo(button).offset(CCGetRealFromPt(-16));
//                make.top.mas_equalTo(button).offset(CCGetRealFromPt(20));
//                make.bottom.mas_equalTo(button).offset(CCGetRealFromPt(-20));
                make.edges.mas_equalTo(button);
            }];
        }
    }
    
    return button;
}

@end
