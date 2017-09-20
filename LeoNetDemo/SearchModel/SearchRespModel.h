//
//  SearchRespModel.h
//  LeoNetDemo
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "RespModel.h"

@interface SearchRespBookModel : Model

@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *isbn10;
@property (nonatomic, strong)NSString *isbn13;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSString *image;
//太多了 不写了
@end

@interface SearchRespModel : RespModel

@property (nonatomic, strong)NSNumber *start;
@property (nonatomic, strong)NSNumber *count;
@property (nonatomic, strong)NSNumber *total;
@property (nonatomic, strong)NSArray <SearchRespBookModel *>*books;

@end
