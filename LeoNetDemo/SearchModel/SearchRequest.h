//
//  SearchRequest.h
//  LeoNetDemo
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "Request.h"
#import "SearchRequestModel.h"
#import "SearchRespModel.h"

@interface SearchRequest : Request

@property (nonatomic, strong)SearchRequestModel *requestModel;
@property (nonatomic, strong)SearchRespModel *respModel;

- (instancetype)initWithRequestModel:(SearchRequestModel *)model;

@end
