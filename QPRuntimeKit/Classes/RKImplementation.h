//
//  RKImplementation.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RKImage;

@interface RKImplementation : NSObject

+ (instancetype)implementationWithPrototype:(IMP)prototype;
- (instancetype)initWithPrototype:(IMP)prototype NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) IMP prototype;

@property (readonly, nullable) NSString *name;
@property (readonly, nullable) id block;
@property (readonly) const void *address;

@property (readonly, nullable) RKImage *fromImage;

- (BOOL)removeBlock;

@end

NS_ASSUME_NONNULL_END
