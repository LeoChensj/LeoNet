//
//  RequestModel.m
//  LeoNetDemo
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "RequestModel.h"
#import "NSString+MD5.h"
#import "GreedJSON.h"

@implementation RequestModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}




//请求参数
- (id)requestParam
{
    if(_requestDict==nil)
    {
        NSDictionary *requestDict = [MTLJSONAdapter JSONDictionaryFromModel:self error:nil];
        requestDict = [self removeNullFromDictionary:requestDict];
        [self handleDictionnary:requestDict];
        
        //NSString *jsonStr = [requestDict gr_JSONString];
        
        //这里可以加入加密代码
        //_requestStr = jsonStr;
        
        _requestDict = requestDict;
    }
    
    NSLog(@"request=%@", _requestDict);
    
    return _requestDict;
}

//header
- (id)headerParam
{
    _headerDict = [[NSMutableDictionary alloc] init];
    
    //这里按照项目需求自行配置
    [_headerDict setObject:@"token123456" forKey:@"token"];
    
    return _headerDict;
}








#pragma mark - Helper
- (void)handleDictionnary:(NSDictionary *)dict
{
    NSMutableDictionary *mDict = (NSMutableDictionary *)dict;
    
    for (NSString *key in mDict.allKeys)
    {
        id value = [mDict objectForKey:key];
        
        if([value isEqual:[NSNull null]])
        {
            [mDict removeObjectForKey:key];
        }
    }
}
- (NSMutableDictionary *)removeNullFromDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (NSString *strKey in dic.allKeys)
    {
        NSValue *value = dic[strKey];
        // 删除NSDictionary中的NSNull，再保存进字典
        if ([value isKindOfClass:NSDictionary.class])
        {
            mdic[strKey] = [self removeNullFromDictionary:(NSDictionary *)value];
        }
        // 删除NSArray中的NSNull，再保存进字典
        else if ([value isKindOfClass:NSArray.class])
        {
            mdic[strKey] = [self removeNullFromArray:(NSArray *)value];
        }
        // 剩余的非NSNull类型的数据保存进字典
        else if (![value isKindOfClass:NSNull.class])
        {
            mdic[strKey] = dic[strKey];
        }
    }
    return mdic;
}
- (NSMutableArray *)removeNullFromArray:(NSArray *)arr
{
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++)
    {
        NSValue *value = arr[i];
        // 删除NSDictionary中的NSNull，再添加进数组
        if ([value isKindOfClass:NSDictionary.class])
        {
            [marr addObject:[self removeNullFromDictionary:(NSDictionary *)value]];
        }
        // 删除NSArray中的NSNull，再添加进数组
        else if ([value isKindOfClass:NSArray.class])
        {
            [marr addObject:[self removeNullFromArray:(NSArray *)value]];
        }
        // 剩余的非NSNull类型的数据添加进数组
        else if (![value isKindOfClass:NSNull.class])
        {
            [marr addObject:value];
        }
    }
    return marr;
}
- (NSObject *)removeNullFrom:(NSObject *)object
{
    NSObject *objResult = nil;
    NSMutableArray *marrSearch = nil;
    if ([object isKindOfClass:NSNull.class]) {
        return nil;
    }
    else if ([object isKindOfClass:NSArray.class]) {
        objResult = [NSMutableArray arrayWithArray:(NSArray *)object];
        marrSearch = [NSMutableArray arrayWithObject:objResult];
    }
    else if ([object isKindOfClass:NSDictionary.class]) {
        objResult = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)object];
        marrSearch = [NSMutableArray arrayWithObject:objResult];
    }
    else {
        return object;
    }
    while (marrSearch.count > 0) {
        NSObject *header = marrSearch[0];
        if ([header isKindOfClass:NSMutableDictionary.class]) {
            // 遍历这个字典
            NSMutableDictionary *mdicTemp = (NSMutableDictionary *)header;
            for (NSString *strKey in mdicTemp.allKeys) {
                NSObject *objTemp = mdicTemp[strKey];
                // 将NSDictionary替换为NSMutableDictionary
                if ([objTemp isKindOfClass:NSDictionary.class]) {
                    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)objTemp];
                    mdicTemp[strKey] = mdic;
                    [marrSearch addObject:mdic];
                }
                // 将NSArray替换为NSMutableArray
                else if ([objTemp isKindOfClass:NSArray.class]) {
                    NSMutableArray *marr = [NSMutableArray arrayWithArray:(NSArray *)objTemp];
                    mdicTemp[strKey] = marr;
                    [marrSearch addObject:marr];
                }
                // 删除NSNull
                else if ([objTemp isKindOfClass:NSNull.class]) {
                    mdicTemp[strKey] = nil;
                }
            }
        }
        else if ([header isKindOfClass:NSMutableArray.class]) {
            // 遍历这个数组
            NSMutableArray *marrTemp = (NSMutableArray *)header;
            for (NSInteger i = marrTemp.count-1; i >= 0; i--) {
                NSObject *objTemp = marrTemp[i];
                // 将NSDictionary替换为NSMutableDictionary
                if ([objTemp isKindOfClass:NSDictionary.class]) {
                    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)objTemp];
                    [marrTemp replaceObjectAtIndex:i withObject:mdic];
                    [marrSearch addObject:mdic];
                }
                // 将NSArray替换为NSMutableArray
                else if ([objTemp isKindOfClass:NSArray.class]) {
                    NSMutableArray *marr = [NSMutableArray arrayWithArray:(NSArray *)objTemp];
                    [marrTemp replaceObjectAtIndex:i withObject:marr];
                    [marrSearch addObject:marr];
                }
                // 删除NSNull
                else if ([objTemp isKindOfClass:NSNull.class]) {
                    [marrTemp removeObjectAtIndex:i];
                }
            }
        }
        else {
            // 到这里就出错了
        }
        [marrSearch removeObjectAtIndex:0];
    }
    return objResult;
}

@end
