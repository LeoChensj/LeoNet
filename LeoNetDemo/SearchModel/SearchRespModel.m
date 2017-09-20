//
//  SearchRespModel.m
//  LeoNetDemo
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "SearchRespModel.h"

@implementation SearchRespBookModel

@end

@implementation SearchRespModel

+ (NSValueTransformer *)booksJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:SearchRespBookModel.class];
}

@end
