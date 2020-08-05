//
//  RKTypeEncoding.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKTypeEncoding.h"

@interface RKTypeEncoding ()

@property (nonatomic, copy) NSString *encode;

@end

@implementation RKTypeEncoding

#pragma mark - Initializers

+ (instancetype)typeEncodingWithPrototype:(const char *)prototype
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

- (instancetype)initWithPrototype:(const char *)prototype
{
    self = prototype ? [super init] : nil;
    if (self) {
        _encode = @(prototype);
    }
    return self;
}

#pragma mark - Prototype

- (const char *)prototype
{
    return self.encode.UTF8String;
}

#pragma mark - Properties

- (NSUInteger)lengthOfBytes
{
    NSMethodSignature *signature = [NSMethodSignature
                                    signatureWithObjCTypes:self.prototype];
    return signature.frameLength + signature.methodReturnLength;
}

#pragma mark - Description

- (NSString *)description
{
    return self.encode;
}

@end
