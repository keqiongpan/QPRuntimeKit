//
//  RKPropertyAttribute.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/8.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKPropertyAttribute.h"

RKPropertyAttributeName const RKPropertyAttributeReadOnlyName = @"R";
RKPropertyAttributeName const RKPropertyAttributeBycopyName = @"C";
RKPropertyAttributeName const RKPropertyAttributeByrefName = @"&";
RKPropertyAttributeName const RKPropertyAttributeDynamicName = @"D";
RKPropertyAttributeName const RKPropertyAttributeGetterName = @"G";
RKPropertyAttributeName const RKPropertyAttributeSetterName = @"S";
RKPropertyAttributeName const RKPropertyAttributeIvarName = @"V";
RKPropertyAttributeName const RKPropertyAttributeTypeName = @"T";
RKPropertyAttributeName const RKPropertyAttributeWeakName = @"W";
RKPropertyAttributeName const RKPropertyAttributeStrongName = @"P";
RKPropertyAttributeName const RKPropertyAttributeNonAtomicName = @"N";

@interface RKPropertyAttribute () {
    objc_property_attribute_t _attribute;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;

@end

@implementation RKPropertyAttribute

#pragma mark - Initializers

+ (instancetype)propertyAttributeWithPrototype:(const objc_property_attribute_t *)prototype
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

- (instancetype)initWithPrototype:(const objc_property_attribute_t *)prototype
{
    self = prototype ? [super init] : nil;
    if (self) {
        _name = prototype->name ? @(prototype->name) : nil;
        _value = prototype->value ? @(prototype->value) : nil;
        _attribute.name = (const char * _Nonnull)_name.UTF8String;
        _attribute.value = (const char * _Nonnull)_value.UTF8String;
    }
    return self;
}

#pragma mark - Prototype

- (const objc_property_attribute_t *)prototype
{
    return &_attribute;
}

#pragma mark - Description

- (NSString *)description
{
    NSDictionary *allKnownAttributes = @{
        RKPropertyAttributeReadOnlyName:@"ReadOnly",
        RKPropertyAttributeBycopyName:@"Bycopy",
        RKPropertyAttributeByrefName:@"Byref",
        RKPropertyAttributeDynamicName:@"Dynamic",
        RKPropertyAttributeGetterName:@"Getter",
        RKPropertyAttributeSetterName:@"Setter",
        RKPropertyAttributeIvarName:@"Ivar",
        RKPropertyAttributeTypeName:@"Type",
        RKPropertyAttributeWeakName:@"Weak",
        RKPropertyAttributeStrongName:@"Strong",
        RKPropertyAttributeNonAtomicName:@"NonAtomic"
    };

    NSString *name = self.name;
    NSString *value = self.value;

    name = [allKnownAttributes objectForKey:name] ?: name;
    value = value.length > 0 ? [@"=" stringByAppendingString:value] : @"";

    return [NSString stringWithFormat:@"%@%@", name, value];
}

@end
