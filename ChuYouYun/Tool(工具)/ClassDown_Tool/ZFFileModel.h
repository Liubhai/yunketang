//
//  ZFFileModel.h
//  dafengche
//
//  Created by IOS on 16/9/23.
//  Copyright © 2016年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZFDownLoadState) {
    ZFDownloading,      //下载中
    ZFWillDownload,     //等待下载
    ZFStopDownload      //停止下载
};

@interface ZFFileModel : NSObject

/** 文件名 */
@property (nonatomic,strong) NSString      *fileName;
/** 文件的总长度 */
@property (nonatomic,strong) NSString      *fileSize;
/** 文件的类型(文件后缀,比如:mp4)*/
@property (nonatomic,strong) NSString      *fileType;
/** 是否是第一次接受数据，如果是则不累加第一次返回的数据长度，之后变累加 */
@property (nonatomic,assign) BOOL          isFirstReceived;
/** 文件已下载的长度 */
@property (nonatomic,strong) NSString      *fileReceivedSize;
/** 接受的数据 */
@property (nonatomic,strong) NSMutableData *fileReceivedData;
/** 下载文件的URL */
@property (nonatomic,strong) NSString      *fileURL;
/** 下载时间 */
@property (nonatomic,strong) NSString      *time;
/** 临时文件路径 */
@property (nonatomic,strong) NSString      *tempPath;
/*下载状态的逻辑是这样的：三种状态，下载中，等待下载，停止下载
 *当超过最大下载数时，继续添加的下载会进入等待状态，当同时下载数少于最大限制时会自动开始下载等待状态的任务。
 *可以主动切换下载状态
 *所有任务以添加时间排序。
 */
@property (nonatomic, assign) ZFDownLoadState downloadState;
/** 是否下载出错 */
@property (nonatomic, assign) BOOL            error;
/** md5 */
@property (nonatomic,strong ) NSString        *MD5;
/** 文件的附属图片 */
@property (nonatomic,strong ) UIImage         *fileimage;


@end
