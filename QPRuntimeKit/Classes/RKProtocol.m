 //
//  RKProtocol.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/8.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKProtocol.h"
#import "RKProperty.h"
#import "RKMethodDescription.h"

@implementation RKProtocol

#pragma mark - Initializers

+ (instancetype)protocolWithName:(NSString *)name
{
    __unsafe_unretained Protocol *protocol = objc_getProtocol(name.UTF8String);
    return [[self alloc] initWithPrototype:protocol];
}

+ (instancetype)protocolWithPrototype:(__unsafe_unretained Protocol *)prototype
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

- (instancetype)initWithPrototype:(__unsafe_unretained Protocol *)prototype
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
    const char *name = protocol_getName(self.prototype);
    return name ? @(name) : nil;
}

- (NSArray<RKProtocol *> *)protocols
{
    unsigned int count = 0;
    Protocol * __unsafe_unretained *protocols;
    protocols = protocol_copyProtocolList(self.prototype, &count);
    if (!protocols) {
        return @[];
    }

    NSMutableArray<RKProtocol *> *mutableProtocols;
    mutableProtocols = [[NSMutableArray alloc] initWithCapacity:count];
    for (unsigned int index = 0; index < count; ++index) {
        __unsafe_unretained Protocol *item = protocols[index];
        RKProtocol *protocol = [RKProtocol protocolWithPrototype:item];
        [mutableProtocols addObject:protocol];
    }

    free(protocols);
    return [mutableProtocols copy];
}

#pragma mark - Properties(RKProperty)

- (NSArray<RKProperty *> *)propertiesWithRequried:(BOOL)isRequired
                                         instance:(BOOL)isInstance
{
    unsigned int count = 0;
    objc_property_t *properties = nil;

    // Sometimes protocol_copyPropertyList2 would be crashes.

#if 0
    properties = protocol_copyPropertyList2(self.prototype,
                                            &count,
                                            isRequired,
                                            isInstance);
#else
    if (isRequired && isInstance) {
        properties = protocol_copyPropertyList(self.prototype, &count);
    }
#endif

    if (!properties) {
        return @[];
    }

    NSMutableArray<RKProperty *> *mutableProperties;
    mutableProperties = [[NSMutableArray alloc] initWithCapacity:count];
    for (unsigned int index = 0; index < count; ++index) {
        objc_property_t item = properties[index];
        RKProperty *property = [RKProperty propertyWithPrototype:item];
        [mutableProperties addObject:property];
    }

    free(properties);
    return [mutableProperties copy];
}

- (NSArray<RKProperty *> *)optionalClassProperties
{
    return [self propertiesWithRequried:NO instance:NO];
}

- (NSArray<RKProperty *> *)optionalInstanceProperties
{
    return [self propertiesWithRequried:NO instance:YES];
}

- (NSArray<RKProperty *> *)requiredClassProperties
{
    return [self propertiesWithRequried:YES instance:NO];
}

- (NSArray<RKProperty *> *)requiredInstanceProperties
{
    return [self propertiesWithRequried:YES instance:YES];
}

#pragma mark - Properties(RKMethodDescription)

- (NSArray<RKMethodDescription *> *)methodDescriptionsWithRequried:(BOOL)isRequired
                                                          instance:(BOOL)isInstance
{
    unsigned int count = 0;
    struct objc_method_description *methodDescriptions;
    methodDescriptions = protocol_copyMethodDescriptionList(self.prototype,
                                                            isRequired,
                                                            isInstance,
                                                            &count);
    if (!methodDescriptions) {
        return @[];
    }

    NSMutableArray<RKMethodDescription *> *mutableMethodDescriptions;
    mutableMethodDescriptions = [[NSMutableArray alloc] initWithCapacity:count];
    for (unsigned int index = 0; index < count; ++index) {
        struct objc_method_description *item = methodDescriptions + index;
        RKMethodDescription *methodDescription;
        methodDescription = [RKMethodDescription methodDescriptionWithPrototype:item];
        [mutableMethodDescriptions addObject:methodDescription];
    }

    free(methodDescriptions);
    return [mutableMethodDescriptions copy];
}

- (NSArray<RKMethodDescription *> *)optionalClassMethodDescriptions
{
    return [self methodDescriptionsWithRequried:NO instance:NO];
}

- (NSArray<RKMethodDescription *> *)optionalInstanceMethodDescriptions
{
    return [self methodDescriptionsWithRequried:NO instance:YES];
}

- (NSArray<RKMethodDescription *> *)requiredClassMethodDescriptions
{
    return [self methodDescriptionsWithRequried:YES instance:NO];
}

- (NSArray<RKMethodDescription *> *)requiredInstanceMethodDescriptions
{
    return [self methodDescriptionsWithRequried:YES instance:YES];
}

#pragma mark - Query(RKProperty)

- (RKProperty *)propertyForName:(NSString *)name
                       required:(BOOL)isRequired
                       instance:(BOOL)isInstance
{
    objc_property_t property = NULL;

    // Sometimes protocol_getProperty would be crashes.

#if 0
    property = protocol_getProperty(self.prototype,
                                    name.UTF8String,
                                    isRequired,
                                    isInstance);
#else
    if (isRequired && isInstance) {
        property = protocol_getProperty(self.prototype,
                                        name.UTF8String,
                                        isRequired,
                                        isInstance);
    }
#endif

    return property ? [RKProperty propertyWithPrototype:property] : nil;
}

- (RKProperty *)classPropertyForName:(NSString *)name
{
    return ([self propertyForName:name required:NO instance:NO] ?:
            [self propertyForName:name required:YES instance:NO]);
}

- (RKProperty *)instancePropertyForName:(NSString *)name
{
    return ([self propertyForName:name required:NO instance:YES] ?:
            [self propertyForName:name required:YES instance:YES]);
}

#pragma mark - Query(RKMethodDescription)

- (RKMethodDescription *)methodDescriptionForName:(NSString *)name
                                         required:(BOOL)isRequired
                                         instance:(BOOL)isInstance
{
    SEL selector = NSSelectorFromString(name);
    if (!selector) {
        return nil;
    }
    struct objc_method_description methodDescription;
    methodDescription = protocol_getMethodDescription(self.prototype,
                                                      selector,
                                                      isRequired,
                                                      isInstance);
    if (!methodDescription.name) {
        return nil;
    }
    return [RKMethodDescription methodDescriptionWithPrototype:&methodDescription];
}

- (RKMethodDescription *)classMethodDescriptionForName:(NSString *)name
{
    return ([self methodDescriptionForName:name required:NO instance:NO] ?:
            [self methodDescriptionForName:name required:YES instance:NO]);
}

- (RKMethodDescription *)instanceMethodDescriptionForName:(NSString *)name
{
    return ([self methodDescriptionForName:name required:NO instance:YES] ?:
            [self methodDescriptionForName:name required:YES instance:YES]);
}

#pragma mark - Testing

- (BOOL)isEqualToProtocol:(RKProtocol *)other
{
    return protocol_isEqual(self.prototype, other.prototype);
}

- (BOOL)isConformsToProtocol:(RKProtocol *)protocol
{
    return protocol_conformsToProtocol(self.prototype, protocol.prototype);
}

#pragma mark - Description

- (NSString *)description
{
    NSMutableString *mutableDescription = [[NSMutableString alloc] init];
    [mutableDescription appendFormat:@"@protocol %@", self.name];

    // Append @required and @optional specifiers.

    const int RKRequiredSepcifierID = 1;
    const int RKOptionalSepcifierID = 2;

    __block int lastAppendSepcifierID = 0;
    __block NSUInteger indexOfRequiredSepcifier = NSNotFound;

    void (^appendRequiredSepcifier)(void) = ^{
        if (RKRequiredSepcifierID != lastAppendSepcifierID) {
            if (RKOptionalSepcifierID == lastAppendSepcifierID) {
                [mutableDescription appendString:@"@required\n"];
            }
            else {
                indexOfRequiredSepcifier = [mutableDescription length];
            }
            lastAppendSepcifierID = RKRequiredSepcifierID;
        }
    };

    void (^appendOptionalSepcifier)(void) = ^{
        if (RKOptionalSepcifierID != lastAppendSepcifierID) {
            if (NSNotFound != indexOfRequiredSepcifier) {
                [mutableDescription insertString:@"@required\n"
                                         atIndex:indexOfRequiredSepcifier];
                indexOfRequiredSepcifier = NSNotFound;
            }
            [mutableDescription appendString:@"@optional\n"];
            lastAppendSepcifierID = RKOptionalSepcifierID;
        }
    };

    // Conforms to protocols description.

    NSArray<RKProtocol *> *protocols = self.protocols;
    if (protocols.count > 0) {
        NSString *key = NSStringFromSelector(@selector(name));
        NSArray<NSString *> *names = [protocols valueForKey:key];
        NSString *joinedNames = [names componentsJoinedByString:@", "];
        [mutableDescription appendFormat:@" <%@>", joinedNames];
    }
    [mutableDescription appendString:@"\n"];

    // Required class properties description.

    NSArray<RKProperty *> *requiredClassProperties;
    requiredClassProperties = self.requiredClassProperties;
    if (requiredClassProperties.count > 0) {
        appendRequiredSepcifier();
        for (RKProperty *item in requiredClassProperties) {
            [mutableDescription appendFormat:@"+ %@;\n", item];
        }
    }

    // Required class method-descriptions description.

    NSArray<RKMethodDescription *> *requiredClassMethodDescriptions;
    requiredClassMethodDescriptions = self.requiredClassMethodDescriptions;
    if (requiredClassMethodDescriptions.count > 0) {
        appendRequiredSepcifier();
        for (RKMethodDescription *item in requiredClassMethodDescriptions) {
            [mutableDescription appendFormat:@"+ %@;\n", item];
        }
    }

    // Required instance properties description.

    NSArray<RKProperty *> *requiredInstanceProperties;
    requiredInstanceProperties = self.requiredInstanceProperties;
    if (requiredInstanceProperties.count > 0) {
        appendRequiredSepcifier();
        for (RKProperty *item in requiredInstanceProperties) {
            [mutableDescription appendFormat:@"- %@;\n", item];
        }
    }

    // Required instance method-descriptions description.

    NSArray<RKMethodDescription *> *requiredInstanceMethodDescriptions;
    requiredInstanceMethodDescriptions = self.requiredInstanceMethodDescriptions;
    if (requiredInstanceMethodDescriptions.count > 0) {
        appendRequiredSepcifier();
        for (RKMethodDescription *item in requiredInstanceMethodDescriptions) {
            [mutableDescription appendFormat:@"- %@;\n", item];
        }
    }

    // Optional class properties description.

    NSArray<RKProperty *> *optionalClassProperties;
    optionalClassProperties = self.optionalClassProperties;
    if (optionalClassProperties.count > 0) {
        appendOptionalSepcifier();
        for (RKProperty *item in optionalClassProperties) {
            [mutableDescription appendFormat:@"+ %@;\n", item];
        }
    }

    // Optional class method-descriptions description.

    NSArray<RKMethodDescription *> *optionalClassMethodDescriptions;
    optionalClassMethodDescriptions = self.optionalClassMethodDescriptions;
    if (optionalClassMethodDescriptions.count > 0) {
        appendOptionalSepcifier();
        for (RKMethodDescription *item in optionalClassMethodDescriptions) {
            [mutableDescription appendFormat:@"+ %@;\n", item];
        }
    }

    // Optional instance properties description.

    NSArray<RKProperty *> *optionalInstanceProperties;
    optionalInstanceProperties = self.optionalInstanceProperties;
    if (optionalInstanceProperties.count > 0) {
        appendOptionalSepcifier();
        for (RKProperty *item in optionalInstanceProperties) {
            [mutableDescription appendFormat:@"- %@;\n", item];
        }
    }

    // Optional instance method-descriptions description.

    NSArray<RKMethodDescription *> *optionalInstanceMethodDescriptions;
    optionalInstanceMethodDescriptions = self.optionalInstanceMethodDescriptions;
    if (optionalInstanceMethodDescriptions.count > 0) {
        appendOptionalSepcifier();
        for (RKMethodDescription *item in optionalInstanceMethodDescriptions) {
            [mutableDescription appendFormat:@"- %@;\n", item];
        }
    }

    [mutableDescription appendString:@"@end"];
    return [mutableDescription copy];
}

@end
