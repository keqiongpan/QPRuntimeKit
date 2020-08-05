//
//  RKIvar.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/9.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKIvar.h"
#import "RKTypeEncoding.h"

@implementation RKIvar

#pragma mark - Initializers

+ (instancetype)ivarWithPrototype:(Ivar)prototype
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

- (instancetype)initWithPrototype:(Ivar)prototype
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
    const char *name = ivar_getName(self.prototype);
    return name ? @(name) : nil;
}

- (NSUInteger)offset
{
    return (NSUInteger)ivar_getOffset(self.prototype);
}

- (RKTypeEncoding *)typeEncoding
{
    const char *encode = ivar_getTypeEncoding(self.prototype);
    return [RKTypeEncoding typeEncodingWithPrototype:encode];
}

#pragma mark - Description

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"[Ivar] <%p> %@:%@",
            (const void *)self.offset,
            self.name,
            self.typeEncoding];
}

@end
