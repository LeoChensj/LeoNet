//
//  LeoBaseRequest.h
//  
//
//  Created by Leo.Chen on 16/7/5.
//  Copyright © 2016年 Leo.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger , LeoRequestMethod) {
    LeoRequestMethodGet = 0,
    LeoRequestMethodPost,
    LeoRequestMethodHead,
    LeoRequestMethodPut,
    LeoRequestMethodDelete,
    LeoRequestMethodPatch
};

typedef NS_ENUM(NSInteger , LeoRequestSerializerType) {
    LeoRequestSerializerTypeHTTP = 0,
    LeoRequestSerializerTypeJSON,
};

typedef NS_ENUM(NSInteger , LeoResponseSerializerType) {
    LeoResponseSerializerTypeHTTP = 0,
    LeoResponseSerializerTypeJSON,
};


@class LeoBaseRequest;

typedef void(^LeoRequestCompletionSuccessBlock)(__kindof LeoBaseRequest *request);
typedef void(^LeoRequestCompletionFailBlock)(__kindof LeoBaseRequest *request);

@protocol LeoRequestDelegate <NSObject>

@optional

- (void)requestFinished:(LeoBaseRequest *)request;
- (void)requestFailed:(LeoBaseRequest *)request;
- (void)clearRequest;

@end

@protocol LeoRequestAccessory <NSObject>

@optional

- (void)requestWillStart:(id)request;
- (void)requestWillStop:(id)request;
- (void)requestDidStop:(id)request;

@end

@interface LeoBaseRequest : NSObject

/// Tag
@property (nonatomic) NSInteger tag;

/// User info
@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong) NSURLSessionDataTask *requestTask;

@property (nonatomic, strong) AFHTTPSessionManager *requestSessionManager;

/// request delegate object
@property (nonatomic, weak) id<LeoRequestDelegate> delegate;

@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;

@property (nonatomic, strong) id responseJSONObject;

@property (nonatomic, strong) id requestParam;

@property (nonatomic, copy) LeoRequestCompletionSuccessBlock successCompletionBlock;

@property (nonatomic, copy) LeoRequestCompletionFailBlock failureCompletionBlock;

@property (nonatomic, strong) NSMutableArray *requestAccessories;

// append self to request queue
- (void)start;

// remove self from request queue
- (void)stop;

- (NSURLSessionTaskState)status;

// block回调
- (void)startWithCompletionBlockWithSuccess:(LeoRequestCompletionSuccessBlock)success
                                    failure:(LeoRequestCompletionFailBlock)failure;

- (void)setCompletionBlockWithSuccess:(LeoRequestCompletionSuccessBlock)success
                              failure:(LeoRequestCompletionFailBlock)failure;

// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

// Request Accessory，可以hook Request的start和stop
- (void)addAccessory:(id<LeoRequestAccessory>)accessory;

// 以下方法由子类继承来覆盖默认值

// 请求成功的回调
- (void)requestCompleteFilter;

/// 请求失败的回调
- (void)requestFailedFilter;

/// 请求的URL
- (NSString *)requestUrl;

// 请求的CdnURL
- (NSString *)cdnUrl;

// 请求的BaseURL
- (NSString *)baseUrl;

// 请求的连接超时时间，默认为60秒
- (NSTimeInterval)requestTimeoutInterval;

// 请求的参数列表
- (id)requestParam;

// 返回数据解密
- (id)decrypt:(NSString *)string;

// 用于在cache结果，计算cache文件名时，忽略掉一些指定的参数
- (id)cacheFileNameFilterForRequestArgument:(id)argument;

// Http请求的方法
- (LeoRequestMethod)requestMethod;

// 请求的SerializerType
- (LeoRequestSerializerType)requestSerializerType;

//返回的SerializerType
- (LeoResponseSerializerType)responseSerializerType;

// 请求的Server用户名和密码
- (NSArray *)requestAuthorizationHeaderFieldArray;

// 在HTTP报头添加的自定义参数
- (NSDictionary *)requestHeaderFieldValueDictionary;

// 是否使用CDN的host地址
- (BOOL)useCDN;

// 用于检查JSON是否合法的对象
- (id)jsonValidator;

//检查结果
- (BOOL)checkResult;

//获取返回码
- (NSInteger)getRetCode;

//获取错误消息
- (NSString*)getErrorMsg;

//返回结果
- (id)responseModel;


@end
