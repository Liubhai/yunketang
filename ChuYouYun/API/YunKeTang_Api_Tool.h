//
//  YunKeTang_Api_Tool.h
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/17.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YunKeTang_Api_Tool : NSObject

+ (NSString *)YunKeTang_Api_Tool_GetEncryptStr:(NSDictionary *)dict;
+ (NSDictionary *)YunKeTang_Api_Tool_GetDecodeStr:(id)responseObject;
+ (NSDictionary *)YunKeTang_Api_Tool_GetDecodeStr_Before:(id)responseObject;
+ (NSDictionary *)YunKeTang_Api_Tool_WithJson:(NSString *)dataStr;
+ (NSString *)YunKeTang_GetFullUrl:(NSString *)string;

// 解析接口数据,先解析成json 然后判断 data 里面数据 如果数据正常,则返回 data 里面的数据 ,如果data 里面还有密文 那就再解密在返回json类型数据
+ (id)YunKeTang_Api_Tool_GetDecodeStrFromData:(id)responseObject;

@end
