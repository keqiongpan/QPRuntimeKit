//
//  RKProperty.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/8.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RKPropertyAttribute;
@class RKTypeEncoding;

@interface RKProperty : NSObject

+ (instancetype)propertyWithPrototype:(objc_property_t)prototype;
- (instancetype)initWithPrototype:(objc_property_t)prototype NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) objc_property_t prototype;

@property (readonly) NSString *name;
@property (readonly) NSArray<RKPropertyAttribute *> *attributes;

- (nullable RKPropertyAttribute *)attributeWithName:(NSString *)name;

@end

@interface RKProperty (Attributes)

@property (readonly) NSString *defaultGetterName;
@property (readonly) NSString *defaultSetterName;
@property (readonly) NSString *defaultIvarName;

@property (readonly) NSString *getterName;
@property (readonly) NSString *setterName;
@property (readonly) NSString *ivarName;

@property (readonly) RKTypeEncoding *typeEncoding;

@property (readonly) BOOL isReadOnly;
@property (readonly) BOOL isDynamic;
@property (readonly) BOOL isNonAtomic;

@property (readonly) BOOL isBycopy;
@property (readonly) BOOL isByref;
@property (readonly) BOOL isWeak;
@property (readonly) BOOL isStrong;

@end

NS_ASSUME_NONNULL_END
