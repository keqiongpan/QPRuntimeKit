//
//  RKMethodDescription.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKMethodDescription.h"
#import "RKSelector.h"
#import "RKMethodTypeEncoding.h"

@interface RKMethodDescription () {
    struct objc_method_description _methodDescription;
}

@property (nonatomic, copy) NSString *types;

@end

@implementation RKMethodDescription

#pragma mark - Initializers

+ (instancetype)methodDescriptionWithPrototype:(const struct objc_method_description *)prototype
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

- (instancetype)initWithPrototype:(const struct objc_method_description *)prototype
{
    self = prototype ? [super init] : nil;
    if (self) {
        _types = prototype->types ? @(prototype->types) : nil;
        _methodDescription.name = (SEL)prototype->name;
        _methodDescription.types = (char *)_types.UTF8String;
    }
    return self;
}

#pragma mark - Prototype

- (const struct objc_method_description *)prototype
{
    return &_methodDescription;
}

#pragma mark - Properties

- (RKSelector *)selector
{
    SEL selector = self.prototype->name;
    return [RKSelector selectorWithPrototype:selector];
}

- (RKMethodTypeEncoding *)methodTypeEncoding
{
    const char *methodTypeEncoding = self.prototype->types;
    return [RKMethodTypeEncoding typeEncodingWithPrototype:methodTypeEncoding];
}

#pragma mark - Description

- (NSString *)description
{
    RKSelector *selector = self.selector;
    RKMethodTypeEncoding *methodTypeEncoding = self.methodTypeEncoding;
    return [NSString stringWithFormat:@"[Method] %@%@", selector, methodTypeEncoding];
}

@end
