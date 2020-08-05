//
//  RKType.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2018/1/18.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKType.h"


@implementation RKType

#pragma mark - Initializers

+ (instancetype)type
{
    return [[[self class] alloc] init];
}

+ (nullable instancetype)typeWithEncode:(const char *)encode
{
    #warning TODO: implementation typeWithEncode: 's method body.
    return nil;
}

#pragma mark - Identifiers

- (NSString *)name
{
    return self.literal;
}

- (RKSignature)signature
{
    return '?'; // Unspecified signature.
}

- (NSString *)literal
{
    NSString *literalQualifiers = self.literalQualifiers ?: @"";
    NSString *literalSpecifiers = self.literalSpecifiers ?: @"";
    return [literalQualifiers stringByAppendingString:literalSpecifiers];
}

- (NSString *)encode
{
    NSString *encodeQualifiers = self.encodeQualifiers ?: @"";
    NSString *encodeSpecifiers = self.encodeSpecifiers ?: @"";
    return [encodeQualifiers stringByAppendingString:encodeSpecifiers];
}

#pragma mark - Qualifiers

- (NSString *)literalQualifiers
{
    RKQualifierFlag originalFlags = self.flags;
    NSMutableString *mutableLiteralQualifiers = [[NSMutableString alloc] init];

    BOOL (^testFlagsAndAppendQualifier)(RKQualifierFlag flags, NSString *qualifier);
    testFlagsAndAppendQualifier = ^BOOL(RKQualifierFlag flags, NSString *qualifier) {
        if (RKTestFlags(originalFlags, flags)) {
            [mutableLiteralQualifiers appendString:qualifier];
            return YES;
        }
        return NO;
    };

    testFlagsAndAppendQualifier(RKQualifierOnewayFlag, @"oneway ");
    testFlagsAndAppendQualifier(RKQualifierInFlag, @"in ");
    testFlagsAndAppendQualifier(RKQualifierInoutFlag, @"inout ");
    testFlagsAndAppendQualifier(RKQualifierOutFlag, @"out ");
    testFlagsAndAppendQualifier(RKQualifierBycopyFlag, @"bycopy ");
    testFlagsAndAppendQualifier(RKQualifierByrefFlag, @"byref ");
    testFlagsAndAppendQualifier(RKQualifierConstFlag, @"const ");

    return [mutableLiteralQualifiers copy];
}

- (NSString *)encodeQualifiers
{
    RKQualifierFlag originalFlags = self.flags;
    NSMutableString *mutableEncodeQualifiers = [[NSMutableString alloc] init];

    BOOL (^testFlagsAndAppendQualifier)(RKQualifierFlag flags, RKQualifier qualifier);
    testFlagsAndAppendQualifier = ^BOOL(RKQualifierFlag flags, RKQualifier qualifier) {
        if (RKTestFlags(originalFlags, flags)) {
            [mutableEncodeQualifiers appendFormat:@"%c", qualifier];
            return YES;
        }
        return NO;
    };

    testFlagsAndAppendQualifier(RKQualifierOnewayFlag, RKQualifierOneway);
    testFlagsAndAppendQualifier(RKQualifierInFlag, RKQualifierIn);
    testFlagsAndAppendQualifier(RKQualifierInoutFlag, RKQualifierInout);
    testFlagsAndAppendQualifier(RKQualifierOutFlag, RKQualifierOut);
    testFlagsAndAppendQualifier(RKQualifierBycopyFlag, RKQualifierBycopy);
    testFlagsAndAppendQualifier(RKQualifierByrefFlag, RKQualifierByref);
    testFlagsAndAppendQualifier(RKQualifierConstFlag, RKQualifierConst);

    return [mutableEncodeQualifiers copy];
}

#pragma mark - Specifiers

- (NSString *)literalSpecifiers
{
    return @"<unspecified>"; // Unspecified specifiers.
}

- (NSString *)encodeSpecifiers
{
    return @((char[]){self.signature, 0});
}

#pragma mark - Flags

static inline BOOL RKTestFlags(RKQualifierFlag originalFlags,
                               RKQualifierFlag testingFlags)
{
    return (testingFlags && (testingFlags == (originalFlags & testingFlags)));
}

static inline RKQualifierFlag RKMixedFlags(RKQualifierFlag originalFlags,
                                           RKQualifierFlag mixingFlags,
                                           BOOL enabled)
{
    return (enabled ? (originalFlags | mixingFlags) : (originalFlags & ~mixingFlags));
}

- (BOOL)isConst
{
    return RKTestFlags(self.flags, RKQualifierConstFlag);
}

- (void)setIsConst:(BOOL)isConst
{
    self.flags = RKMixedFlags(self.flags, RKQualifierConstFlag, isConst);
}

#pragma mark - Dimensions

static inline NSUInteger RKRoundSize(NSUInteger size, NSUInteger alignment)
{
    if (size > 0 && alignment > 0) {
        size = ((size + alignment - 1) / alignment) * alignment;
    }
    return size;
}

- (NSUInteger)size
{
    return 0;
}

- (NSUInteger)alignment
{
    return 0;
}

- (NSUInteger)alignedSize
{
    return RKRoundSize(self.size, self.alignment);
}

- (NSUInteger)promotedSize
{
    return RKRoundSize(self.size, sizeof(void *));
}

#pragma mark - Scenes

#warning Refactor scenes statements.

- (NSString *)castingLiteralSpecifiers
{
    return self.literal;
}

- (NSString *)pointerLiteralSpecifiers
{
    return [self declareStatementWithVariableName:@"*"];
}

- (NSString *)declareStatementWithVariableName:(NSString *)variableName
{
    NSMutableString *mutableDeclareStatement = [[NSMutableString alloc] init];
    [mutableDeclareStatement appendString:self.literal];

    RKSignature signature = self.signature;
    if (RKSignatureCharactersPointer != signature &&
        RKSignaturePointer != signature) {
        [mutableDeclareStatement appendString:@" "];
    }

    [mutableDeclareStatement appendString:variableName];
    return [mutableDeclareStatement copy];
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    RKType *other = [[[self class] allocWithZone:zone] init];
    other.flags = self.flags;
    return other;
}

#pragma mark - Description

- (NSString *)description
{
    return self.literal;
}

@end


#pragma mark - Primitives

#define RK_PRIMITIVE_IMPLEMENTATION(_name, _type, _size, _alignment, ...) \
/**/    - (NSString *)name { return @#_name; } \
/**/    - (RKSignature)signature { return RKSignature##_name; } \
/**/    - (NSString *)literalSpecifiers { return (_type); } \
/**/    - (NSUInteger)size { return (_size); } \
/**/    - (NSUInteger)alignment { return (_alignment); }


#pragma mark - Scalars

#define RK_SCALAR_SIGNATURE(name, code, type) \
/**/    @implementation RK##name##Type \
/**/    RK_PRIMITIVE_IMPLEMENTATION(name, @#type, sizeof(type), __alignof(type)) \
/**/    @end
#include "RKEncode.def"


#pragma mark - void/bool/char */bit-field

@implementation RKVoidType
RK_PRIMITIVE_IMPLEMENTATION(Void, @"void", 0, __alignof(char))
@end


@implementation RKBoolType
RK_PRIMITIVE_IMPLEMENTATION(Bool, @"_Bool", sizeof(_Bool), __alignof(_Bool))
@end


@implementation RKCharactersPointerType
RK_PRIMITIVE_IMPLEMENTATION(CharactersPointer, @"char *", sizeof(char *), __alignof(char *))
@end


@implementation RKBitFieldType
@synthesize bits = _bits;

RK_PRIMITIVE_IMPLEMENTATION(BitField, ([NSString stringWithFormat:@"%@:%u", self.valueType.literalSpecifiers, (unsigned int)self.bits]), (self.bits + 7) / 8, __alignof(char))

#warning 处理结构体内多个连续bit-field成员的size、alignment及valueType。

- (NSUInteger)bits
{
    return ((_bits = MAX(MIN(_bits, sizeof(__int128_t) * 8), 1)));
}

- (void)setBits:(NSUInteger)bits
{
    _bits = MAX(MIN(bits, sizeof(__int128_t) * 8), 1);
}

- (RKType *)valueType
{
    NSUInteger bits = self.bits;
    if (bits <= sizeof(char) * 8) {
        return RKCharType.type;
    }
    else if (bits <= sizeof(short) * 8) {
        return RKShortType.type;
    }
    else if (bits <= sizeof(int) * 8) {
        return RKIntType.type;
    }
    else if (bits <= sizeof(long) * 8) {
        return RKLongType.type;
    }
    else if (bits <= sizeof(long long) * 8) {
        return RKLongLongType.type;
    }
    return RKInt128Type.type;
}

- (NSString *)encodeSpecifiers
{
    NSString *superEncodeSpecifiers = [super encodeSpecifiers];
    unsigned int bits = (unsigned int)self.bits;
    return [superEncodeSpecifiers stringByAppendingFormat:@"%u", bits];
}

- (NSString *)declareStatementWithVariableName:(NSString *)variableName
{
    return [NSString stringWithFormat:@"%@%@ %@:%u",
            self.literalQualifiers,
            self.valueType.literalSpecifiers,
            variableName,
            (unsigned int)self.bits];
}

- (id)copyWithZone:(NSZone *)zone
{
    RKBitFieldType *other = [super copyWithZone:zone];
    other.bits = self.bits;
    return other;
}

@end


#pragma mark - Pointer/Function

@implementation RKPointerType

RK_PRIMITIVE_IMPLEMENTATION(Pointer, self.pointeeType.pointerLiteralSpecifiers, sizeof(void *), __alignof(void *))

- (RKType *)pointeeType
{
    return (_pointeeType ?: ((_pointeeType = RKVoidType.type)));
}

- (RKType *)valueType
{
    RKType *pointeeType = self.pointeeType;
    while ([pointeeType isKindOfClass:[RKPointerType class]]) {
        pointeeType = ((RKPointerType *)pointeeType).pointeeType;
    }
    return pointeeType;
}

- (void)setFlags:(RKQualifierFlag)flags
{
    // Const qualifier isn't supported for pointer type.
    [super setFlags:(flags & ~RKQualifierConstFlag)];
}

- (NSString *)literalQualifiers
{
    NSString *literalQualifiers = [super literalQualifiers];
    if (self.valueType.isConst) {
        literalQualifiers = [literalQualifiers stringByAppendingString:@"const "];
    }
    return literalQualifiers;
}

- (NSString *)encodeQualifiers
{
    NSString *encodeQualifiers = [super encodeQualifiers];
    if (self.valueType.isConst) {
        NSString *constQualifier = @((char[]){RKQualifierConstFlag, 0});
        encodeQualifiers = [encodeQualifiers stringByAppendingString:constQualifier];
    }
    return encodeQualifiers;
}

- (NSString *)encodeSpecifiers
{
    NSString *superEncodeSpecifiers = [super encodeSpecifiers];
    NSString *pointeeEncodeSpecifiers = self.pointeeType.encodeSpecifiers;
    return [superEncodeSpecifiers stringByAppendingString:pointeeEncodeSpecifiers];
}

- (id)copyWithZone:(NSZone *)zone
{
    RKPointerType *other = [super copyWithZone:zone];
    other.pointeeType = [self.pointeeType copy];
    return other;
}

@end


@implementation RKFunctionType

RK_PRIMITIVE_IMPLEMENTATION(Function, @"returntype (args...)", 0, __alignof(void (void)))

- (void)setFlags:(RKQualifierFlag)flags
{
    // No qualifiers.
}

- (NSString *)pointerLiteralSpecifiers
{
    return @"returntype (*)(args...)";
}

- (NSString *)declareStatementWithVariableName:(NSString *)variableName
{
    return [NSString stringWithFormat:@"returntype %@(args...)", variableName];
}

@end


#pragma mark - Array/Struct/Union

@implementation RKArrayType

- (NSString *)name
{
    return @"Array";
}

- (RKSignature)signature
{
    return RKSignatureArrayBegin;
}

- (NSString *)literalSpecifiers
{
    NSUInteger elementCount = self.elementCount;
    return [NSString stringWithFormat:@"%@ [%@]",
            self.elementType.literalSpecifiers,
            (elementCount > 0 ? @(elementCount) : @"")];
}

- (NSString *)encodeSpecifiers
{
    return [NSString stringWithFormat:@"%c%u%@%c",
            RKSignatureArrayBegin,
            (unsigned int)self.elementCount,
            self.elementType.encodeSpecifiers,
            RKSignatureArrayEnd];
}

- (NSUInteger)size
{
    return self.elementCount * self.elementType.alignedSize;
}

- (NSUInteger)alignment
{
    return self.elementType.alignment;
}

- (NSString *)pointerLiteralSpecifiers
{
    NSUInteger elementCount = self.elementCount;
    return [NSString stringWithFormat:@"%@ (*)[%@]",
            self.elementType.literalSpecifiers,
            (elementCount > 0 ? @(elementCount) : @"")];
}

- (NSString *)declareStatementWithVariableName:(NSString *)variableName
{
    NSUInteger elementCount = self.elementCount;
    return [NSString stringWithFormat:@"%@ %@[%@]",
            self.elementType.literalSpecifiers,
            variableName,
            (elementCount > 0 ? @(elementCount) : @"")];
}

@end

/*
@implementation RKStructMember

- (id)copyWithZone:(NSZone *)zone
{
    RKStructMember *other = [[[self class] allocWithZone:zone] init];
    other.memberName = self.memberName;
    other.memberType = [self.memberType copy];
    return other;
}

- (NSString *)description
{
    return [self.memberType declareStatementWithVariableName:self.memberName ?: @""];
}

@end

@implementation RKStructType

- (NSString *)name
{
    return @"Struct";
}

- (RKSignature)signature
{
    return RKSignatureStructBegin;
}

- (NSString *)literalSpecifiers
{
    NSMutableString *mutableLiteralSpecifiers = [[NSMutableString alloc] init];
    [mutableLiteralSpecifiers appendString:@"struct "];

    NSString *structName = self.structName;
    if (structName.length > 0) {
        [mutableLiteralSpecifiers appendString:structName];
        [mutableLiteralSpecifiers appendString:@" "];
    }

    NSString *key = NSStringFromSelector(@selector(literal));
    NSArray<NSString *> *literals = [self.elementTypes valueForKey:key];
    NSString *elementTypes = [literals componentsJoinedByString:@"; "];

    [mutableLiteralSpecifiers appendString:@"{"];
    [mutableLiteralSpecifiers appendString:elementTypes];
    [mutableLiteralSpecifiers appendString:@"}"];

    return [mutableLiteralSpecifiers copy];
}

- (NSString *)encodeSpecifiers
{
    NSMutableString *mutableEncodeSpecifiers = [[NSMutableString alloc] init];
    [mutableEncodeSpecifiers appendFormat:@"%c", RKSignatureStructBegin];

    NSString *structName = self.structName;
    structName = (structName.length > 0) ? structName : @"?";
    [mutableEncodeSpecifiers appendString:structName];
    [mutableEncodeSpecifiers appendString:@"="];

    NSString *key = NSStringFromSelector(@selector(encode));
    NSArray<NSString *> *encodes = [self.elementTypes valueForKey:key];
    NSString *elementEncodes = [encodes componentsJoinedByString:@""];

    [mutableEncodeSpecifiers appendString:elementEncodes];
    [mutableEncodeSpecifiers appendFormat:@"%c", RKSignatureStructEnd];

    return [mutableEncodeSpecifiers copy];
}

- (NSUInteger)size
{
    NSUInteger size = 0;
    for (RKType *elementType in self.elementTypes) {
        size = RKRoundSize(size, elementType.alignment);
        size += elementType.size;
    }
    return size;
}

- (NSUInteger)alignment
{
    NSUInteger defaultAlignment = __alignof(struct { int x; double y; });
    return MAX(self.elementTypes.firstObject.alignment, defaultAlignment);
}

@end

@implementation RKUnionMember

- (id)copyWithZone:(NSZone *)zone
{
    RKUnionMember *other = [[[self class] allocWithZone:zone] init];
    other.memberName = self.memberName;
    other.memberType = [self.memberType copy];
    return other;
}

- (NSString *)description
{
    return [self.memberType declareStatementWithVariableName:self.memberName ?: @""];
}

@end

@implementation RKUnionType

- (NSString *)name
{
    return @"Union";
}

- (RKSignature)signature
{
    return RKSignatureUnionBegin;
}

- (NSString *)literalSpecifiers
{
    NSMutableString *mutableLiteralSpecifiers = [[NSMutableString alloc] init];
    [mutableLiteralSpecifiers appendString:@"union "];

    NSString *unionName = self.unionName;
    if (unionName.length > 0) {
        [mutableLiteralSpecifiers appendString:unionName];
        [mutableLiteralSpecifiers appendString:@" "];
    }

    NSString *key = NSStringFromSelector(@selector(literal));
    NSArray<NSString *> *literals = [self.elementTypes valueForKey:key];
    NSString *elementTypes = [literals componentsJoinedByString:@"; "];

    [mutableLiteralSpecifiers appendString:@"{"];
    [mutableLiteralSpecifiers appendString:elementTypes];
    [mutableLiteralSpecifiers appendString:@"}"];

    return [mutableLiteralSpecifiers copy];
}

- (NSString *)encodeSpecifiers
{
    NSMutableString *mutableEncodeSpecifiers = [[NSMutableString alloc] init];
    [mutableEncodeSpecifiers appendFormat:@"%c", RKSignatureUnionBegin];

    NSString *unionName = self.unionName;
    unionName = (unionName.length > 0) ? unionName : @"?";
    [mutableEncodeSpecifiers appendString:unionName];
    [mutableEncodeSpecifiers appendString:@"="];

    NSString *key = NSStringFromSelector(@selector(encode));
    NSArray<NSString *> *encodes = [self.elementTypes valueForKey:key];
    NSString *elementEncodes = [encodes componentsJoinedByString:@""];

    [mutableEncodeSpecifiers appendString:elementEncodes];
    [mutableEncodeSpecifiers appendFormat:@"%c", RKSignatureUnionEnd];

    return [mutableEncodeSpecifiers copy];
}

- (NSUInteger)size
{
    NSUInteger size = 0;
    for (RKType *elementType in self.elementTypes) {
        size = MAX(size, elementType.size);
    }
    return size;
}

- (NSUInteger)alignment
{
    NSUInteger alignment = 0;
    for (RKType *elementType in self.elementTypes) {
        alignment = MAX(alignment, elementType.alignment);
    }
    return alignment;
}

@end


#pragma mark - Objective-C Types

@implementation RKClassType
RK_PRIMITIVE_IMPLEMENTATION(Class, @"Class", sizeof(Class), __alignof(Class))
@end


@implementation RKSelectorType
RK_PRIMITIVE_IMPLEMENTATION(Selector, @"SEL", sizeof(SEL), __alignof(SEL))
@end


@implementation RKObjectType
RK_PRIMITIVE_IMPLEMENTATION(Object, @"id", sizeof(id), __alignof(id))
@end


@implementation RKBlockType

- (NSString *)name
{
    return @"Block";
}

- (RKSignature)signature
{
    return RKSignatureFunction; // Actually that is `@?'.
}

- (NSString *)literalSpecifiers
{
    return @"returntype (^)(args...)";
}

- (NSString *)encodeSpecifiers
{
    return @"@?";
}

- (NSUInteger)size
{
    return sizeof(void (^)(void));
}

- (NSUInteger)alignment
{
    return __alignof(void (^)(void));
}

@end


#pragma mark - Others

@implementation RKAtomicType

@end

@implementation RKComplexType

@end

@implementation RKAtomType

@end

@implementation RKVectorType

@end


#pragma mark - Method Types

@implementation RKMethodReturnType

- (BOOL)isOneway
{
    return RKTestFlags(self.returnType.flags, RKQualifierOnewayFlag);
}

- (void)setIsOneway:(BOOL)isOneway
{
    self.returnType.flags = RKMixedFlags(self.returnType.flags,
                                         RKQualifierOnewayFlag,
                                         isOneway);
}

- (id)copyWithZone:(NSZone *)zone
{
    RKMethodReturnType *other = [[[self class] allocWithZone:zone] init];
    other.returnType = [self.returnType copy];
    return other;
}

- (NSString *)description
{
    return self.returnType.description;
}

@end

@implementation RKArgumentType

- (BOOL)isBycopy
{
    return RKTestFlags(self.argumentType.flags, RKQualifierBycopyFlag);
}

- (void)setIsBycopy:(BOOL)isBycopy
{
    self.argumentType.flags = RKMixedFlags(self.argumentType.flags,
                                           RKQualifierBycopyFlag,
                                           isBycopy);
}

- (BOOL)isByref
{
    return RKTestFlags(self.argumentType.flags, RKQualifierByrefFlag);
}

- (void)setIsByref:(BOOL)isByref
{
    self.argumentType.flags = RKMixedFlags(self.argumentType.flags,
                                           RKQualifierByrefFlag,
                                           isByref);
}

- (BOOL)isIn
{
    return RKTestFlags(self.argumentType.flags, RKQualifierInFlag);
}

- (void)setIsIn:(BOOL)isIn
{
    self.argumentType.flags = RKMixedFlags(self.argumentType.flags,
                                           RKQualifierInFlag,
                                           isIn);
}

- (BOOL)isInout
{
    return RKTestFlags(self.argumentType.flags, RKQualifierInoutFlag);
}

- (void)setIsInout:(BOOL)isInout
{
    self.argumentType.flags = RKMixedFlags(self.argumentType.flags,
                                           RKQualifierInoutFlag,
                                           isInout);
}

- (BOOL)isOut
{
    return RKTestFlags(self.argumentType.flags, RKQualifierOutFlag);
}

- (void)setIsOut:(BOOL)isOut
{
    self.argumentType.flags = RKMixedFlags(self.argumentType.flags,
                                           RKQualifierOutFlag,
                                           isOut);
}

- (id)copyWithZone:(NSZone *)zone
{
    RKArgumentType *other = [[[self class] allocWithZone:zone] init];
    other.argumentType = [self.argumentType copy];
    return other;
}

- (NSString *)description
{
    return self.argumentType.description;
}

@end

@implementation RKMethodType

- (NSString *)name
{
    return @"Method";
}

- (RKSignature)signature
{
    return RKSignatureFunction;
}

- (NSString *)literalSpecifiers
{
    NSString *key = NSStringFromSelector(@selector(literal));
    NSArray *components = [self.argumentTypes valueForKey:key];
    NSString *argumentTypes = [components componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"%@(%@)", self.methodReturnType, argumentTypes];
}

- (NSString *)encodeSpecifiers
{
    NSMutableString *encode = [[NSMutableString alloc] init];

    [encode appendFormat:@"%@", self.methodReturnType.returnType.encode];
    [encode appendFormat:@"%d", (int)[self offsetOfMethodReturnType]];

    NSArray<RKArgumentType *> *argumentTypes = self.argumentTypes;
    for (NSUInteger index = 0; index < argumentTypes.count; ++index) {
        RKArgumentType *item = [argumentTypes objectAtIndex:index];
        [encode appendFormat:@"%@", item.argumentType.encode];
        [encode appendFormat:@"%d", (int)[self offsetOfArgumentTypeAtIndex:index]];
    }

    return [encode copy];
}

- (RKQualifierFlag)flags
{
    return 0;
}

- (void)setFlags:(RKQualifierFlag)flags
{
    // Nothing to do.
}

- (NSUInteger)size
{
    return sizeof(void *);
}

- (NSUInteger)alignment
{
    return sizeof(void *);
}

- (NSString *)declareStatementWithVariableName:(NSString *)variableName
{
    NSString *key = NSStringFromSelector(@selector(literal));
    NSArray *components = [self.argumentTypes valueForKey:key];
    NSString *argumentTypes = [components componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"%@ %@(%@)",
            self.methodReturnType, variableName, argumentTypes];
}

- (NSUInteger)offsetOfMethodReturnType
{
    return [self offsetOfArgumentTypeAtIndex:NSUIntegerMax];
}

- (NSUInteger)offsetOfArgumentTypeAtIndex:(NSUInteger)index
{
    NSUInteger offset = 0;
    NSArray<RKArgumentType *> *argumentTypes = self.argumentTypes;
    index = MIN(index, argumentTypes.count);
    for (NSUInteger i = 0; i < index; ++i) {
        RKArgumentType *item = [argumentTypes objectAtIndex:i];
        offset += item.argumentType.size;
    }
    return offset;
}

@end
*/
