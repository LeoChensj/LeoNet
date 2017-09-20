//
//  LeoNetworkAgent.h
//  
//
//  Created by Leo.Chen on 16/7/5.
//  Copyright © 2016年 Leo.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeoBaseRequest.h"
#import "AFNetworking.h"

@interface LeoNetworkAgent : NSObject

+ (LeoNetworkAgent *)sharedInstance;

- (void)addRequest:(LeoBaseRequest *)request;

- (void)cancelRequest:(LeoBaseRequest *)request;

- (void)cancelAllRequests;

/// 根据request和networkConfig构建url
- (NSString *)buildRequestUrl:(LeoBaseRequest *)request;

@end
