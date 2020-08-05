//
//  RKType.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2018/1/18.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKEncode.h"


NS_ASSUME_NONNULL_BEGIN


#pragma mark - Base

@interface RKType : NSObject<NSCopying>

+ (instancetype)type;
+ (nullable instancetype)typeWithEncode:(const char *)encode;

@property (readonly) NSString *name;            // ex. `CharactersPointer'.
@property (readonly) RKSignature signature;     // ex. RKSignatureCharactersPointer.
@property (readonly) NSString *literal;         // ex. `const char *'.
@property (readonly) NSString *encode;          // ex. `r*'.

@property (nonatomic) RKQualifierFlag flags;    // ex. RKQualifierConstFlag.
@property (readwrite) BOOL isConst;             // ex. YES.

@property (readonly) NSUInteger size;           // ex. sizeof(char *).
@property (readonly) NSUInteger alignment;      // ex. __alignof(char *).
@property (readonly) NSUInteger alignedSize;    // Size aligned by __alignof(char *).
@property (readonly) NSUInteger promotedSize;   // Size aligned by sizeof(void *).

- (NSString *)shortLiteral;
- (NSString *)castingLiteralSpecifiers;
- (NSString *)pointerLiteralSpecifiers;
- (NSString *)declareStatementWithVariableName:(NSString *)variableName;

@end


#pragma mark - Scalars

#ifndef RK_SCALAR_CLASSES
#define RK_SCALAR_CLASSES
NS_ASSUME_NONNULL_END

#define RK_SCALAR_SIGNATURE(name, code, type) \
/**/    @interface RK##name##Type : RKType \
/**/    @end
#include "RKEncode.def"

NS_ASSUME_NONNULL_BEGIN
#endif


#pragma mark - void/bool/char */bit-field

@interface RKVoidType : RKType

@end

@interface RKBoolType : RKType

@end

@interface RKCharactersPointerType : RKType

@end

@interface RKBitFieldType : RKType

@property (nonatomic) NSUInteger bits;
@property (readonly) RKType *valueType;

@end


#pragma mark - Pointer/Function

@interface RKPointerType : RKType

@property (nonatomic, strong) RKType *pointeeType;
@property (readonly) RKType *valueType;

@end

@interface RKFunctionType : RKType

@end


#pragma mark - Array/Struct/Union

@interface RKArrayType : RKType

@property (nonatomic, strong) RKType *elementType;
@property (nonatomic, assign) NSUInteger elementCount;

@end

@interface RKStructMember : NSObject<NSCopying>

@property (nonatomic, nullable, copy) NSString *memberName;
@property (nonatomic, strong) RKType *memberType;

@end

@interface RKStructType : RKType

@property (nonatomic, nullable, copy) NSString *structName;
@property (nonatomic, nullable, copy) NSArray<RKStructMember *> *members;

- (NSUInteger)indexOfMemberForName:(NSString *)name;
- (NSUInteger)offsetOfMemberAtIndex:(NSUInteger)index;

@end

@interface RKUnionMember : NSObject<NSCopying>

@property (nonatomic, nullable, copy) NSString *memberName;
@property (nonatomic, strong) RKType *memberType;

@end

@interface RKUnionType : RKType

@property (nonatomic, nullable, copy) NSString *unionName;
@property (nonatomic, nullable, copy) NSArray<RKUnionMember *> *members;

- (NSUInteger)indexOfMemberForName:(NSString *)name;
- (NSUInteger)offsetOfMemberAtIndex:(NSUInteger)index;

@end


#pragma mark - Objective-C Types

@interface RKClassType : RKType

@end

@interface RKSelectorType : RKType

@end

@interface RKObjectType : RKType

@property (nonatomic, copy) NSString *objectClassName;
@property (nonatomic, copy) NSArray<NSString *> *objectProtocolNames;

@end

@interface RKBlockType : RKType

@end


#pragma mark - Others

@interface RKAtomicType : RKType

@property (nonatomic, strong) RKType *valueType;

@end

@interface RKComplexType : RKType

@property (nonatomic, strong) RKType *valueType;

@end

@interface RKAtomType : RKType

@end

@interface RKVectorType : RKType

@property (nonatomic, strong) RKType *valueType;

@end


#pragma mark - Method Types

@interface RKMethodArgument : NSObject<NSCopying>

@property (nonatomic, nullable, copy) NSString *argumentName;
@property (nonatomic, strong) RKType *argumentType;

@property (readwrite) BOOL isBycopy;
@property (readwrite) BOOL isByref;

@property (readwrite) BOOL isIn;
@property (readwrite) BOOL isInout;
@property (readwrite) BOOL isOut;

@end

@interface RKMethodType : RKType

@property (nonatomic, strong) RKType *methodReturnType;
@property (nonatomic, copy) NSArray<RKMethodArgument *> *arguments;

@property (readwrite) BOOL isOneway;

- (NSUInteger)offsetOfMethodReturnType;
- (NSUInteger)offsetOfArgumentTypeAtIndex:(NSUInteger)index;

@end


NS_ASSUME_NONNULL_END
