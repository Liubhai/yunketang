//
//  YunKeTang_Api_Tool.m
//  YunKeTang
//
//  Created by 赛新科技 on 2018/5/17.
//  Copyright © 2018年 ZhiYiForMac. All rights reserved.
//

//临时
//#define EncryptUrl @"En-Params"

#import "YunKeTang_Api_Tool.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "AESCrypt.h"
#import "NSData+CommonCrypto.h"
#import "NSString+AESSecurity.h"
#import "SYG.h"
#import "NSString+SBJSON.h"
#import "SBJsonParser.h"


@implementation YunKeTang_Api_Tool

//加密
+ (NSString *)YunKeTang_Api_Tool_GetEncryptStr:(NSDictionary *)dict {
    
    if (dict == nil) {
        return nil;
    }
    //处理唯一登录
    [dict setValue:Only_Login_Key forKey:@"only_login_key"];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
    NSString *newStr = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:nil error:&error];
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        newStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *keyStr = [NSString stringWithFormat:@"%@|%@",timeSp,newStr];
    NSString *encryptStr = [NSString encrypyAES:keyStr key:NetKey];
    //替换特殊符号
    encryptStr = [encryptStr stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    encryptStr = [encryptStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return encryptStr;
}

//解密
+ (NSDictionary *)YunKeTang_Api_Tool_GetDecodeStr:(id)responseObject {
    
    NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSData * receiveData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
    
    if ([[jsonDict stringValueForKey:@"code"] integerValue] == 0) {
        return jsonDict;
    }
    
    NSString *dataStr = [jsonDict stringValueForKey:@"data"];
    if (dataStr == nil) {
        return nil;
    }
    if ([dataStr isKindOfClass:[NSArray class]]) {
        return nil;
    }
    if ([dataStr isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)dataStr;
    }
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    
    NSString *decodeStr = [NSString descryptAES:dataStr key:NetKey];
    NSString *fromStr = [decodeStr substringFromIndex:11];
    SBJsonParser* json =[[SBJsonParser alloc]init];
    NSMutableDictionary* dic =[json objectWithString:fromStr];
    
    return dic;
}

//解密之前的判断
+ (NSDictionary *)YunKeTang_Api_Tool_GetDecodeStr_Before:(id)responseObject {
    
    NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSData * receiveData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
    return jsonDict;
}

//
+ (NSDictionary *)YunKeTang_Api_Tool_WithJson:(NSString *)dataStr {
    NSString *dataString = nil;
    dataString = [dataStr stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    dataString = [dataString stringByReplacingOccurrencesOfString:@"_" withString:@"/"];

    NSString *decodeStr = [NSString descryptAES:dataString key:NetKey];
    NSString *fromStr = [decodeStr substringFromIndex:11];
    SBJsonParser* json =[[SBJsonParser alloc]init];
    NSMutableDictionary* dic =[json objectWithString:fromStr];

    return dic;
}

#pragma mark ---- Tool

- (NSString *)jsonStringWithDict:(NSDictionary *)dict {
    NSError *error;
    // 注
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingSortedKeys error:&error];
    
    // NSJSONWritingSortedKeys这个枚举类型只适用iOS11所以我是使用下面写法解决的
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:nil error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

#pragma mark --- 拼接字符串的方法
+ (NSString *)YunKeTang_GetFullUrl:(NSString *)string {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",EncryptUrl,string];
    return urlStr;
}






@end
