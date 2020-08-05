//
//  RKSelector.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RKSelector : NSObject

+ (nullable instancetype)selectorWithName:(NSString *)name;
+ (instancetype)selectorWithPrototype:(SEL)selector;
- (instancetype)initWithPrototype:(SEL)selector NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) SEL prototype;

@property (readonly) NSString *name;
@property (readonly, getter=isMapped) BOOL mapped;

@end

NS_ASSUME_NONNULL_END
