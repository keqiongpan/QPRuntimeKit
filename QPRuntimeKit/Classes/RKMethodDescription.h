//
//  RKMethodDescription.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RKSelector;
@class RKMethodTypeEncoding;

@interface RKMethodDescription : NSObject

+ (instancetype)methodDescriptionWithPrototype:(const struct objc_method_description *)prototype;
- (instancetype)initWithPrototype:(const struct objc_method_description *)prototype NS_DESIGNATED_INITIALIZER;

@property (readonly) const struct objc_method_description *prototype NS_RETURNS_INNER_POINTER;

@property (readonly) RKSelector *selector;
@property (readonly) RKMethodTypeEncoding *methodTypeEncoding;

@end

NS_ASSUME_NONNULL_END
