//
//  Tests.m
//  QPRuntimeKitTests
//
//  Created by keqiongpan@163.com on 2020/08/06.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

@import XCTest;
@import QPRuntimeKit;

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testClass
{
    Class aClass = [NSObject class];
    RKClass *objectClass = [RKClass classWithPrototype:aClass];
    XCTAssertNotNil(objectClass);

    NSString *objectClassRuntimeDescription = [objectClass description];
    XCTAssert([objectClassRuntimeDescription rangeOfString:@"@interface NSObject"].location >= 0);
    NSLog(@"NSObject's class:\n%@", objectClassRuntimeDescription);
}

@end

