//
//  RKEncode.m
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2018/1/18.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import "RKEncode.h"
#import "RKType.h"


#pragma mark - Utilities

const char *
RKEncodeScanInteger(const char *encode,
                    char **terminate,
                    NSInteger *integerValue)
{
    char *endptr = NULL;
    long value = strtol(encode, &endptr, 10);
    if (terminate) *terminate = endptr ?: (char *)encode;
    if (integerValue) *integerValue = (NSInteger)value;
    return endptr > encode ? encode : NULL;
}

const char *
RKEncodeScanString(const char *encode,
                   char **terminate,
                   NSString * __autoreleasing *stringValue)
{
    char *endptr = NULL;
    char quote = *encode;
    if ('"' == quote || '\'' == quote) {
        endptr = strchr(encode + 1, quote);
        endptr = endptr ? (endptr + 1) : NULL;
    }
    if (terminate) {
        *terminate = endptr ?: (char *)encode;
    }
    if (stringValue) {
        if (endptr) {
            const char *startptr = encode + 1;
            size_t length = endptr - 1 - startptr;
            *stringValue = [[NSString alloc]
                            initWithBytes:startptr
                            length:length
                            encoding:NSUTF8StringEncoding];
        }
        else {
            *stringValue = nil;
        }
    }
    return endptr > encode ? encode : NULL;
}

const char *
RKEncodeScanPlaintext(const char *encode,
                      char **terminate,
                      const char *plaintext,
                      NSString * __autoreleasing *plaintextValue)
{
    size_t length = strlen(plaintext);
    if (0 == strncmp(encode, plaintext, length)) {
        if (terminate) *terminate = (char *)encode + length;
        if (plaintextValue) *plaintextValue = @(plaintext);
        return encode;
    }
    else {
        if (terminate) *terminate = (char *)encode;
        if (plaintextValue) *plaintextValue = nil;
        return NULL;
    }
}

const char *
RKEncodeScanClosedBrackets(const char *encode,
                           char **terminate,
                           NSString * __autoreleasing *innerValue)
{
    char openbracket = *encode;
    char closebracket = 0;

    switch (openbracket) {
        case '<':
            closebracket = '>';
            break;

        case '[':
            closebracket = ']';
            break;

        case '{':
            closebracket = '}';
            break;

        case '(':
            closebracket = ')';
            break;

        default:
            break;
    }

    if (closebracket && RKEncodeScanUpToCharacter(encode + 1,
                                                  terminate,
                                                  closebracket,
                                                  innerValue)) {
        if (terminate) ++*terminate;
        return encode;
    }
    else {
        if (terminate) *terminate = (char *)encode;
        if (innerValue) *innerValue = nil;
        return NULL;
    }
}

const char *
RKEncodeScanCharacter(const char *encode,
                      char **terminate,
                      char character,
                      BOOL isRepeat,
                      NSString * __autoreleasing *stringValue)
{
    const char *startptr = encode;

    if (character) {
        if (isRepeat) {
            for (; *encode && character == *encode; ++encode);
        }
        else {
            if (character == *encode) ++encode;
        }
    }

    if (terminate) *terminate = (char *)encode;
    if (stringValue) {
        if (startptr < encode) {
            *stringValue = [[NSString alloc]
                            initWithBytes:startptr
                            length:(encode - startptr)
                            encoding:NSUTF8StringEncoding];
        }
        else {
            *stringValue = nil;
        }
    }

    return startptr < encode ? startptr : NULL;
}

const char *
RKEncodeScanCharacterSet(const char *encode,
                         char **terminate,
                         const char *characterSet,
                         BOOL isRepeat,
                         NSString * __autoreleasing *stringValue)
{
    if (!*characterSet || !*(characterSet + 1)) {
        return RKEncodeScanCharacter(encode,
                                     terminate,
                                     *characterSet,
                                     isRepeat,
                                     stringValue);
    }

    const char *startptr = encode;

    if (isRepeat) {
        for (; *encode && strchr(characterSet, *encode); ++encode);
    }
    else {
        if (*encode && strchr(characterSet, *encode)) ++encode;
    }

    if (terminate) *terminate = (char *)encode;
    if (stringValue) {
        if (startptr < encode) {
            *stringValue = [[NSString alloc]
                            initWithBytes:startptr
                            length:(encode - startptr)
                            encoding:NSUTF8StringEncoding];
        }
        else {
            *stringValue = nil;
        }
    }

    return startptr < encode ? startptr : NULL;
}

const char *
RKEncodeScanUpToCharacter(const char *encode,
                          char **terminate,
                          char character,
                          NSString * __autoreleasing *prefixValue)
{
    if (terminate) *terminate = (char *)encode;
    if (prefixValue) *prefixValue = nil;

    char *startptr = (char *)encode;
    char *endptr = (char *)encode;
    for (; *encode && character != *encode; encode = endptr) {
        switch (*encode) {
            case '<':
            case '[':
            case '{':
            case '(':
                if (!RKEncodeScanClosedBrackets(encode, &endptr, NULL)) return NULL;
                break;

            case '"':
            case '\'':
                if (!RKEncodeScanString(encode, &endptr, NULL)) return NULL;
                break;

            default:
                endptr = (char *)encode + 1;
                break;
        }
    }
    if (!*encode) return NULL;

    if (terminate) {
        *terminate = endptr;
    }
    if (prefixValue) {
        *prefixValue = [[NSString alloc]
                        initWithBytes:startptr
                        length:(endptr - startptr)
                        encoding:NSUTF8StringEncoding];
    }
    return startptr;
}

const char *
RKEncodeScanUpToCharacterSet(const char *encode,
                             char **terminate,
                             const char *characterSet,
                             NSString * __autoreleasing *prefixValue)
{
    if (!*characterSet || !*(characterSet + 1)) {
        return RKEncodeScanUpToCharacter(encode,
                                         terminate,
                                         *characterSet,
                                         prefixValue);
    }

    if (terminate) *terminate = (char *)encode;
    if (prefixValue) *prefixValue = nil;

    char *startptr = (char *)encode;
    char *endptr = (char *)encode;
    for (; *encode && !strchr(characterSet, *encode); encode = endptr) {
        switch (*encode) {
            case '<':
            case '[':
            case '{':
            case '(':
                if (!RKEncodeScanClosedBrackets(encode, &endptr, NULL)) return NULL;
                break;

            case '"':
            case '\'':
                if (!RKEncodeScanString(encode, &endptr, NULL)) return NULL;
                break;

            default:
                endptr = (char *)encode + 1;
                break;
        }
    }
    if (!*encode) return NULL;

    if (terminate) {
        *terminate = endptr;
    }
    if (prefixValue) {
        *prefixValue = [[NSString alloc]
                        initWithBytes:startptr
                        length:(endptr - startptr)
                        encoding:NSUTF8StringEncoding];
    }
    return startptr;
}

const char *
RKEncodeScanUpToEnd(const char *encode,
                    char **terminate,
                    NSString * __autoreleasing *stringValue)
{
    if (terminate) *terminate = (char *)encode + strlen(encode);
    if (stringValue) *stringValue = @(encode);
    return encode;
}


#pragma mark - Components

RKQualifierFlag
RKEncodeScanQualifiers(const char *encode,
                       char **terminate)
{
    RKQualifierFlag flags = 0;

    do {
        switch (*encode) {

#define RK_QUALIFIER(name, code, flag) \
/**/        case RKQualifier##name: \
/**/            flags |= RKQualifier##name##Flag; \
/**/            break;
#include "RKEncode.def"

            default:
                if (terminate) *terminate = (char *)encode;
                return flags;
        }
    }
    while (*++encode);

    if (terminate) *terminate = (char *)encode;
    return flags;
}

RKSignature
RKEncodeScanSignature(const char *encode,
                      char **terminate)
{
    RKSignature signature = 0;

    switch (*encode) {

#define RK_SIGNATURE(name, code, type) \
/**/    case RKSignature##name:
#define RK_COMPOSITE_END_SIGNATURE(name, code)
#include "RKEncode.def"
            signature = *encode;
            ++encode;
            break;

        default:
            break;
    }

    if (terminate) *terminate = (char *)encode;
    return signature;
}







//#pragma mark - Utilities
//
//const char *
//RKEncodeSkipUsingBlock(const char *encode,
//                       const char * (^block)(const char *encode),
//                       NSString * __autoreleasing *skipped)
//{
//    NSCParameterAssert(encode);
//    if (!encode) {
//        if (skipped) {
//            *skipped = nil;
//        }
//        return encode;
//    }
//
//    const char *originalEncode = encode;
//    encode = block ? block(encode) : encode;
//
//    if (skipped) {
//        NSString *found = nil;
//        if (encode > originalEncode) {
//            found = [[NSString alloc]
//                     initWithBytes:originalEncode
//                     length:(encode - originalEncode)
//                     encoding:NSUTF8StringEncoding];
//        }
//        *skipped = found;
//    }
//
//    return encode;
//}
//
//#pragma mark - Basics
//
//const char *
//RKEncodeSkipNumber(const char *encode,
//                   NSString * __autoreleasing *number)
//{
//    return RKEncodeSkipUsingBlock(encode, ^const char *(const char *encode) {
//        if ('-' == *encode || '+' == *encode) {
//            char nextCharacter = *(encode + 1);
//            if ('0' <= nextCharacter && nextCharacter <= '9') {
//                encode += 2;
//            }
//            else {
//                return encode;
//            }
//        }
//        while ('0' <= *encode && *encode <= '9') {
//            ++encode;
//        }
//        return encode;
//    }, number);
//}
//
//const char *
//RKEncodeSkipSymbol(const char *encode,
//                   NSString * __autoreleasing *symbol)
//{
//    return RKEncodeSkipUsingBlock(encode, ^const char *(const char *encode) {
//        if (('a' <= *encode && *encode <= 'z') ||
//            ('A' <= *encode && *encode <= 'Z') ||
//            ('_' == *encode)) {
//            ++encode;
//        }
//        else {
//            return encode;
//        }
//        while (('a' <= *encode && *encode <= 'z') ||
//               ('A' <= *encode && *encode <= 'Z') ||
//               ('0' <= *encode && *encode <= '9') ||
//               ('_' == *encode)) {
//            ++encode;
//        }
//        return encode;
//    }, symbol);
//}
//
//const char *
//RKEncodeSkipString(const char *encode,
//                   NSString * __autoreleasing *string)
//{
//    NSString *quotedString = nil;
//    encode = RKEncodeSkipUsingBlock(encode, ^const char *(const char *encode) {
//        if ('"' == *encode) {
//            do {
//                ++encode;
//            } while (*encode && '"' != *encode);
//
//            if ('"' == *encode) {
//                ++encode;
//            }
//        }
//        return encode;
//    }, string ? &quotedString : NULL);
//
//    if (string && quotedString) {
//        NSUInteger length = [quotedString length];
//        if (length >= 2 && '"' == [quotedString characterAtIndex:length - 1]) {
//            length -= 2;
//        }
//        else {
//            --length;
//        }
//        *string = [quotedString substringWithRange:NSMakeRange(1, length)];
//    }
//
//    return encode;
//}
//
//#pragma mark - Components
//
//static
//const char *
//RKEncodeSkipComponentInternal(const char *encode,
//                              NSArray<NSString *> *allComponents,
//                              NSString * __autoreleasing *component)
//{
//    return RKEncodeSkipUsingBlock(encode, ^const char *(const char *encode) {
//        for (NSString *currentComponent in allComponents) {
//            if (0 == strncmp(encode,
//                             [currentComponent UTF8String],
//                             [currentComponent length])) {
//                encode += [currentComponent length];
//                break;
//            }
//        }
//        return encode;
//    }, component);
//}
//
//static
//const char *
//RKEncodeSkipContinuousComponentsInternal(const char *encode,
//                                         NSArray<NSString *> *allComponents,
//                                         NSString * __autoreleasing *continuousComponents)
//{
//    return RKEncodeSkipUsingBlock(encode, ^const char *(const char *encode) {
//        const char *lastEncode;
//        do {
//            lastEncode = encode;
//            for (NSString *currentComponent in allComponents) {
//                if (0 == strncmp(encode,
//                                 [currentComponent UTF8String],
//                                 [currentComponent length])) {
//                    encode += [currentComponent length];
//                    break;
//                }
//            }
//        } while (lastEncode != encode && *encode);
//        return encode;
//    }, continuousComponents);
//}
//
//const char *
//RKEncodeSkipComponent(const char *encode,
//                      NSArray<NSString *> *allComponents,
//                      NSString * __autoreleasing *component)
//{
//    allComponents = [allComponents sortedArrayUsingComparator:
//                     ^NSComparisonResult(NSString *obj1, NSString *obj2) {
//                         return [@([obj2 length]) compare:@([obj1 length])];
//                     }];
//    return RKEncodeSkipComponentInternal(encode, allComponents, component);
//}
//
//const char *
//RKEncodeSkipContinuousComponents(const char *encode,
//                                 NSArray<NSString *> *allComponents,
//                                 NSString * __autoreleasing *continuousComponents)
//{
//    allComponents = [allComponents sortedArrayUsingComparator:
//                     ^NSComparisonResult(NSString *obj1, NSString *obj2) {
//                         return [@([obj2 length]) compare:@([obj1 length])];
//                     }];
//    return RKEncodeSkipContinuousComponentsInternal(encode,
//                                                    allComponents,
//                                                    continuousComponents);
//}
//
//#pragma mark - Elements
//
//static
//NSArray<NSString *> *
//RKEncodeGetAllOrderedQualifiers()
//{
//    static NSArray<NSString *> *allQualifiers = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        allQualifiers = @[
//#define RK_QUALIFIER(name, value, flag) RKQualifier##name,
//#include "RKEncode.def"
//                          ];
//
//        allQualifiers = [allQualifiers sortedArrayUsingComparator:
//                         ^NSComparisonResult(NSString *obj1, NSString *obj2) {
//                             return [@([obj2 length]) compare:@([obj1 length])];
//                         }];
//    });
//    return allQualifiers;
//}
//
//static
//NSArray<NSString *> *
//RKEncodeGetAllOrderedSignatures()
//{
//    static NSArray<NSString *> *allSignatures = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        allSignatures = @[
//#define RK_SIGNATURE(name, value) RKSignature##name,
//#define RK_COMPOSITE_END_SIGNATURE(name, value)
//#include "RKEncode.def"
//                          ];
//
//        allSignatures = [allSignatures sortedArrayUsingComparator:
//                         ^NSComparisonResult(NSString *obj1, NSString *obj2) {
//                             return [@([obj2 length]) compare:@([obj1 length])];
//                         }];
//    });
//    return allSignatures;
//}
//
//const char *
//RKEncodeSkipQualifier(const char *encode,
//                      NSString * __autoreleasing *qualifier)
//{
//    return RKEncodeSkipComponentInternal(encode,
//                                         RKEncodeGetAllOrderedQualifiers(),
//                                         qualifier);
//}
//
//const char *
//RKEncodeSkipContinuousQualifiers(const char *encode,
//                                 NSString * __autoreleasing *continuousQualifiers)
//{
//    return RKEncodeSkipContinuousComponentsInternal(encode,
//                                                    RKEncodeGetAllOrderedQualifiers(),
//                                                    continuousQualifiers);
//}
//
//const char *
//RKEncodeSkipSignature(const char *encode,
//                      NSString * __autoreleasing *signature)
//{
//    return RKEncodeSkipComponentInternal(encode,
//                                         RKEncodeGetAllOrderedSignatures(),
//                                         signature);
//}
//
//#pragma mark - Types
//
//const char *
//RKEncodeSkipType(const char *encode,
//                 RKType * __autoreleasing *skippedType)
//{
//    const char *originalEncode = encode;
//
//    // Skip qualifiers.
//
//    RKQualifierFlag flags = 0;
//    NSString *qualifier = nil;
//
//    do {
//        encode = RKEncodeSkipQualifier(encode, &qualifier);
//        #define RK_QUALIFIER(name, value, flag) \
//        flags |= ([qualifier isEqualToString:RKQualifier##name] ? RKQualifier##name##Flag : 0);
//        #include "RKEncode.def"
//    }
//    while (qualifier);
//
//    // Skip signature.
//
//    NSString *signature = nil;
//    encode = RKEncodeSkipSignature(encode, &signature);
//    if (!signature) {
//        return originalEncode;
//    }
//
//    // Scalars/void/bool/char */Function/Class/SEL/Half/Atom/Vector.
//
//    BOOL (^verifyAndCreateType)(NSString *typeSignature, Class typeClass);
//    verifyAndCreateType = ^BOOL(NSString *typeSignature, Class typeClass) {
//        if ([typeSignature isEqualToString:signature]) {
//            if (skippedType) {
//                RKType *type = [[typeClass alloc] init];
//                type.flags = flags;
//                *skippedType = type;
//            }
//            return YES;
//        }
//        return NO;
//    };
//
//#define RK_VERIFY_AND_CREATE_TYPE(name, value) \
//if (verifyAndCreateType(RKSignature##name, RK##name##Type.class)) return encode;
//
//#define RK_SCALAR_SIGNATURE(name, value) RK_VERIFY_AND_CREATE_TYPE(name, value)
//#define RK_VOID_SIGNATURE(name, value) RK_VERIFY_AND_CREATE_TYPE(name, value)
//#define RK_BOOL_SIGNATURE(name, value) RK_VERIFY_AND_CREATE_TYPE(name, value)
//#define RK_CHARACTERSPOINTER_SIGNATURE(name, value) RK_VERIFY_AND_CREATE_TYPE(name, value)
//
//#define RK_FUNCTION_SIGNATURE(name, value) RK_VERIFY_AND_CREATE_TYPE(name, value)
//#define RK_CLASS_SIGNATURE(name, value) RK_VERIFY_AND_CREATE_TYPE(name, value)
//#define RK_SELECTOR_SIGNATURE(name, value) RK_VERIFY_AND_CREATE_TYPE(name, value)
//
//#define RK_HALF_SIGNATURE(name, value) RK_VERIFY_AND_CREATE_TYPE(name, value)
//#define RK_ATOM_SIGNATURE(name, value) RK_VERIFY_AND_CREATE_TYPE(name, value)
//#define RK_VECTOR_SIGNATURE(name, value) RK_VERIFY_AND_CREATE_TYPE(name, value)
//
//#include "RKEncode.def"
//
//#undef RK_VERIFY_AND_CREATE_TYPE
//
//    // Bit-fields := [<qualifiers>]'b'<bits>['b'<bits>...]
//
//    if ([signature isEqualToString:RKSignatureBitFields]) {
//        // TODO: [<qualifiers>]'b'<bits>['b'<bits>...]
//    }
//
//    // Pointer := [<qualifiers>]'^'[<encode>]
//
//    if ([signature isEqualToString:RKSignaturePointer]) {
//        RKType *pointTo = nil;
//        encode = RKEncodeSkipType(encode, &pointTo);
//        if (skippedType && pointTo) {
//            RKPointerType *pointerType = [[RKPointerType alloc] init];
//            pointerType.flags = flags;
//            pointerType.pointTo = pointTo;
//            pointTo.flags |= (flags & RKQualifierConstFlag);
//            *skippedType = pointerType;
//        }
//        return encode;
//    }
//
//    // Object
//
//    // object := [<qualifiers>]'@'[<class>]
//    // class := '"'<class-name>[<protocal_list>]'"'
//    // protocal_list := <protocal 1>[<protocal 2>...]
//    // protocal := '<'<protocal-name>'>'
//
//    if ([signature isEqualToString:RKSignatureObject]) {
//        NSString *name = nil;
//        encode = RKEncodeSkipString(encode, &name);
//        if (skippedType) {
//            NSString *className;
//            NSArray<NSString *> *protocolNames;
//
//            NSUInteger startLocation = 0;
//            NSUInteger length = name.length - startLocation;
//
//            NSRange searchRange = NSMakeRange(startLocation, length);
//            NSRange startRange = [name rangeOfString:@"<" options:0 range:searchRange];
//            if (NSNotFound == startRange.location) {
//                className = name;
//            }
//            else {
//                className = [name substringToIndex:startRange.location];
//                startLocation = startRange.location + 1;
//                length = name.length - startLocation;
//                if ([name hasSuffix:@">"]) {
//                    --length;
//                }
//                NSRange protocolsRange = NSMakeRange(startLocation, length);
//                NSString *protocolsList = [name substringWithRange:protocolsRange];
//                protocolNames = [protocolsList componentsSeparatedByString:@"><"];
//            }
//
//            RKObjectType *objectType = [[RKObjectType alloc] init];
//            objectType.flags = flags;
//            objectType.objectClassName = className;
//            objectType.objectProtocolNames = protocolNames;
//            *skippedType = objectType;
//        }
//        return encode;
//    }
//
//    // Block
//
//    // block := [<qualifiers>]'@''?'['<'<return>'@''?'[<argument_list>]'>']
//    // return := <return type encode>
//    // argument_list := <argument 1>[<argument 2>...]
//    // argument := <argument type encode>
//
//    if ([signature isEqualToString:RKSignatureBlock]) {
//        if ('<' == *encode) {
//            int count = 1;
//            while (!*++encode || 0 == count) {
//                if ('<' == *encode) ++count;
//                if ('>' == *encode) --count;
//            }
//        }
//        if (skippedType) {
//            RKBlockType *blockType = [[RKBlockType alloc] init];
//            blockType.flags = flags;
//            *skippedType = blockType;
//        }
//        return encode;
//    }
//
//    // Atomic := 'A'<encode>
//
//    if ([signature isEqualToString:RKSignatureAtomic]) {
//        encode = RKEncodeSkipType(encode, NULL);
//        if (skippedType) {
//            RKAtomicType *atomicType = [[RKAtomicType alloc] init];
//            atomicType.flags = flags;
//            *skippedType = atomicType;
//        }
//        return encode;
//    }
//
//    // Complex := 'j'<encode>
//
//    if ([signature isEqualToString:RKSignatureComplex]) {
//        encode = RKEncodeSkipType(encode, NULL);
//        if (skippedType) {
//            RKComplexType *complexType = [[RKComplexType alloc] init];
//            complexType.flags = flags;
//            *skippedType = complexType;
//        }
//        return encode;
//    }
//
//    // Array := '['<count><encode of elements>']'
//
//    if ([signature isEqualToString:RKSignatureArrayBegin]) {
//        NSString *countString = nil;
//        encode = RKEncodeSkipNumber(encode, &countString);
//
//        RKType *elementType = nil;
//        encode = RKEncodeSkipType(encode, &elementType);
//
//        if (!countString || !elementType || ']' != *encode) {
//            return originalEncode;
//        }
//
//        if (skippedType) {
//            RKArrayType *arrayType = [[RKArrayType alloc] init];
//            arrayType.flags = flags;
//            arrayType.elementType = elementType;
//            *skippedType = arrayType;
//        }
//
//        return encode;
//    }
//
//    // Struct
//
//    // struct := '{'{'?'|<name>}[=[<field_list>]]'}'
//    // name := <structure name>[<c++ template argument lists>]
//    // field_list := <field 1>[<field 2>...]
//    // field := ['"'<field name>'"']<encode>
//
//    if ([signature isEqualToString:RKSignatureStructBegin]) {
//        const char *nameStartPosition = encode;
//        while (*++encode && '=' != *encode) {
//            if ('<' == *encode) {
//                int count = 1;
//                while (!*++encode || 0 == count) {
//                    if ('<' == *encode) ++count;
//                    if ('>' == *encode) --count;
//                }
//            }
//        }
//        if (skippedType) {
//            NSString *name = [[NSString alloc]
//                              initWithBytes:nameStartPosition
//                              length:(encode - nameStartPosition)
//                              encoding:NSUTF8StringEncoding];
//            RKStructType *structType = [[RKStructType alloc] init];
//            structType.flags = flags;
//            structType.structName = name;
//            *skippedType = structType;
//        }
//        int count = 1;
//        while (!*++encode || 0 == count) {
//            if ('{' == *encode) ++count;
//            if ('}' == *encode) --count;
//        }
//        return encode;
//    }
//
//    // Union
//
//    // union := '('{'?'|<name>}[=[<field_list>]]')'
//    // name := <union name>[<c++ template argument lists>]
//    // field_list := <field 1>[<field 2>...]
//    // field := ['"'<field name>'"']<encode>
//
//    if ([signature isEqualToString:RKSignatureUnionBegin]) {
//        const char *nameStartPosition = encode;
//        while (*++encode && '=' != *encode) {
//            if ('<' == *encode) {
//                int count = 1;
//                while (!*++encode || 0 == count) {
//                    if ('<' == *encode) ++count;
//                    if ('>' == *encode) --count;
//                }
//            }
//        }
//        if (skippedType) {
//            NSString *name = [[NSString alloc]
//                              initWithBytes:nameStartPosition
//                              length:(encode - nameStartPosition)
//                              encoding:NSUTF8StringEncoding];
//            RKUnionType *unionType = [[RKUnionType alloc] init];
//            unionType.flags = flags;
//            unionType.unionName = name;
//            *skippedType = unionType;
//        }
//        int count = 1;
//        while (!*++encode || 0 == count) {
//            if ('(' == *encode) ++count;
//            if (')' == *encode) --count;
//        }
//        return encode;
//    }
//
//    return originalEncode;
//}

