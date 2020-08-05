//
//  RKClass.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RKImage;
@class RKProtocol;
@class RKIvar;
@class RKIvarLayout;
@class RKProperty;
@class RKMethod;
@class RKImplementation;
@class RKSelector;

@interface RKClass : NSObject

+ (nullable instancetype)classWithName:(NSString *)name;
+ (instancetype)classWithPrototype:(__unsafe_unretained Class)aClass;
- (instancetype)initWithPrototype:(__unsafe_unretained Class)aClass NS_DESIGNATED_INITIALIZER;

@property (nonatomic, unsafe_unretained, readonly) Class prototype;

@property (readonly) NSString *name;
@property (readonly) BOOL isMetaClass;
@property (readonly) NSUInteger instanceSize;
@property (readonly) NSInteger version;

@property (readonly, nullable) RKImage *fromImage;
@property (readonly, nullable) RKClass *metaClass;
@property (readonly, nullable) RKClass *concreteClass;
@property (readonly, nullable) RKClass *superClass;

@property (readonly) NSArray<RKProtocol *> *protocols;
@property (readonly) NSArray<RKIvar *> *ivars;
@property (readonly) NSArray<RKProperty *> *properties;
@property (readonly) NSArray<RKMethod *> *methods;

@property (readonly) RKIvarLayout *strongIvarLayout;
@property (readonly) RKIvarLayout *weakIvarLayout;

- (nullable RKIvar *)ivarForName:(NSString *)name;
- (nullable RKProperty *)propertyForName:(NSString *)name;
- (nullable RKMethod *)methodForName:(NSString *)name;

- (nullable RKImplementation *)implementationForMethodName:(NSString *)methodName;
- (nullable RKImplementation *)implementationReturnsStructureForMethodName:(NSString *)methodName;

- (BOOL)canRespondToSelector:(RKSelector *)selector;
- (BOOL)isConformsToProtocol:(RKProtocol *)protocol;

@end

NS_ASSUME_NONNULL_END
