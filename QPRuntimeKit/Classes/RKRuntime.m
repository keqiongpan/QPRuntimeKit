//
//  RKRuntime.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2017/11/7.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKRuntime.h"
#import "RKImage.h"
#import "RKClass.h"
#import "RKProtocol.h"

@implementation RKRuntime

#pragma mark - Initializers

+ (instancetype)sharedInstance
{
    static RKRuntime *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Properties

- (NSArray<RKImage *> *)allImages
{
    unsigned int count = 0;
    const char * _Nonnull *imageNames;
    imageNames = objc_copyImageNames(&count);
    if (!imageNames) {
        return @[];
    }

    NSMutableArray<RKImage *> *allImages;
    allImages = [[NSMutableArray alloc] initWithCapacity:count];
    for (unsigned int index = 0; index < count; ++index) {
        const char *name = imageNames[index];
        RKImage *currentImage = [RKImage imageWithName:@(name)];
        if (currentImage) {
            [allImages addObject:currentImage];
        }
    }

    free(imageNames);
    return [allImages copy];
}

- (NSArray<RKClass *> *)allClasses
{
    unsigned int count = 0;
    Class *classes = objc_copyClassList(&count);
    if (!classes) {
        return @[];
    }

    NSMutableArray<RKClass *> *allClasses;
    allClasses = [[NSMutableArray alloc] initWithCapacity:count];
    for (unsigned int index = 0; index < count; ++index) {
        [allClasses addObject:[RKClass classWithPrototype:classes[index]]];
    }

    free(classes);
    return [allClasses copy];
}

- (NSArray<RKProtocol *> *)allProtocols
{
    unsigned int count = 0;
    Protocol * __unsafe_unretained *protocols;
    protocols = objc_copyProtocolList(&count);
    if (!protocols) {
        return @[];
    }

    NSMutableArray<RKProtocol *> *allProtocols;
    allProtocols = [[NSMutableArray alloc] initWithCapacity:count];
    for (unsigned int index = 0; index < count; ++index) {
        [allProtocols addObject:[RKProtocol protocolWithPrototype:protocols[index]]];
    }

    free(protocols);
    return [allProtocols copy];
}

@end
