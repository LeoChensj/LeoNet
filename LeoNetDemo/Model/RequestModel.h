//
//  RequestModel.h
//  LeoNetDemo
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface RequestModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong)NSMutableDictionary *headerDict;
@property (nonatomic, strong)NSDictionary *requestDict;

- (id)requestParam;
- (id)headerParam;

@end
