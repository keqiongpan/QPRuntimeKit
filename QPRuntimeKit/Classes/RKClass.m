//
//  RKClass.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKClass.h"
#import "RKImage.h"
#import "RKProtocol.h"
#import "RKIvar.h"
#import "RKIvarLayout.h"
#import "RKProperty.h"
#import "RKMethod.h"
#import "RKImplementation.h"
#import "RKSelector.h"

@implementation RKClass

#pragma mark - Initializers

+ (instancetype)classWithName:(NSString *)name
{
    __unsafe_unretained Class aClass = objc_lookUpClass(name.UTF8String);
    return [[self alloc] initWithPrototype:aClass];
}

+ (instancetype)classWithPrototype:(__unsafe_unretained Class)aClass
{
    return [[self alloc] initWithPrototype:aClass];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (nullable instancetype)init
{
    return nil; // Always return nil.
}
#pragma clang diagnostic pop

- (instancetype)initWithPrototype:(__unsafe_unretained Class)aClass
{
    self = aClass ? [super init] : nil;
    if (self) {
        _prototype = aClass;
    }
    return self;
}

#pragma mark - Properties(Basic)

- (NSString *)name
{
    const char *name = class_getName(self.prototype);
    return name ? @(name) : nil;
}

- (BOOL)isMetaClass
{
    return class_isMetaClass(self.prototype);
}

- (NSUInteger)instanceSize
{
    return (NSUInteger)class_getInstanceSize(self.prototype);
}

- (NSInteger)version
{
    return (NSInteger)class_getVersion(self.prototype);
}

#pragma mark - Properties(Relations)

- (RKImage *)fromImage
{
    const char *name = class_getImageName(self.prototype);
    return name ? [RKImage imageWithName:@(name)] : nil;
}

- (RKClass *)metaClass
{
    if (!self.isMetaClass) {
        const char *name = class_getName(self.prototype);
        __unsafe_unretained Class metaClass = objc_getMetaClass(name);
        return [RKClass classWithPrototype:metaClass];
    }
    return nil;
}

- (RKClass *)concreteClass
{
    if (self.isMetaClass) {
        const char *name = class_getName(self.prototype);
        __unsafe_unretained Class concreteClass = objc_lookUpClass(name);
        return [RKClass classWithPrototype:concreteClass];
    }
    return nil;
}

- (RKClass *)superClass
{
    __unsafe_unretained Class superClass = class_getSuperclass(self.prototype);
    return [RKClass classWithPrototype:superClass];
}

#pragma mark - Properties(Members)

- (NSArray<RKProtocol *> *)protocols
{
    unsigned int count = 0;
    Protocol * __unsafe_unretained *protocols;
    protocols = class_copyProtocolList(self.prototype, &count);
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

- (NSArray<RKIvar *> *)ivars
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self.prototype, &count);
    if (!ivars) {
        return @[];
    }

    NSMutableArray<RKIvar *> *mutableIvars;
    mutableIvars = [[NSMutableArray alloc] initWithCapacity:count];
    for (unsigned int index = 0; index < count; ++index) {
        Ivar item = ivars[index];
        RKIvar *ivar = [RKIvar ivarWithPrototype:item];
        [mutableIvars addObject:ivar];
    }

    free(ivars);
    return [mutableIvars copy];
}

- (NSArray<RKProperty *> *)properties
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(self.prototype, &count);
    if (!properties) {
        return @[];
    }

    NSMutableArray<RKProperty *> *mutableProperties;
    mutableProperties = [[NSMutableArray alloc] init];
    for (unsigned int index = 0; index < count; ++index) {
        objc_property_t item = properties[index];
        RKProperty *property = [RKProperty propertyWithPrototype:item];
        [mutableProperties addObject:property];
    }

    free(properties);
    return [mutableProperties copy];
}

- (NSArray<RKMethod *> *)methods
{
    unsigned int count = 0;
    Method *methods = class_copyMethodList(self.prototype, &count);
    if (!methods) {
        return @[];
    }

    NSMutableArray<RKMethod *> *mutableMethods;
    mutableMethods = [[NSMutableArray alloc] initWithCapacity:count];
    for (unsigned int index = 0; index < count; ++index) {
        Method item = methods[index];
        RKMethod *method = [RKMethod methodWithPrototype:item];
        [mutableMethods addObject:method];
    }

    free(methods);
    return [mutableMethods copy];
}

#pragma mark - Properties(Attributes)

- (RKIvarLayout *)strongIvarLayout
{
    const uint8_t *ivarLayout = class_getIvarLayout(self.prototype);
    return [RKIvarLayout ivarLayoutWithPrototype:ivarLayout];
}

- (RKIvarLayout *)weakIvarLayout
{
    const uint8_t *ivarLayout = class_getWeakIvarLayout(self.prototype);
    return [RKIvarLayout ivarLayoutWithPrototype:ivarLayout];
}

#pragma mark - Query

- (RKIvar *)ivarForName:(NSString *)name
{
    Ivar ivar = class_getInstanceVariable(self.prototype, name.UTF8String);
    return [RKIvar ivarWithPrototype:ivar];
}

- (RKProperty *)propertyForName:(NSString *)name
{
    objc_property_t property = class_getProperty(self.prototype, name.UTF8String);
    return [RKProperty propertyWithPrototype:property];
}

- (RKMethod *)methodForName:(NSString *)name
{
    SEL selector = sel_getUid(name.UTF8String);
    Method method = class_getInstanceMethod(self.prototype, selector);
    return [RKMethod methodWithPrototype:method];
}

- (RKImplementation *)implementationForMethodName:(NSString *)methodName
{
    SEL selector = sel_getUid(methodName.UTF8String);
    IMP implementation = class_getMethodImplementation(self.prototype, selector);
    return [RKImplementation implementationWithPrototype:implementation];
}

- (RKImplementation *)implementationReturnsStructureForMethodName:(NSString *)methodName
{
    SEL selector = sel_getUid(methodName.UTF8String);
#if defined(__arm64__)
    IMP implementation = class_getMethodImplementation(self.prototype, selector);
#else
    IMP implementation = class_getMethodImplementation_stret(self.prototype, selector);
#endif
    return [RKImplementation implementationWithPrototype:implementation];
}

#pragma mark - Testing

- (BOOL)canRespondToSelector:(RKSelector *)selector
{
    return class_respondsToSelector(self.prototype, selector.prototype);
}

- (BOOL)isConformsToProtocol:(RKProtocol *)protocol
{
    return class_conformsToProtocol(self.prototype, protocol.prototype);
}

#pragma mark - Description

- (NSString *)description
{
    NSMutableString *mutableDescription = [[NSMutableString alloc] init];
    [mutableDescription appendString:@"//\n"];
    [mutableDescription appendFormat:@"// %@ ", self.name];

    // All sort descrptors.

    NSString *offsetKey = NSStringFromSelector(@selector(offset));
    NSSortDescriptor *offsetSortDescriptor = [NSSortDescriptor
                                              sortDescriptorWithKey:offsetKey
                                              ascending:YES];

    NSString *implementationKey = NSStringFromSelector(@selector(implementation));
    NSComparator comparator = ^NSComparisonResult(RKImplementation * _Nonnull obj1,
                                                  RKImplementation * _Nonnull obj2) {
        return [@((uint64_t)obj1.address) compare:@((uint64_t)obj2.address)];
    };
    NSSortDescriptor *addressSortDescriptor = [NSSortDescriptor
                                               sortDescriptorWithKey:implementationKey
                                               ascending:YES
                                               comparator:comparator];

    // Class categories description.

    NSMutableDictionary<NSString *, NSMutableString *> *categories;
    categories = [[NSMutableDictionary alloc] init];

    NSMutableDictionary<NSString *, NSMutableArray<RKProtocol *> *> *categoriesProtocols;
    categoriesProtocols = [[NSMutableDictionary alloc] init];

    NSArray<RKProtocol *> *protocols = self.protocols;
    NSString *prefix = [NSString stringWithFormat:@"[%@(", self.name];
    NSString *suffix = @")";

    NSMutableString *(^mutableDescriptionWithMember)(id member, BOOL isInstance);
    mutableDescriptionWithMember = ^NSMutableString *(id member, BOOL isInstance) {
        RKMethod *method = nil;

        if ([member isKindOfClass:[RKMethod class]]) {
            method = member;
        }
        else if ([member isKindOfClass:[RKProperty class]]) {
            RKProperty *property = member;
            method = [self methodForName:property.getterName];
        }
        else {
            return mutableDescription;
        }

        NSString *categoryName = nil;
        RKImplementation *implementation = method.implementation;
        NSString *implementationName = implementation.name;
        NSArray<NSString *> *components = [implementationName componentsSeparatedByString:prefix];
        if (2 == components.count) {
            components = [components.lastObject componentsSeparatedByString:suffix];
            categoryName = components.firstObject;
            NSString *imageName = implementation.fromImage.name ?: @"";
            categoryName = [imageName stringByAppendingPathComponent:categoryName];
        }

        if (categoryName.length > 0) {
            RKProtocol *conformedProtocol = nil;

            if ([member isKindOfClass:[RKMethod class]]) {
                NSString *name = method.selector.name;
                for (RKProtocol *protocol in protocols) {
                    if (isInstance ? [protocol instanceMethodDescriptionForName:name] : [protocol classMethodDescriptionForName:name]) {
                        conformedProtocol = protocol;
                        break;
                    }
                }
            }
            else if ([member isKindOfClass:[RKProperty class]]) {
                NSString *name = ((RKProperty *)member).name;
                for (RKProtocol *protocol in protocols) {
                    if (isInstance ? [protocol instancePropertyForName:name] : [protocol classPropertyForName:name]) {
                        conformedProtocol = protocol;
                        break;
                    }
                }
            }

            if (conformedProtocol) {
                NSMutableArray<RKProtocol *> *categoryProtocols;
                categoryProtocols = [categoriesProtocols objectForKey:categoryName];
                if (!categoryProtocols) {
                    categoryProtocols = [[NSMutableArray alloc] init];
                    [categoriesProtocols setValue:categoryProtocols forKey:categoryName];
                }
                if (![categoryProtocols containsObject:conformedProtocol]) {
                    [categoryProtocols addObject:conformedProtocol];
                }
            }

            NSMutableString *categoryDescription = [categories objectForKey:categoryName];
            if (!categoryDescription) {
                categoryDescription = [[NSMutableString alloc] init];
                [categories setObject:categoryDescription forKey:categoryName];
            }
            return categoryDescription;
        }

        return mutableDescription;
    };

    void (^appendCategoriesDescription)(void) = ^{
        NSArray<NSString *> *categoryNames = [categories allKeys];
        if (categoryNames.count <= 0) {
            return;
        }

        SEL selector = @selector(caseInsensitiveCompare:);
        categoryNames = [categoryNames sortedArrayUsingSelector:selector];
        for (NSString *categoryName in categoryNames) {
            NSString *categoryDescription = [categories objectForKey:categoryName];
            NSArray<RKProtocol *> *categoryProtocols = [categoriesProtocols objectForKey:categoryName];

            [mutableDescription appendString:@"\n\n"];
            [mutableDescription appendFormat:@"// %@\n", categoryName.stringByDeletingLastPathComponent];
            [mutableDescription appendFormat:@"@interface %@", self.name];
            [mutableDescription appendFormat:@" (%@)", categoryName.lastPathComponent];
            if (categoryProtocols.count > 0) {
                NSString *key = NSStringFromSelector(@selector(name));
                NSArray<NSString *> *names = [categoryProtocols valueForKey:key];
                NSString *joninedNames = [names componentsJoinedByString:@", "];
                [mutableDescription appendFormat:@" <%@>", joninedNames];
            }
            [mutableDescription appendString:@"\n"];
            [mutableDescription appendString:categoryDescription];
            [mutableDescription appendString:@"@end"];
        }
    };

    // Class attributes description.

    NSMutableArray<NSString *> *attributes = [[NSMutableArray alloc] init];
    if (self.isMetaClass) {
        [attributes addObject:@"Meta"];
    }
    [attributes addObject:[NSString stringWithFormat:@"Version %d", (int)self.version]];
    [attributes addObject:[NSString stringWithFormat:@"%u Bytes", (unsigned int)self.instanceSize]];
    [mutableDescription appendFormat:@"(%@)\n", [attributes componentsJoinedByString:@", "]];

    // Class comments description.

    NSString *imageName = self.fromImage.name;
    [mutableDescription appendString:@"//\n"];
    [mutableDescription appendFormat:@"// The class `%@' was exported from %@, that the image path is:\n", self.name, imageName.lastPathComponent];
    [mutableDescription appendFormat:@"// %@\n", imageName];
    [mutableDescription appendFormat:@"//\n"];

    // Class of class and instance members.

    RKClass *classOfClassMembers = self.metaClass;
    RKClass *classOfInstanceMembers = self;
    if (self.isMetaClass) {
        classOfClassMembers = self;
        classOfInstanceMembers = nil;
    }
    [mutableDescription appendFormat:@"@interface %@", self.name];

    // Super class description.

    RKClass *superClass = self.superClass;
    if (superClass) {
        [mutableDescription appendFormat:@" : %@", superClass.name];
    }

    // Conforms to protocols description.

    if (protocols.count > 0) {
        NSString *key = NSStringFromSelector(@selector(name));
        NSArray<NSString *> *names = [protocols valueForKey:key];
        NSString *joinedNames = [names componentsJoinedByString:@", "];
        [mutableDescription appendFormat:@" <%@>", joinedNames];
    }
    [mutableDescription appendString:@"\n"];

    // Class ivars description.

    NSArray<RKIvar *> *classIvars = classOfClassMembers.ivars;
    classIvars = [classIvars sortedArrayUsingDescriptors:@[offsetSortDescriptor]];
    if (classIvars.count > 0) {
        for (RKIvar *ivar in classIvars) {
            [mutableDescriptionWithMember(ivar, NO) appendFormat:@"+ %@\n", ivar];
        }
    }

    // Class properties description.

    NSArray<RKProperty *> *classProperties = classOfClassMembers.properties;
    if (classProperties.count > 0) {
        for (RKProperty *property in classProperties) {
            [mutableDescriptionWithMember(property, NO) appendFormat:@"+ %@\n", property];
        }
    }

    // Class methods description.

    NSArray<RKMethod *> *classMethods = classOfClassMembers.methods;
    classMethods = [classMethods sortedArrayUsingDescriptors:@[addressSortDescriptor]];
    if (classMethods.count > 0) {
        for (RKMethod *method in classMethods) {
            [mutableDescriptionWithMember(method, NO) appendFormat:@"+ %@\n", method];
        }
    }

    // Instance ivars description.

    NSArray<RKIvar *> *instanceIvars = classOfInstanceMembers.ivars;
    instanceIvars = [instanceIvars sortedArrayUsingDescriptors:@[offsetSortDescriptor]];
    if (instanceIvars.count > 0) {
        for (RKIvar *ivar in instanceIvars) {
            [mutableDescriptionWithMember(ivar, YES) appendFormat:@"- %@\n", ivar];
        }
    }

    // Instance properties description.

    NSArray<RKProperty *> *instanceProperties = classOfInstanceMembers.properties;
    if (instanceProperties.count > 0) {
        for (RKProperty *property in instanceProperties) {
            [mutableDescriptionWithMember(property, YES) appendFormat:@"- %@\n", property];
        }
    }

    // Instance methods description.

    NSArray<RKMethod *> *instanceMethods = classOfInstanceMembers.methods;
    instanceMethods = [instanceMethods sortedArrayUsingDescriptors:@[addressSortDescriptor]];
    if (instanceMethods.count > 0) {
        for (RKMethod *method in instanceMethods) {
            [mutableDescriptionWithMember(method, YES) appendFormat:@"- %@\n", method];
        }
    }

    [mutableDescription appendString:@"@end"];
    appendCategoriesDescription();
    return [mutableDescription copy];
}

@end
