//
//  LeoRequest.m
//
//
//  Created by Leo.Chen on 16/7/5.
//  Copyright © 2016年 Leo.Chen. All rights reserved.
//

#import "LeoNetworkConfig.h"
#import "LeoRequest.h"
#import "LeoNetworkPrivate.h"
#import "NSString+MD5.h"

@interface LeoRequest()

@property (strong, nonatomic) id cacheJson;

@end

@implementation LeoRequest
{
    BOOL _dataFromCache;
}

- (NSInteger)cacheTimeInSeconds
{
    return -1;
}

- (long long)cacheVersion
{
    return 0;
}

- (id)cacheSensitiveData
{
    return nil;
}

- (BOOL)ignoreCache
{
    return YES;
}

- (void)checkDirectory:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir])
    {
        [self createBaseDirectoryAtPath:path];
    }
    else
    {
        if (!isDir)
        {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}

- (void)createBaseDirectoryAtPath:(NSString *)path
{
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error)
    {
        LeoLog(@"create cache directory failed, error = %@", error);
    }
    else
    {
    }
}

- (NSString *)cacheBasePath
{
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"LazyRequestCache"];

    // filter cache base path
    NSArray *filters = [[LeoNetworkConfig sharedInstance] cacheDirPathFilters];
    if (filters.count > 0)
    {
        for (id<LeoCacheDirPathFilterProtocol> f in filters)
        {
            path = [f filterCacheDirPath:path withRequest:self];
        }
    }

    [self checkDirectory:path];
    return path;
}

- (NSString *)cacheFileName
{
    NSString *requestUrl = [self requestUrl];
    NSString *baseUrl = [LeoNetworkConfig sharedInstance].baseUrl;
    id argument = [self cacheFileNameFilterForRequestArgument:[self requestParam]];
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%zd Host:%@ Url:%@ Argument:%@ AppVersion:%@ Sensitive:%@",
                                                        [self requestMethod], baseUrl, requestUrl,
                                                        argument, [LeoNetworkPrivate appVersionString], [self cacheSensitiveData]];
    NSString *cacheFileName = [requestInfo MD5Digest];
    return cacheFileName;
}

- (NSString *)cacheFilePath
{
    NSString *cacheFileName = [self cacheFileName];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}

- (NSString *)cacheVersionFilePath
{
    NSString *cacheVersionFileName = [NSString stringWithFormat:@"%@.version", [self cacheFileName]];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheVersionFileName];
    return path;
}

- (long long)cacheVersionFileContent
{
    NSString *path = [self cacheVersionFilePath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil])
    {
        NSNumber *version = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        return [version longLongValue];
    }
    else
    {
        return 0;
    }
}

- (int)cacheFileDuration:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // get file attribute
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path
                                                             error:&attributesRetrievalError];
    if (!attributes)
    {
        LeoLog(@"Error get attributes for file at %@: %@", path, attributesRetrievalError);
        return -1;
    }
    int seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    return seconds;
}

- (void)start
{
    if ([self ignoreCache] == YES)
    {
        [super start];
        return;
    }

    // check cache time
    if ([self cacheTimeInSeconds] < 0)
    {
        [super start];
        return;
    }

    // check cache version
    long long cacheVersionFileContent = [self cacheVersionFileContent];
    if (cacheVersionFileContent != [self cacheVersion])
    {
        [super start];
        return;
    }

    // check cache existance
    NSString *path = [self cacheFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path isDirectory:nil])
    {
        [super start];
        return;
    }

    // check cache time
    int seconds = [self cacheFileDuration:path];
    if (seconds < 0 || seconds > [self cacheTimeInSeconds])
    {
        [super start];
        return;
    }

    // load cache
    _cacheJson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (_cacheJson == nil)
    {
        [super start];
        return;
    }

    _dataFromCache = YES;
    [self requestCompleteFilter];
    LeoRequest *strongSelf = self;
    strongSelf.responseJSONObject = [self cacheJson];//新加
    [strongSelf.delegate requestFinished:strongSelf];
    if (strongSelf.successCompletionBlock)
    {
        strongSelf.successCompletionBlock(strongSelf);
    }
    [strongSelf clearCompletionBlock];
}

- (void)startWithoutCache
{
    [super start];
}

- (id)cacheJson
{
    if (_cacheJson)
    {
        return _cacheJson;
    }
    else
    {
        NSString *path = [self cacheFilePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path isDirectory:nil] == YES)
        {
            _cacheJson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        }
        return _cacheJson;
    }
}

- (BOOL)isDataFromCache
{
    return _dataFromCache;
}

- (BOOL)isCacheVersionExpired
{
    // check cache version
    long long cacheVersionFileContent = [self cacheVersionFileContent];
    if (cacheVersionFileContent != [self cacheVersion])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (id)responseJSONObject
{
    if (_cacheJson)
    {
        return _cacheJson;
    }
    else
    {
        return [super responseJSONObject];
    }
}

#pragma mark - Network Request Delegate

- (void)requestCompleteFilter
{
    [super requestCompleteFilter];
    [self saveJsonResponseToCacheFile:[super responseJSONObject]];
}


- (void)saveJsonResponseToCacheFile:(id)jsonResponse
{
    if ([self cacheTimeInSeconds] > 0 && ![self isDataFromCache])
    {
        NSDictionary *json = jsonResponse;
        if (json != nil)
        {
            [NSKeyedArchiver archiveRootObject:json toFile:[self cacheFilePath]];
            [NSKeyedArchiver archiveRootObject:@([self cacheVersion]) toFile:[self cacheVersionFilePath]];
        }
    }
}

@end
