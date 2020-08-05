//
//  RKIvarLayout.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/9.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RKIvarLayout : NSObject

+ (instancetype)ivarLayoutWithPrototype:(const uint8_t *)prototype;
- (instancetype)initWithPrototype:(const uint8_t *)prototype NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) const uint8_t *prototype;

@end

NS_ASSUME_NONNULL_END
