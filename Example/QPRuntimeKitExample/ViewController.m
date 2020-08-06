//
//  ViewController.m
//  QPRuntimeKitExample
//
//  Created by keqiongpan@163.com on 2020/08/06.
//  Copyright (c) 2020 Qiongpan Ke. All rights reserved.
//

#import <QPRuntimeKit/QPRuntimeKit.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    RKClass *objectClass = [RKClass classWithPrototype:[NSObject class]];
    NSLog(@"NSObject's runtime description:\n%@", objectClass);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
