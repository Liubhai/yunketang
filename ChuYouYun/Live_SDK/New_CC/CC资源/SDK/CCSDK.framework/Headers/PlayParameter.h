//
//  Parameter.h
//  CCLivePlayDemo
//
//  Created by cc on 2017/3/9.
//  Copyright © 2017年 ma yige. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PlayParameter : NSObject

@property(nonatomic, copy)NSString                      *userId;//用户ID
@property(nonatomic, copy)NSString                      *roomId;//房间ID
@property(nonatomic, copy)NSString                      *viewerName;//用户名称
@property(nonatomic, copy)NSString                      *token;//房间密码
@property(nonatomic, copy)NSString                      *liveid;//回放ID，回放时才用到
@property(nonatomic, copy)NSString                      *viewercustomua;//用户自定义参数，需和后台协商，没有定制传@""
@property(nonatomic, copy)NSString                      *destination;//下载文件解压到的目录路径(离线下载相关)
@property(nonatomic,strong)UIView                       *docParent;//文档父类窗口
@property(nonatomic,assign)CGRect                       docFrame;//文档区域
@property(nonatomic,strong)UIView                       *playerParent;//视频父类窗口
@property(nonatomic,assign)CGRect                       playerFrame;//视频区域
@property(nonatomic,assign)BOOL                         security;//是否使用https，静态库暂时只能使用http协议
/*
 * 0:IJKMPMovieScalingModeNone
 * 1:IJKMPMovieScalingModeAspectFit
 * 2:IJKMPMovieScalingModeAspectFill
 * 3:IJKMPMovieScalingModeFill
 */
@property(assign, nonatomic)NSInteger                   scalingMode;//屏幕适配方式，含义见上面


@end
