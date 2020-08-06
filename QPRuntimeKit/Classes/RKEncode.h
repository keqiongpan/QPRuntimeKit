//
//  RKEncode.h
//  QPRuntimeKit
//
//  Created by keqiongpan@163.com on 2018/1/18.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - Qualifiers

#ifndef RK_QUALIFIER_CONSTANTS
#define RK_QUALIFIER_CONSTANTS

typedef NS_ENUM(unsigned char, RKQualifier) {
#define RK_QUALIFIER(name, code, flag) \
/**/    RKQualifier##name = (code),
#include "RKEncode.def"
};

#endif


#pragma mark - QualifierFlags

#ifndef RK_QUALIFIERFLAG_CONSTANTS
#define RK_QUALIFIERFLAG_CONSTANTS

typedef NS_OPTIONS(NSUInteger, RKQualifierFlag) {
#define RK_QUALIFIER(name, code, flag) \
/**/    RKQualifier##name##Flag = (flag),
#include "RKEncode.def"
};

#endif


#pragma mark - Signatures

#ifndef RK_SIGNATURE_CONSTANTS
#define RK_SIGNATURE_CONSTANTS

typedef NS_ENUM(unsigned char, RKSignature) {
#define RK_SIGNATURE(name, code, type) \
/**/    RKSignature##name = (code),
#include "RKEncode.def"
};

#endif


NS_ASSUME_NONNULL_BEGIN


#pragma mark - Utilities

const char * _Nullable
RKEncodeScanInteger(const char *encode,
                    char * _Nullable * _Nullable terminate,
                    NSInteger * _Nullable integerValue);

const char * _Nullable
RKEncodeScanString(const char *encode,
                   char * _Nullable * _Nullable terminate,
                   NSString * __autoreleasing _Nullable * _Nullable stringValue);

const char * _Nullable
RKEncodeScanPlaintext(const char *encode,
                      char * _Nullable * _Nullable terminate,
                      const char *plaintext,
                      NSString * __autoreleasing _Nullable * _Nullable plaintextValue);

const char * _Nullable
RKEncodeScanClosedBrackets(const char *encode,
                           char * _Nullable * _Nullable terminate,
                           NSString * __autoreleasing _Nullable * _Nullable innerValue);

const char * _Nullable
RKEncodeScanCharacter(const char *encode,
                      char * _Nullable * _Nullable terminate,
                      char character,
                      BOOL isRepeat,
                      NSString * __autoreleasing _Nullable * _Nullable stringValue);

const char * _Nullable
RKEncodeScanCharacterSet(const char *encode,
                         char * _Nullable * _Nullable terminate,
                         const char *characterSet,
                         BOOL isRepeat,
                         NSString * __autoreleasing _Nullable * _Nullable stringValue);

const char * _Nullable
RKEncodeScanUpToCharacter(const char *encode,
                          char * _Nullable * _Nullable terminate,
                          char character,
                          NSString * __autoreleasing _Nullable * _Nullable prefixValue);

const char * _Nullable
RKEncodeScanUpToCharacterSet(const char *encode,
                             char * _Nullable * _Nullable terminate,
                             const char *characters,
                             NSString * __autoreleasing _Nullable * _Nullable prefixValue);

const char * _Nullable
RKEncodeScanUpToEnd(const char *encode,
                    char * _Nullable * _Nullable terminate,
                    NSString * __autoreleasing _Nullable * _Nullable stringValue);


#pragma mark - Components

RKQualifierFlag
RKEncodeScanQualifiers(const char *encode,
                       char * _Nullable * _Nullable terminate);

RKSignature
RKEncodeScanSignature(const char *encode,
                      char * _Nullable * _Nullable terminate);


NS_ASSUME_NONNULL_END
