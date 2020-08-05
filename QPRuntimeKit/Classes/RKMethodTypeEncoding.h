//
//  RKMethodTypeEncoding.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/9.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKTypeEncoding.h"

NS_ASSUME_NONNULL_BEGIN

@interface RKMethodTypeEncoding : RKTypeEncoding

@property (readonly) RKTypeEncoding *methodReturnType;
@property (readonly) NSArray<RKTypeEncoding *> *argumentTypes;
@property (readonly) BOOL isOneway;

@property (readonly) NSUInteger numberOfArguments;
@property (readonly) NSUInteger methodReturnLength;
@property (readonly) NSUInteger frameLength;

- (nullable RKTypeEncoding *)argumentTypeAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
