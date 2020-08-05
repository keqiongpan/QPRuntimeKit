//
//  RKPropertyAttribute.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/8.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *RKPropertyAttributeName;
extern RKPropertyAttributeName const RKPropertyAttributeReadOnlyName;
extern RKPropertyAttributeName const RKPropertyAttributeBycopyName;
extern RKPropertyAttributeName const RKPropertyAttributeByrefName;
extern RKPropertyAttributeName const RKPropertyAttributeDynamicName;
extern RKPropertyAttributeName const RKPropertyAttributeGetterName;
extern RKPropertyAttributeName const RKPropertyAttributeSetterName;
extern RKPropertyAttributeName const RKPropertyAttributeIvarName;
extern RKPropertyAttributeName const RKPropertyAttributeTypeName;
extern RKPropertyAttributeName const RKPropertyAttributeWeakName;
extern RKPropertyAttributeName const RKPropertyAttributeStrongName;
extern RKPropertyAttributeName const RKPropertyAttributeNonAtomicName;

@interface RKPropertyAttribute : NSObject

+ (instancetype)propertyAttributeWithPrototype:(const objc_property_attribute_t *)prototype;
- (instancetype)initWithPrototype:(const objc_property_attribute_t *)prototype NS_DESIGNATED_INITIALIZER;

@property (readonly) const objc_property_attribute_t *prototype NS_RETURNS_INNER_POINTER;

@property (readonly) NSString *name;
@property (readonly) NSString *value;

@end

NS_ASSUME_NONNULL_END
