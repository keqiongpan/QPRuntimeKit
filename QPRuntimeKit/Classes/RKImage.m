//
//  RKImage.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2019/3/13.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKImage.h"
#import "RKClass.h"

@interface RKImage()

@property (nonatomic, copy) NSString *name;

@end

@implementation RKImage

#pragma mark - Initializers

+ (instancetype)mainImage
{
    NSString *name = [[NSBundle mainBundle] executablePath];
    return [[self alloc] initWithName:name];
}

+ (instancetype)imageWithName:(NSString *)name
{
    return [[self alloc] initWithName:name];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (nullable instancetype)init
{
    return nil; // Always return nil.
}
#pragma clang diagnostic pop

- (instancetype)initWithName:(NSString *)name
{
    self = (name.length > 0) ? [super init] : nil;
    if (self) {
        self.name = name;
    }
    return self;
}

#pragma mark - Properties

- (NSArray<RKClass *> *)classes
{
    unsigned int count = 0;
    const char * _Nonnull *classNames;
    classNames = objc_copyClassNamesForImage(self.name.UTF8String, &count);
    if (!classNames) {
        return @[];
    }

    NSMutableArray<RKClass *> *allClasses;
    allClasses = [[NSMutableArray alloc] initWithCapacity:count];
    for (unsigned int index = 0; index < count; ++index) {
        const char *name = classNames[index];
        RKClass *currentClass = [RKClass classWithName:@(name)];
        if (currentClass) {
            [allClasses addObject:currentClass];
        }
    }

    free(classNames);
    return [allClasses copy];
}

#pragma mark - Description

- (NSString *)description
{
    NSString *key = NSStringFromSelector(@selector(name));
    NSArray<NSString *> *names = [self.classes valueForKey:key];
    return [NSString stringWithFormat:@"<%@> %@", self.name, names];
}

@end
