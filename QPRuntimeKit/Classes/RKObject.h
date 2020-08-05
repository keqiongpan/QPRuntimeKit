//
//  RKObject.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2018/1/2.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RKClass;

@interface RKObject : NSObject

+ (instancetype)objectWithPrototype:(id)anObject;
- (instancetype)initWithPrototype:(id)anObject NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) id prototype;

@property (readonly) RKClass *prototypeClass;
@property (readonly, nullable) void *extraBytes;

- (nullable id)ivarValueForName:(NSString *)name;
- (void)setIvarValue:(id _Nullable)value forName:(NSString *)name;

- (nullable id)associatedObjectForKey:(const void *)key;
- (void)setAssociatedObject:(id _Nullable)anObject
                     forKey:(const void *)key
                 withPolicy:(objc_AssociationPolicy)policy;
- (void)removeAssociatedObjects:(id)anObject;

@end

NS_ASSUME_NONNULL_END
