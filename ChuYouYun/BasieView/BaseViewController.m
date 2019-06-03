//
//  BaseViewController.m
//  zlydoc-iphone
//  Parent View Controller
//  Created by Ryan on 14-5-23.
//  Copyright (c) 2014年 zlycare. All rights reserved.
//

#import "BaseViewController.h"
#import "SYG.h"

#define MainScreenWidth self.view.bounds.size.width


@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.navigationController.navigationBar.hidden =YES;
//    self.fd_prefersNavigationBarHidden =YES;
	
//	self.navigationController.interactivePopGestureRecognizer.delegate = self;
	_titleImage = [[UIImageView alloc]init];
    _titleImage.frame = CGRectMake(0, 0, MainScreenWidth, 44);
	_titleImage.backgroundColor = [UIColor whiteColor];
	_titleImage.userInteractionEnabled = YES;
    [self.view addSubview:_titleImage];
	
	UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, MainScreenWidth, 0.5)];
	lineView.backgroundColor = [UIColor redColor];
	[_titleImage addSubview:lineView];
    
	_titleLabel = [[UILabel alloc]init];
	[_titleLabel setTextColor:[UIColor whiteColor]];
	[_titleLabel setBackgroundColor:[UIColor clearColor]];
	[_titleLabel setTextAlignment:NSTextAlignmentCenter];
	[_titleLabel setFont:[UIFont systemFontOfSize:20.0]];
	_titleLabel.frame = CGRectMake(50, 10, MainScreenWidth-100, 34);
	[_titleImage addSubview:_titleLabel];
	
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 11, 44, 44);
//	[_leftButton setTitleColor:BLUECOLOR forState:0];
	[_leftButton setImage:[UIImage imageNamed:@"焦点按钮@2x"] forState:0];
    [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(MainScreenWidth-52, 11, 44, 44);
	[_rightButton setTitleColor:[UIColor blueColor] forState:0];
    [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImage addSubview:_rightButton];
	
//    if (IOS7) {
//        _titleImage.frame = CGRectMake(0, 0, MainScreenWidth, 64);
//        _titleLabel.frame = CGRectMake(50, 27, MainScreenWidth-100, 34);
//        _leftButton.frame = CGRectMake(0, 22, 54, 44);
//        _rightButton.frame = CGRectMake(MainScreenWidth-52, 22, 53, 44);
//		lineView.frame = CGRectMake(0, 63.5, MainScreenWidth, 0.5);
//    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
	if (self.navigationController.viewControllers.count == 1) {
		return NO;
	}else{
		return YES;
	}
}

-(void)leftButtonClick:(id)sender{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonClick:(id)sender {
	
}




@end
