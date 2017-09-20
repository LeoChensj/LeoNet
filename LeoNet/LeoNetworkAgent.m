//
//  LeoNetworkAgent.m
//  
//
//  Created by Leo.Chen on 16/7/5.
//  Copyright © 2016年 Leo.Chen. All rights reserved.
//

#import "LeoNetworkAgent.h"
#import "LeoNetworkConfig.h"
#import "LeoNetworkPrivate.h"
#import "GreedJSON.h"

@implementation LeoNetworkAgent
{
    AFHTTPSessionManager *_manager;
    LeoNetworkConfig *_config;
    NSMutableDictionary *_requestsRecord;
}

+ (LeoNetworkAgent *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _config = [LeoNetworkConfig sharedInstance];
        _manager = [AFHTTPSessionManager manager];
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager.securityPolicy = _config.securityPolicy;
    }
    
    return self;
}

- (NSString *)buildRequestUrl:(LeoBaseRequest *)request
{
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"] ||[detailUrl hasPrefix:@"https"])
    {
        return detailUrl;
    }
    // filter url
    NSArray *filters = [_config urlFilters];
    for (id<LeoUrlFilterProtocol> f in filters)
    {
        detailUrl = [f filterUrl:detailUrl withRequest:request];
    }

    NSString *baseUrl;
    if ([request useCDN])
    {
        if ([request cdnUrl].length > 0)
        {
            baseUrl = [request cdnUrl];
        }
        else
        {
            baseUrl = [_config cdnUrl];
        }
    }
    else
    {
        if ([request baseUrl].length > 0)
        {
            baseUrl = [request baseUrl];
        }
        else
        {
            baseUrl = [_config baseUrl];
        }
    }
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

- (void)addRequest:(LeoBaseRequest *)request
{
    LeoRequestMethod method = [request requestMethod];
    
    NSString *url = [self buildRequestUrl:request];
    
    id requestParam = request.requestParam;
    

    if (request.requestSerializerType == LeoRequestSerializerTypeHTTP)
    {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else if (request.requestSerializerType == LeoRequestSerializerTypeJSON)
    {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    
    if (request.responseSerializerType == LeoResponseSerializerTypeHTTP)
    {
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    else if (request.responseSerializerType == LeoResponseSerializerTypeJSON)
    {
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    _manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    _manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];

    // if api need server username and password
    NSArray *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    if (authorizationHeaderFieldArray != nil)
    {
        [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)authorizationHeaderFieldArray.firstObject
                                                                   password:(NSString *)authorizationHeaderFieldArray.lastObject];
    }
    
    // if api need add custom value to HTTPHeaderField
    NSDictionary *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil)
    {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys)
        {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]])
            {
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            }
            else
            {
                LeoLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }

    if (method == LeoRequestMethodGet)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        request.requestTask = [_manager GET:url parameters:requestParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleRequestResult:task responseObject:responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleErrorResult:task error: error];
            
        }];
        [request.requestTask resume];
    }
    else if (method == LeoRequestMethodPost)
    {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        request.requestTask = [_manager POST:url parameters:requestParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleRequestResult:task responseObject:responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleErrorResult:task error: error];
            
        }];
        
        [request.requestTask resume];
    }
    else if (method == LeoRequestMethodHead)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        request.requestTask = [_manager HEAD:url parameters:requestParam success:^(NSURLSessionDataTask *task) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleRequestResult:task responseObject:nil];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleErrorResult:task error: error];
            
        }];
        
        [request.requestTask resume];
    }
    else if (method == LeoRequestMethodPut)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        url = [self urlWithUrl:url requestParam:requestParam];//PUT请求特殊处理
        
        request.requestTask = [_manager PUT:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleRequestResult:task responseObject:responseObject];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleErrorResult:task error: error];
            
        }];
        
        [request.requestTask resume];
    }
    else if (method == LeoRequestMethodDelete)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        request.requestTask = [_manager DELETE:url parameters:requestParam success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleRequestResult:task responseObject:responseObject];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleErrorResult:task error: error];
            
        }];
        
        [request.requestTask resume];
    }
    else if (method == LeoRequestMethodPatch)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        request.requestTask = [_manager PATCH:url parameters:requestParam success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleRequestResult:task responseObject:responseObject];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self handleErrorResult:task error: error];
            
        }];
        
        [request.requestTask resume];
    }
    else
    {
        LeoLog(@"Error, unsupport method type");
        return;
    }

    [self addTask:request];
}

- (void)cancelRequest:(LeoBaseRequest *)request
{
    [request.requestTask cancel];
    [self removeTask:request.requestTask];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests
{
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord)
    {
        LeoBaseRequest *request = copyRecord[key];
        [request stop];
    }
}

- (void)handleRequestResult:(NSURLSessionDataTask *)task responseObject:(id)responseObject
{
    if (responseObject == nil)
    {
        return;
    }
    
    NSString *key = [self requestHashKey:task];
    LeoBaseRequest *request = _requestsRecord[key];

    NSString *jsonValue = nil;
    if (request.responseSerializerType == LeoResponseSerializerTypeHTTP)
    {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        jsonValue = [request decrypt:string];
    }
    else if (request.responseSerializerType == LeoResponseSerializerTypeJSON)
    {
        jsonValue = [request decrypt:responseObject];
    }
    
    request.responseJSONObject = [jsonValue gr_object];

    if (request)
    {
        BOOL succeed = [request checkResult];
        if (succeed)
        {
            [request toggleAccessoriesWillStopCallBack];
            [request requestCompleteFilter];//写入缓存之类的操作
            if (request.delegate != nil)
            {
                [request.delegate requestFinished:request];
            }
            if (request.successCompletionBlock)
            {
                request.successCompletionBlock(request);
            }
            [request toggleAccessoriesDidStopCallBack];
        }
        else
        {
            [request toggleAccessoriesWillStopCallBack];
            [request requestFailedFilter];
            if (request.delegate != nil)
            {
                [request.delegate requestFailed:request];
            }
            if (request.failureCompletionBlock)
            {
                request.failureCompletionBlock(request);
            }
            [request toggleAccessoriesDidStopCallBack];
        }
    }
    [self removeTask:task];
    [request clearCompletionBlock];
}

- (void)handleErrorResult:(NSURLSessionDataTask *)task error:(NSError *)error
{
    NSString *key = [self requestHashKey:task];
    LeoBaseRequest *request = _requestsRecord[key];
    
    if (request)
    {
        [request toggleAccessoriesWillStopCallBack];
        [request requestFailedFilter];
        if (request.delegate != nil)
        {
            [request.delegate requestFailed:request];
        }
        if (request.failureCompletionBlock)
        {
            request.failureCompletionBlock(request);
        }
        
        [request toggleAccessoriesDidStopCallBack];
    }
    [self removeTask:task];
    [request clearCompletionBlock];
}


- (NSString *)requestHashKey:(NSURLSessionDataTask *)operation
{
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;
}

- (void)addTask:(LeoBaseRequest *)request
{
    if (request.requestTask != nil)
    {
        NSString *key = [self requestHashKey:request.requestTask];
        @synchronized(self)
        {
            _requestsRecord[key] = request;
        }
    }
}

- (void)removeTask:(NSURLSessionDataTask *)task
{
    NSString *key = [self requestHashKey:task];
    @synchronized(self)
    {
        [_requestsRecord removeObjectForKey:key];
    }
}


- (NSString *)urlWithUrl:(NSString *)url requestParam:(NSDictionary *)requestParam
{
    NSArray *keys = requestParam.allKeys;
    
    for (NSInteger i=0;i<keys.count;i++)
    {
        if(i==0)
        {
            NSString *value = [NSString stringWithFormat:@"%@", requestParam[keys[i]]];
            url = [NSString stringWithFormat:@"%@?%@=%@", url, keys[i], [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            NSString *value = [NSString stringWithFormat:@"%@", requestParam[keys[i]]];
            url = [NSString stringWithFormat:@"%@&%@=%@", url, keys[i], [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    return url;
}




@end
