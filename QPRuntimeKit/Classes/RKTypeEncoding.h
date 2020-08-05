//
//  RKTypeEncoding.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RKTypeEncoding : NSObject

+ (instancetype)typeEncodingWithPrototype:(const char *)prototype;
- (instancetype)initWithPrototype:(const char *)prototype NS_DESIGNATED_INITIALIZER;

@property (readonly) const char *prototype NS_RETURNS_INNER_POINTER;

@property (readonly) NSString *encode;
@property (readonly) NSUInteger lengthOfBytes;

@end

NS_ASSUME_NONNULL_END
