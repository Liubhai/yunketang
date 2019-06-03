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

@end
