//
//  SearchRequestModel.h
//  LeoNetDemo
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 MAC. All rights reserved.
//  搜索接口 https://developers.douban.com/wiki/?title=book_v2#get_book_search

#import "RequestModel.h"

@interface SearchRequestModel : RequestModel

@property (nonatomic, strong)NSString *q;
@property (nonatomic, strong)NSString *tag;
@property (nonatomic, strong)NSNumber *start;
@property (nonatomic, strong)NSNumber *count;

@end
