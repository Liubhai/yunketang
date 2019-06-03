//
//  RequestData.h
//  CCavPlayDemo
//
//  Created by ma yige on 15/6/29.
//  Copyright (c) 2015年 ma yige. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PlayParameter.h"
#import "IJKMediaFrameworkWithSSL/IJKMediaPlayback.h"
#import "IJKMediaFrameworkWithSSL/IJKFFMoviePlayerController.h"

@protocol RequestDataDelegate <NSObject>
@optional
//@optional
/**
 *	@brief	请求播放地址成功
 */
-(void)requestSucceed;
/**
 *	@brief	请求播放地址失败
 */
-(void)requestFailed:(NSError *)error reason:(NSString *)reason;
/**
 *	@brief  收到提问，用户观看时和主讲的互动问答信息
 */
- (void)onQuestionDic:(NSDictionary *)questionDic;
/**
 *	@brief  收到回答，用户观看时和主讲的互动问答信息
 */
- (void)onAnswerDic:(NSDictionary *)answerDic;
/**
 *	@brief  收到提问&回答，在用户登录之前，主讲和其他用户的历史互动问答信息
 */
- (void)onQuestionArr:(NSArray *)questionArr onAnswerArr:(NSArray *)answerArr;
/**
 *	@brief  主讲开始推流
 */
- (void)onLiveStatusChangeStart;
/**
 *	@brief  停止直播，endNormal表示是否异常停止推流，这个参数对观看端影响不大
 */
- (void)onLiveStatusChangeEnd:(BOOL)endNormal;
/**
 *	@brief  收到公聊消息
 */
- (void)onPublicChatMessage:(NSDictionary *)message;
/**
 *	@brief	收到私聊信息
 */
- (void)OnPrivateChat:(NSDictionary *)dic;
/*
 *  @brief  收到自己的禁言消息，如果你被禁言了，你发出的消息只有你自己能看到，其他人看不到
 */
- (void)onSilenceUserChatMessage:(NSDictionary *)message;
/**
 *	@brief	收到在线人数
 */
- (void)onUserCount:(NSString *)count;
/**
 *	@brief	当主讲全体禁言时，你再发消息，会出发此代理方法，information是禁言提示信息
 */
- (void)information:(NSString *)information;
/**
 *	@brief	服务器端给自己设置的UserId
 */
-(void)setMyViewerId:(NSString *)viewerId;
/**
 *	@brief  收到踢出消息，停止推流并退出播放（被主播踢出）
 */
- (void)onKickOut;
/**
 *	@brief  获取房间信息，主要是要获取直播间模版来类型，根据直播间模版类型来确定界面布局
 *	房间简介：dic[@"desc"];
 *	房间名称：dic[@"name"];
 *	房间模版类型：[dic[@"templateType"] integerValue];
 *	模版类型为1: 聊天互动： 无 直播文档： 无 直播问答： 无
 *	模版类型为2: 聊天互动： 有 直播文档： 无 直播问答： 有
 *	模版类型为3: 聊天互动： 有 直播文档： 无 直播问答： 无
 *	模版类型为4: 聊天互动： 有 直播文档： 有 直播问答： 无
 *	模版类型为5: 聊天互动： 有 直播文档： 有 直播问答： 有
 *	模版类型为6: 聊天互动： 无 直播文档： 无 直播问答： 有
 */
-(void)roomInfo:(NSDictionary *)dic;
/**
 *	@brief  收到播放直播状态 0直播 1未直播
 */
- (void)getPlayStatue:(NSInteger)status;
/**
 *	@brief  获取文档内白板或者文档本身的宽高，来进行屏幕适配用的
 */
- (void)getDocAspectRatioOfWidth:(CGFloat)width height:(CGFloat)height;
/**
 *	@brief  登录成功
 */
- (void)loginSucceedPlay;
/**
 *	@brief  登录失败
 */
-(void)loginFailed:(NSError *)error reason:(NSString *)reason;
/*
 *  @brief WebRTC连接成功，在此代理方法中主要做一些界面的更改
 */
- (void)connectWebRTCSuccess;
/*
 *  @brief 当前是否可以连麦
 */
- (void)whetherOrNotConnectWebRTCNow:(BOOL)connect;
/*
 *  @brief 主播端接受连麦请求，在此代理方法中，要调用DequestData对象的
 *  - (void)saveUserInfo:(NSDictionary *)dict remoteView:(UIView *)remoteView;方法
 *  把收到的字典参数和远程连麦页面的view传进来，这个view需要自己设置并发给SDK，SDK将要在这个view上进行渲染
 */
- (void)acceptSpeak:(NSDictionary *)dict;
/*
 *  @brief 主播端发送断开连麦的消息，收到此消息后做断开连麦操作
 */
-(void)speak_disconnect:(BOOL)isAllow;
/*
 *  @brief 本房间为允许连麦的房间，会回调此方法，在此方法中主要设置UI的逻辑，
 *  在断开推流,登录进入直播间和改变房间是否允许连麦状态的时候，都会回调此方法
 */
- (void)allowSpeakInteraction:(BOOL)isAllow;
/*
 *  @brief 切换源，firRoadNum表示一共有几个源，secRoadKeyArray表示每
 *  个源的描述数组，具体参见demo，firRoadNum是下拉列表有面的tableviewcell
 *  的行数，secRoadKeyArray是左面的tableviewcell的描述信息数组
 */
- (void)firRoad:(NSInteger)firRoadNum secRoadKeyArray:(NSArray *)secRoadKeyArray;
/*
 *  自定义消息
 */
- (void)customMessage:(NSString *)message;
/*
 *  公告
 */
- (void)announcement:(NSString *)str;
/*
 *  监听到有公告消息
 */
- (void)on_announcement:(NSDictionary *)dict;
/*
 *  开始抽奖
 */
- (void)start_lottery;
/*
 *  抽奖结果
 */
- (void)lottery_resultWithCode:(NSString *)code myself:(BOOL)myself winnerName:(NSString *)winnerName;
/*
 *  退出抽奖
 */
- (void)stop_lottery;
/*
 *  开始签到
 */
- (void)start_rollcall:(NSInteger)duration;
/*
 *  开始答题
 */
- (void)start_vote:(NSInteger)count singleSelection:(BOOL)single;
/*
 *  结束答题
 */
- (void)stop_vote;
/*
 *  答题结果
 */
- (void)vote_result:(NSDictionary *)resultDic;

@end

@interface RequestData : NSObject

@property (weak,nonatomic) id<RequestDataDelegate>      delegate;
@property (retain,    atomic) id<IJKMediaPlayback>      ijkPlayer;

/**
 *	@brief	登录房间
 *	@param 	parameter   配置参数信息
 *  必填参数 userId;
 *  必填参数 roomId;
 *  必填参数 viewerName;
 *  必填参数 token;
 *  必填参数 security;
 *  （选填参数） viewercustomua;
 */
- (id)initLoginWithParameter:(PlayParameter *)parameter;
/**
 *	@brief	进入房间，并请求画图聊天数据并播放视频（可以不登陆，直接从此接口进入直播间）
 *	@param 	parameter   配置参数信息
 *  必填参数 docFrame;
 *  必填参数 userId;
 *  必填参数 roomId;
 *  必填参数 docParent;
 *  必填参数 viewerName;
 *  必填参数 token;
 *  必填参数 playerFrame;
 *  必填参数 playerParent;
 *  必填参数 scalingMode;
 *  必填参数 security;
 *  （选填参数） viewercustomua;
 */
- (id)initWithParameter:(PlayParameter *)parameter;
/**
 *	@brief	提问
 *	@param 	message 提问内容
 */
- (void)question:(NSString *)message;
/**
 *	@brief	发送公聊信息
 *	@param 	message  发送的消息内容
 */
- (void)chatMessage:(NSString *)message;
/**
 *	@brief  发送私聊信息
 */
- (void)privateChatWithTouserid:(NSString *)touserid msg:(NSString *)msg;
/**
 *	@brief	销毁文档和视频，清除视频和文档的时候需要调用,推出播放页面的时候也需要调用
 */
- (void)requestCancel;
/**
 *	@brief  获取在线房间人数，当登录成功后即可调用此接口，登录不成功或者退出登录后就不可以调用了，如果要求实时性比较强的话，可以写一个定时器，不断调用此接口，几秒钟发一次就可以，然后在代理回调函数中，处理返回的数据
 */
- (void)roomUserCount;
/**
 *	@brief  获取文档区域内白板或者文档本身的宽高比，返回值即为宽高比，做屏幕适配用
 */
- (CGFloat)getDocAspectRatio;
/**
 *	@brief  设置文档区域大小,主要用在文档生成后改变文档窗口的frame
 */
- (void)setDocFrame:(CGRect) docFrame;
/**
 *	@brief  设置播放器frame
 */
- (void)setPlayerFrame:(CGRect) playerFrame;
/**
 *	@brief  播放器暂停
 */
- (void)pausePlayer;
/**
 *	@brief  播放器播放
 */
- (void)startPlayer;
/**
 *	@brief  播放器关闭并移除
 */
- (void)shutdownPlayer;
/**
 *	@brief  播放器停止
 */
- (void)stopPlayer;
/**
 *	@brief   切换播放线路
 *  firIndex表示第几个源
 *  key表示该源对应的描述信息
 */
- (void)switchToPlayUrlWithFirIndex:(NSInteger)firIndex key:(NSString *)key;
/*
 * 当收到- (void)acceptSpeak:(NSDictionary *)dict;回调方法后，调用此方法
 * dict 正是- (void)acceptSpeak:(NSDictionary *)dict;接收到的的参数
 * remoteView 是远程连麦页面的view，需要自己设置并发给SDK，SDK将要在这个view上进行远程画面渲染
 */
- (void)saveUserInfo:(NSDictionary *)dict remoteView:(UIView *)remoteView;
/*
 * 观看端主动断开连麦时候需要调用的接口
 */
- (void)disConnectSpeak;
/*
 * 当观看端主动申请连麦时，需要调用这个接口，并把本地连麦预览窗口传给SDK，SDK会在这个view上
 * 进行远程画面渲染
 */
-(void)requestAVMessageWithLocalView:(UIView *)localView;
/*
 *设置本地预览窗口的大小，连麦成功后调用才生效，连麦不成功调用不生效
 */
-(void)setLocalVideoFrameA:(CGRect)localVideoFrame;
/*
 *设置远程连麦窗口的大小，连麦成功后调用才生效，连麦不成功调用不生效
 */
-(void)setRemoteVideoFrameA:(CGRect)remoteVideoFrame;
/*
 *将要连接WebRTC
 */
-(void)gotoConnectWebRTC;
/*
 * 重新加载视频,参数force表示是否强制重新加载视频，
 * 一般重新加载视频的时间间隔应该超过3秒，如果强制重新加载视频，时间间隔可以在3S之内
 */
-(void)reloadVideo:(BOOL)force;
/*
 *签到
 */
-(void)answer_rollcall;
/*
 *答单选题
 */
-(void)reply_vote_single:(NSInteger)index;
/*
 *答多选题
 */
-(void)reply_vote_multiple:(NSMutableArray *)indexArray;
/**
 *	@brief  播放器是否播放
 */
- (BOOL)isPlaying;

@end
