//
//  RKMethod.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKMethod.h"
#import "RKSelector.h"
#import "RKTypeEncoding.h"
#import "RKMethodTypeEncoding.h"
#import "RKMethodDescription.h"
#import "RKImplementation.h"

@implementation RKMethod

#pragma mark - Initializers

+ (instancetype)methodWithPrototype:(Method)prototype
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

- (instancetype)initWithPrototype:(Method)prototype
{
    self = prototype ? [super init] : nil;
    if (self) {
        _prototype = prototype;
    }
    return self;
}

#pragma mark - Properties

- (RKMethodDescription *)methodDescription
{
    struct objc_method_description *methodDescription;
    methodDescription = method_getDescription(self.prototype);
    return [RKMethodDescription methodDescriptionWithPrototype:methodDescription];
}

- (RKImplementation *)implementation
{
    IMP implementation = method_getImplementation(self.prototype);
    return [RKImplementation implementationWithPrototype:implementation];
}

#pragma mark - Properties(RKMethodDescription)

- (RKSelector *)selector
{
    SEL selector = method_getName(self.prototype);
    return [RKSelector selectorWithPrototype:selector];
}

- (RKMethodTypeEncoding *)methodTypeEncoding
{
    const char *typeEncoding = method_getTypeEncoding(self.prototype);
    return [RKMethodTypeEncoding typeEncodingWithPrototype:typeEncoding];
}

#pragma mark - Properties(RKMethodTypeEncoding)

- (RKTypeEncoding *)methodReturnType
{
    char *encode = method_copyReturnType(self.prototype);
    RKTypeEncoding *methodReturnType;
    methodReturnType = [RKTypeEncoding typeEncodingWithPrototype:encode];
    free(encode);
    return methodReturnType;
}

- (NSArray<RKTypeEncoding *> *)argumentTypes
{
    Method prototype = self.prototype;
    unsigned int count = method_getNumberOfArguments(prototype);
    NSMutableArray<RKTypeEncoding *> *mutableArgumentTypes;
    mutableArgumentTypes = [[NSMutableArray alloc] initWithCapacity:count];

    for (unsigned int index = 0; index < count; ++index) {
        char *encode = method_copyArgumentType(prototype, index);
        RKTypeEncoding *argumentType;
        argumentType = [RKTypeEncoding typeEncodingWithPrototype:encode];
        free(encode);
        [mutableArgumentTypes addObject:argumentType];
    }

    return [mutableArgumentTypes copy];
}

- (BOOL)isOneway
{
    return self.methodTypeEncoding.isOneway;
}

- (NSUInteger)numberOfArguments
{
    return (NSUInteger)method_getNumberOfArguments(self.prototype);
}

- (NSUInteger)methodReturnLength
{
    return self.methodTypeEncoding.methodReturnLength;
}

- (NSUInteger)frameLength
{
    return self.methodTypeEncoding.frameLength;
}

#pragma mark - Query

- (RKTypeEncoding *)argumentTypeAtIndex:(NSUInteger)index
{
    char *encode = method_copyArgumentType(self.prototype, (unsigned int)index);
    if (!encode) {
        return nil;
    }
    RKTypeEncoding *argumentType;
    argumentType = [RKTypeEncoding typeEncodingWithPrototype:encode];
    free(encode);
    return argumentType;
}

#pragma mark - Modify

- (RKImplementation *)replaceImplementation:(RKImplementation *)implementation
{
    if (implementation.prototype) {
        IMP oldImplementation = method_setImplementation(self.prototype,
                                                         implementation.prototype);
        return [RKImplementation implementationWithPrototype:oldImplementation];
    }
    return nil;
}

- (void)exchangeImplementationsWithMethod:(RKMethod *)otherMethod
{
    if (otherMethod.prototype) {
        method_exchangeImplementations(self.prototype, otherMethod.prototype);
    }
}

#pragma mark - Description

- (NSString *)description
{
    return self.methodDescription.description;
}

@end
