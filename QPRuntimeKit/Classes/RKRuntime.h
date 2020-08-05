//
//  RKRuntime.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RKImage;
@class RKClass;
@class RKProtocol;

@interface RKRuntime : NSObject

+ (instancetype)sharedInstance;

@property (readonly) NSArray<RKImage *> *allImages;
@property (readonly) NSArray<RKClass *> *allClasses;
@property (readonly) NSArray<RKProtocol *> *allProtocols;

@end

NS_ASSUME_NONNULL_END

