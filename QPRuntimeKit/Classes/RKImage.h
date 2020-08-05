//
//  RKImage.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2019/3/13.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RKClass;

@interface RKImage : NSObject

+ (instancetype)mainImage;
+ (instancetype)imageWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;

@property (readonly) NSString *name;
@property (readonly) NSArray<RKClass *> *classes;

@end

NS_ASSUME_NONNULL_END
