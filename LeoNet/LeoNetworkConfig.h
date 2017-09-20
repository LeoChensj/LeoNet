//
//  LeoNetworkConfig.h
//  
//
//  Created by Leo.Chen on 16/7/5.
//  Copyright © 2016年 Leo.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeoBaseRequest.h"

@protocol LeoUrlFilterProtocol <NSObject>
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(LeoBaseRequest *)request;
@end

@protocol LeoCacheDirPathFilterProtocol <NSObject>
- (NSString *)filterCacheDirPath:(NSString *)originPath withRequest:(LeoBaseRequest *)request;
@end

@interface LeoNetworkConfig : NSObject

+ (LeoNetworkConfig *)sharedInstance;

@property (strong, nonatomic) NSString *baseUrl;
@property (strong, nonatomic) NSString *cdnUrl;
@property (strong, nonatomic, readonly) NSArray *urlFilters;
@property (strong, nonatomic, readonly) NSArray *cacheDirPathFilters;
@property (strong, nonatomic) AFSecurityPolicy *securityPolicy;

- (void)addUrlFilter:(id<LeoUrlFilterProtocol>)filter;
- (void)addCacheDirPathFilter:(id <LeoCacheDirPathFilterProtocol>)filter;

@end
