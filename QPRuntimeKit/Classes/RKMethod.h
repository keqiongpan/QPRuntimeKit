//
//  RKMethod.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RKSelector;
@class RKTypeEncoding;
@class RKMethodTypeEncoding;
@class RKMethodDescription;
@class RKImplementation;

@interface RKMethod : NSObject

+ (instancetype)methodWithPrototype:(Method)prototype;
- (instancetype)initWithPrototype:(Method)prototype NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) Method prototype;

@property (readonly) RKMethodDescription *methodDescription;
@property (readonly) RKImplementation *implementation;

@property (readonly) RKSelector *selector;
@property (readonly) RKMethodTypeEncoding *methodTypeEncoding;

@property (readonly) RKTypeEncoding *methodReturnType;
@property (readonly) NSArray<RKTypeEncoding *> *argumentTypes;
@property (readonly) BOOL isOneway;

@property (readonly) NSUInteger numberOfArguments;
@property (readonly) NSUInteger methodReturnLength;
@property (readonly) NSUInteger frameLength;

- (nullable RKTypeEncoding *)argumentTypeAtIndex:(NSUInteger)index;

- (nullable RKImplementation *)replaceImplementation:(RKImplementation *)implementation;
- (void)exchangeImplementationsWithMethod:(RKMethod *)otherMethod;

@end

NS_ASSUME_NONNULL_END
