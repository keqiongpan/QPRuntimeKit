//
//  RKMethodTypeEncoding.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/9.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKMethodTypeEncoding.h"

@interface RKMethodTypeEncoding ()

@property (nonatomic, strong) NSMethodSignature *signature;

@end

@implementation RKMethodTypeEncoding

#pragma mark - Initializers

- (instancetype)initWithPrototype:(const char *)prototype
{
    NSMethodSignature *signature = prototype ? [NSMethodSignature signatureWithObjCTypes:prototype] : nil;
    self = signature ? [super initWithPrototype:prototype] : nil;
    if (self) {
        _signature = signature;
    }
    return self;
}

#pragma mark - Properties

- (RKTypeEncoding *)methodReturnType
{
    const char *methodReturnType = self.signature.methodReturnType;
    return [RKTypeEncoding typeEncodingWithPrototype:methodReturnType];
}

- (NSArray<RKTypeEncoding *> *)argumentTypes
{
    NSMethodSignature *signature = self.signature;
    NSUInteger count = signature.numberOfArguments;
    NSMutableArray<RKTypeEncoding *> *mutableArgumentTypes;
    mutableArgumentTypes = [[NSMutableArray alloc] initWithCapacity:count];

    for (NSUInteger index = 0; index < count; ++index) {
        const char *encode = [signature getArgumentTypeAtIndex:index];
        RKTypeEncoding *argumentType;
        argumentType = [RKTypeEncoding typeEncodingWithPrototype:encode];
        [mutableArgumentTypes addObject:argumentType];
    }

    return [mutableArgumentTypes copy];
}

- (BOOL)isOneway
{
    return self.signature.isOneway;
}

- (NSUInteger)numberOfArguments
{
    return self.signature.numberOfArguments;
}

- (NSUInteger)methodReturnLength
{
    return self.signature.methodReturnLength;
}

- (NSUInteger)frameLength
{
    return self.signature.frameLength;
}

#pragma mark - Query

- (RKTypeEncoding *)argumentTypeAtIndex:(NSUInteger)index
{
    NSMethodSignature *signature = self.signature;
    if (index < signature.numberOfArguments) {
        const char *argumentType = [signature getArgumentTypeAtIndex:index];
        return [RKTypeEncoding typeEncodingWithPrototype:argumentType];
    }
    return nil;
}

#pragma mark - Description

- (NSString *)description
{
    RKTypeEncoding *methodReturnType = self.methodReturnType;
    NSArray<RKTypeEncoding *> *argumentTypes = self.argumentTypes;
    BOOL isOneway = self.isOneway;

    NSString *key = NSStringFromSelector(@selector(description));
    NSArray<NSString *> *descriptions = [argumentTypes valueForKey:key];
    NSString *argumentTypesDescription = [descriptions componentsJoinedByString:@", "];

    NSMutableString *mutableDescription = [[NSMutableString alloc] init];
    [mutableDescription appendFormat:@"(%@) -> %@", argumentTypesDescription, methodReturnType];
    if (isOneway) {
        [mutableDescription appendString:@" [Oneway]"];
    }

    return [mutableDescription copy];
}

@end
