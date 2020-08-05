//
//  RKImplementation.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <dlfcn.h>
#import "RKImplementation.h"
#import "RKImage.h"

@implementation RKImplementation

#pragma mark - Initializers

+ (instancetype)implementationWithPrototype:(IMP)prototype
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

- (instancetype)initWithPrototype:(IMP)prototype
{
    self = prototype ? [super init] : nil;
    if (self) {
        _prototype = prototype;
    }
    return self;
}

#pragma mark - Properties(Basic)

- (NSString *)name
{
    Dl_info info = {0};
    if (dladdr(self.address, &info) && info.dli_sname) {
        return @(info.dli_sname);
    }
    return nil;
}

- (id)block
{
    return imp_getBlock(self.prototype);
}

- (const void *)address
{
    __unsafe_unretained id block = self.block;
    const void *address = (__bridge const void *)block;
    address = address ?: (const void *)self.prototype;
    return address;
}

#pragma mark - Properties(Relations)

- (RKImage *)fromImage
{
    Dl_info info = {0};
    if (dladdr(self.address, &info) && info.dli_fname) {
        return [RKImage imageWithName:@(info.dli_fname)];
    }
    return nil;
}

#pragma mark - Modify

- (BOOL)removeBlock
{
    return imp_removeBlock(self.prototype);
}

#pragma mark - Description

- (NSString *)description
{
    NSMutableString *mutableDescription = [[NSMutableString alloc] init];
    [mutableDescription appendFormat:@"[IMP] %p", self.prototype];

    Dl_info info = {0};
    if (dladdr(self.address, &info)) {
        if (info.dli_saddr == (const void *)self.prototype) {
            [mutableDescription appendFormat:@" %s", info.dli_sname];
        }
        else {
            [mutableDescription appendFormat:@" <%p %s>", info.dli_saddr, info.dli_sname];
        }
        [mutableDescription appendFormat:@" <%p %s>", info.dli_fbase, info.dli_fname];
    }

    return [mutableDescription copy];
}

@end
