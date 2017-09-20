//
//  RespModel.h
//  LeoNetDemo
//
//  Created by MAC on 2017/9/19.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Model : MTLModel <MTLJSONSerializing>

@end

@interface RespModel : Model

@property (nonatomic, strong)NSNumber *code;
@property (nonatomic, strong)NSString *msg;
//request

@end
