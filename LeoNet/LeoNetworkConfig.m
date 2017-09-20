//
//  LeoNetworkConfig.m
//  
//
//  Created by Leo.Chen on 16/7/5.
//  Copyright © 2016年 Leo.Chen. All rights reserved.
//

#import "LeoNetworkConfig.h"

@implementation LeoNetworkConfig
{
    NSMutableArray *_urlFilters;
    NSMutableArray *_cacheDirPathFilters;
}

+ (LeoNetworkConfig *)sharedInstance
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
    if (self) {
        _urlFilters = [NSMutableArray array];
        _cacheDirPathFilters = [NSMutableArray array];
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
    }
    
    return self;
}

- (void)addUrlFilter:(id<LeoUrlFilterProtocol>)filter
{
    [_urlFilters addObject:filter];
}

- (void)addCacheDirPathFilter:(id<LeoCacheDirPathFilterProtocol>)filter
{
    [_cacheDirPathFilters addObject:filter];
}

- (NSArray *)urlFilters
{
    return [_urlFilters copy];
}

- (NSArray *)cacheDirPathFilters
{
    return [_cacheDirPathFilters copy];
}

@end
