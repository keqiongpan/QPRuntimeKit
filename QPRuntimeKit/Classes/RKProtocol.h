//
//  RKProtocol.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/8.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RKProperty;
@class RKMethodDescription;

@interface RKProtocol : NSObject

+ (nullable instancetype)protocolWithName:(NSString *)name;
+ (instancetype)protocolWithPrototype:(__unsafe_unretained Protocol *)prototype;
- (instancetype)initWithPrototype:(__unsafe_unretained Protocol *)prototype NS_DESIGNATED_INITIALIZER;

@property (nonatomic, unsafe_unretained, readonly) Protocol *prototype;

@property (readonly) NSString *name;
@property (readonly) NSArray<RKProtocol *> *protocols;

@property (readonly) NSArray<RKProperty *> *optionalClassProperties;
@property (readonly) NSArray<RKProperty *> *optionalInstanceProperties;
@property (readonly) NSArray<RKProperty *> *requiredClassProperties;
@property (readonly) NSArray<RKProperty *> *requiredInstanceProperties;

@property (readonly) NSArray<RKMethodDescription *> *optionalClassMethodDescriptions;
@property (readonly) NSArray<RKMethodDescription *> *optionalInstanceMethodDescriptions;
@property (readonly) NSArray<RKMethodDescription *> *requiredClassMethodDescriptions;
@property (readonly) NSArray<RKMethodDescription *> *requiredInstanceMethodDescriptions;

- (nullable RKProperty *)classPropertyForName:(NSString *)name;
- (nullable RKProperty *)instancePropertyForName:(NSString *)name;

- (nullable RKMethodDescription *)classMethodDescriptionForName:(NSString *)name;
- (nullable RKMethodDescription *)instanceMethodDescriptionForName:(NSString *)name;

- (BOOL)isEqualToProtocol:(RKProtocol *)other;
- (BOOL)isConformsToProtocol:(RKProtocol *)protocol;

@end

NS_ASSUME_NONNULL_END
