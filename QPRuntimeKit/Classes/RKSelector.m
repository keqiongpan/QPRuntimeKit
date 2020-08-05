//
//  RKSelector.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKSelector.h"

@implementation RKSelector

#pragma mark - Initializers

+ (instancetype)selectorWithName:(NSString *)name
{
    SEL selector = sel_getUid(name.UTF8String);
    return [[self alloc] initWithPrototype:selector];
}

+ (instancetype)selectorWithPrototype:(SEL)prototype
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

- (instancetype)initWithPrototype:(SEL)prototype
{
    self = prototype ? [super init] : nil;
    if (self) {
        _prototype = prototype;
    }
    return self;
}

#pragma mark - Properties

- (NSString *)name
{
    const char *name = sel_getName(self.prototype);
    return name ? @(name) : nil;
}

- (BOOL)isMapped
{
    return sel_isMapped(self.prototype);
}

#pragma mark - Description

- (NSString *)description
{
    return self.name;
}

@end
