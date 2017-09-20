//
//  Request.m
//  LeoNetDemo
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "Request.h"

@implementation Request

- (NSTimeInterval)requestTimeoutInterval
{
    return 30;
}

- (LeoRequestMethod)requestMethod
{
    return LeoRequestMethodPost;
}

- (LeoRequestSerializerType)requestSerializerType
{
    return LeoRequestSerializerTypeHTTP;
}

- (LeoResponseSerializerType)responseSerializerType
{
    return LeoResponseSerializerTypeHTTP;
}

- (BOOL)checkResult
{
    if (self.responseJSONObject)
    {
//        NSNumber *code = [self.responseJSONObject objectForKey:@"code"];
//        if(code && code.integerValue==200)
//        {
//            return YES;
//        }
        
        return YES;
    }
    
    return NO;
}

- (NSInteger)getRetCode
{
    if (self.responseJSONObject)
    {
        return [[self.responseJSONObject objectForKey:@"code"] integerValue];
    }
    
    return -999;
}

- (NSString *)getErrorMsg
{
    if (self.responseJSONObject)
    {
        return [self.responseJSONObject objectForKey:@"msg"];
    }
    
    return @"您的网络不太给力，请稍后再试";
}

- (id)decrypt:(NSString *)string
{
    //这里加入解密代码
    return string;
}

- (id)responseModel
{
    return nil;
}

@end
