# GreedJSON [![Build Status](https://travis-ci.org/greedlab/GreedJSON.svg?branch=master)](https://travis-ci.org/greedlab/GreedJSON)

利用`NSJSONSerialization `和`run time `实现JSON转模型、模型转JSON

[English](README.md)

## 安装

pod 'GreedJSON'

## 使用

```objc
#import "GreedJSON.h"
```

### [NSArray+GreedJSON](https://github.com/greedlab/GreedJSON/blob/master/GreedJSON/NSArray%2BGreedJSON.h)

```objc
// NSArray 转 NSString
- (NSString*)gr_JSONString;
// NSArray 转 NSData
- (NSData*)gr_JSONData;
```

### [NSData+GreedJSON](https://github.com/greedlab/GreedJSON/blob/master/GreedJSON/NSData%2BGreedJSON.h)

```objc
// NSData 转 NSDictionary 或 NSArray
- (__kindof NSObject*)gr_object
```

### [NSDictionary+GreedJSON](https://github.com/greedlab/GreedJSON/blob/master/GreedJSON/NSDictionary%2BGreedJSON.h)

```objc
// NSDictionary 转 NSString
- (NSString*)gr_JSONString;
// NSDictionary 转 NSData
- (NSData*)gr_JSONData;
```

### [NSString+GreedJSON](https://github.com/greedlab/GreedJSON/blob/master/GreedJSON/NSString%2BGreedJSON.h)

```objc
// NSString 转 NSDictionary 或 NSArray
- (__kindof NSObject*)gr_object
```

### [NSObject+GreedJSON](https://github.com/greedlab/GreedJSON/blob/master/GreedJSON/NSObject%2BGreedJSON.h)

```objc
// model 转 NSDictionary
- (__kindof NSObject *)gr_dictionary;
// NSDictionary 转 model
+ (id)gr_objectFromDictionary:(NSDictionary*)dictionary
```

## LICENSE

[MIT](LICENSE)
