//
//  RKProperty.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/8.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKProperty.h"
#import "RKPropertyAttribute.h"
#import "RKTypeEncoding.h"

@implementation RKProperty

#pragma mark - Initializers

+ (instancetype)propertyWithPrototype:(objc_property_t)prototype
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

- (instancetype)initWithPrototype:(objc_property_t)prototype
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
    const char *name = property_getName(self.prototype);
    return name ? @(name) : nil;
}

- (NSArray<RKPropertyAttribute *> *)attributes
{
    unsigned int count = 0;
    objc_property_attribute_t *attributes;
    attributes = property_copyAttributeList(self.prototype, &count);
    if (!attributes) {
        return @[];
    }

    NSMutableArray<RKPropertyAttribute *> *mutableAttributes;
    mutableAttributes = [[NSMutableArray alloc] initWithCapacity:count];
    for (unsigned int index = 0; index < count; ++index) {
        objc_property_attribute_t *item = attributes + index;
        RKPropertyAttribute *attribute;
        attribute = [RKPropertyAttribute propertyAttributeWithPrototype:item];
        [mutableAttributes addObject:attribute];
    }

    free(attributes);
    return [mutableAttributes copy];
}

#pragma mark - Query

- (RKPropertyAttribute *)attributeWithName:(NSString *)name
{
    objc_property_attribute_t item;
    item.name = name.UTF8String;
    item.value = property_copyAttributeValue(self.prototype, item.name);
    if (!item.value) {
        return nil;
    }
    RKPropertyAttribute *attribute;
    attribute = [RKPropertyAttribute propertyAttributeWithPrototype:&item];
    free((void *)item.value);
    return attribute;
}

#pragma mark - Description

- (NSString *)description
{
    NSString *key = NSStringFromSelector(@selector(description));
    NSArray *descriptions = [self.attributes valueForKey:key];
    NSString *attributesDescription = [descriptions componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"[Property] %@<%@>", self.name, attributesDescription];
}

@end

#pragma mark - Attributes

@implementation RKProperty (Attributes)

- (NSString *)defaultGetterName
{
    return self.name;
}

- (NSString *)defaultSetterName
{
    NSString *name = self.name;
    if (name.length > 0) {
        return [NSString stringWithFormat:@"set%@%@:",
                [[name substringToIndex:1] uppercaseString],
                [name substringFromIndex:1]];
    }
    return @"set:";
}

- (NSString *)defaultIvarName
{
    return [NSString stringWithFormat:@"_%@", self.name];
}

- (NSString *)getterName
{
    NSString *attributeName = RKPropertyAttributeGetterName;
    RKPropertyAttribute *attribute = [self attributeWithName:attributeName];
    return attribute ? attribute.value : self.defaultGetterName;
}

- (NSString *)setterName
{
    NSString *attributeName = RKPropertyAttributeSetterName;
    RKPropertyAttribute *attribute = [self attributeWithName:attributeName];
    if (!attribute && !self.isReadOnly) {
        return self.defaultSetterName;
    }
    return attribute.value;
}

- (NSString *)ivarName
{
    NSString *attributeName = RKPropertyAttributeIvarName;
    RKPropertyAttribute *attribute = [self attributeWithName:attributeName];
    return attribute.value;
}

- (RKTypeEncoding *)typeEncoding
{
    NSString *attributeName = RKPropertyAttributeTypeName;
    RKPropertyAttribute *attribute = [self attributeWithName:attributeName];
    return [RKTypeEncoding typeEncodingWithPrototype:attribute.value.UTF8String];
}

- (BOOL)isReadOnly
{
    NSString *attributeName = RKPropertyAttributeReadOnlyName;
    RKPropertyAttribute *attribute = [self attributeWithName:attributeName];
    return !!attribute;
}

- (BOOL)isDynamic
{
    NSString *attributeName = RKPropertyAttributeDynamicName;
    RKPropertyAttribute *attribute = [self attributeWithName:attributeName];
    return !!attribute;
}

- (BOOL)isNonAtomic
{
    NSString *attributeName = RKPropertyAttributeNonAtomicName;
    RKPropertyAttribute *attribute = [self attributeWithName:attributeName];
    return !!attribute;
}

- (BOOL)isBycopy
{
    NSString *attributeName = RKPropertyAttributeBycopyName;
    RKPropertyAttribute *attribute = [self attributeWithName:attributeName];
    return !!attribute;
}

- (BOOL)isByref
{
    NSString *attributeName = RKPropertyAttributeByrefName;
    RKPropertyAttribute *attribute = [self attributeWithName:attributeName];
    return !!attribute;
}

- (BOOL)isWeak
{
    NSString *attributeName = RKPropertyAttributeWeakName;
    RKPropertyAttribute *attribute = [self attributeWithName:attributeName];
    return !!attribute;
}

- (BOOL)isStrong
{
    NSString *attributeName = RKPropertyAttributeStrongName;
    RKPropertyAttribute *attribute = [self attributeWithName:attributeName];
    return !!attribute;
}

@end
