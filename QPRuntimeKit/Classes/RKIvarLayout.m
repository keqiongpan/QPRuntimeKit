//
//  RKIvarLayout.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/9.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKIvarLayout.h"

@implementation RKIvarLayout

#pragma mark - Initializers

+ (instancetype)ivarLayoutWithPrototype:(const uint8_t *)prototype
{
    return [[self alloc] initWithPrototype:prototype];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (nullable instancetype)init
{
    return nil; // Always return nil.
}
#pragma clang diagnostic pop

- (instancetype)initWithPrototype:(const uint8_t *)prototype
{
    self = prototype ? [super init] : nil;
    if (self) {
        _prototype = prototype;
    }
    return self;
}

@end
