//
//  RKObject.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2018/1/2.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKObject.h"
#import "RKClass.h"
#import "RKIvar.h"

@implementation RKObject

#pragma mark - Initializers

+ (instancetype)objectWithPrototype:(id)anObject
{
    return [[self alloc] initWithPrototype:anObject];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (nullable instancetype)init
{
    return nil; // Always return nil.
}
#pragma clang diagnostic pop

- (instancetype)initWithPrototype:(id)anObject
{
    self = anObject ? [super init] : nil;
    if (self) {
        _prototype = anObject;
    }
    return self;
}

#pragma mark - Properties

- (RKClass *)prototypeClass
{
    __unsafe_unretained Class prototypeClass = object_getClass(self.prototype);
    return [RKClass classWithPrototype:prototypeClass];
}

- (void *)extraBytes
{
#if __has_feature(objc_arc)
    return NULL;
#else
    return object_getIndexedIvars(self.prototype);
#endif
}

#pragma mark - IvarValue

- (id)ivarValueForName:(NSString *)name
{
    Ivar ivar = [[self.prototypeClass ivarForName:name] prototype];
    if (!ivar) {
        return nil;
    }
    return object_getIvar(self.prototype, ivar);
}

- (void)setIvarValue:(id)value forName:(NSString *)name
{
    Ivar ivar = [[self.prototypeClass ivarForName:name] prototype];
    if (ivar) {
        object_setIvar(self.prototype, ivar, value);
    }
}

#pragma mark - AssociatedObject

- (id)associatedObjectForKey:(const void *)key
{
    return objc_getAssociatedObject(self.prototype, key);
}

- (void)setAssociatedObject:(id)anObject
                     forKey:(const void *)key
                 withPolicy:(objc_AssociationPolicy)policy
{
    objc_setAssociatedObject(self.prototype, key, anObject, policy);
}

- (void)removeAssociatedObjects:(id)anObject
{
    objc_removeAssociatedObjects(anObject);
}

@end
