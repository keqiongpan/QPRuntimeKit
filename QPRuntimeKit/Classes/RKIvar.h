//
//  RKIvar.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/9.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RKTypeEncoding;

@interface RKIvar : NSObject

+ (instancetype)ivarWithPrototype:(Ivar)prototype;
- (instancetype)initWithPrototype:(Ivar)prototype NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) Ivar prototype;

@property (readonly) NSString *name;
@property (readonly) NSUInteger offset;
@property (readonly) RKTypeEncoding *typeEncoding;

@end

NS_ASSUME_NONNULL_END
