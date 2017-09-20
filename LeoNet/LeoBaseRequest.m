//
//  LeoBaseRequest.m
//  
//
//  Created by Leo.Chen on 16/7/5.
//  Copyright © 2016年 Leo.Chen. All rights reserved.
//

#import "LeoBaseRequest.h"
#import "LeoNetworkAgent.h"
#import "LeoNetworkPrivate.h"

@implementation LeoBaseRequest

/// for subclasses to overwrite
- (void)requestCompleteFilter
{
}

- (void)requestFailedFilter
{
}

- (NSString *)requestUrl
{
    return @"";
}

- (NSString *)cdnUrl
{
    return @"";
}

- (NSString *)baseUrl
{
    return @"";
}

- (NSTimeInterval)requestTimeoutInterval
{
    return 60;
}

- (id)requestParam
{
    return nil;
}

- (id)decrypt:(NSString *)string
{
    return nil;
}

- (id)cacheFileNameFilterForRequestArgument:(id)argument
{
    return argument;
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

- (NSArray *)requestAuthorizationHeaderFieldArray
{
    return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary
{
    return nil;
}

- (BOOL)useCDN
{
    return NO;
}

- (id)jsonValidator
{
    return nil;
}

/// append self to request queue
- (void)start
{
    [self toggleAccessoriesWillStartCallBack];
    [[LeoNetworkAgent sharedInstance] addRequest:self];
}

/// remove self from request queue
- (void)stop
{
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[LeoNetworkAgent sharedInstance] cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}

- (NSURLSessionTaskState)status
{
    return self.requestTask.state;
}

- (void)startWithCompletionBlockWithSuccess:(LeoRequestCompletionSuccessBlock)success
                                    failure:(LeoRequestCompletionFailBlock)failure
{
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(LeoRequestCompletionSuccessBlock)success
                              failure:(LeoRequestCompletionFailBlock)failure
{
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock
{
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (id)responseJSONObject
{
    //return nil;
    return _responseJSONObject;
}

#pragma mark - Request Accessoies

- (void)addAccessory:(id<LeoRequestAccessory>)accessory
{
    if (!self.requestAccessories)
    {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}

- (BOOL)checkResult
{
    return NO;
}

- (NSInteger)getRetCode
{
    return -999;
}

- (NSString*)getErrorMsg
{
    return nil;
}

- (id)responseModel
{
    return nil;
}

@end
