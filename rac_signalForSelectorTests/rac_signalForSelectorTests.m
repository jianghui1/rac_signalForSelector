//
//  rac_signalForSelectorTests.m
//  rac_signalForSelectorTests
//
//  Created by ys on 2018/9/11.
//  Copyright © 2018年 ys. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <ReactiveCocoa.h>

@interface rac_signalForSelectorTests : XCTestCase

@end

@implementation rac_signalForSelectorTests

- (void)test_original
{
    NSArray *array = @[@"original"];

    NSLog(@"%@ -- %@", array, [array objectAtIndex:0]);

    // 打印日志
    /*
     2018-09-11 17:01:57.264419+0800 rac_signalForSelector[9142:16490071] (
     original
     ) -- original
     */
}

- (void)test_rac_signalForSelector
{
    NSArray *array = @[@"rac_signalForSelector"];

    [[array rac_signalForSelector:@selector(objectAtIndex:)]
     subscribeNext:^(id x) {
         NSLog(@"我要做额外操作了");
     }];

    NSLog(@"%@ -- %@", array, [array objectAtIndex:0]);

    // 打印日志
    /*
     2018-09-11 17:03:01.466822+0800 rac_signalForSelector[9204:16494163] 我要做额外操作了
     2018-09-11 17:03:01.467130+0800 rac_signalForSelector[9204:16494163] (
     "rac_signalForSelector"
     ) -- rac_signalForSelector
     */
}

- (void)test_runtime
{
    NSArray *array = @[@"runtime"];
    
    NSLog(@"%@ -- %@", array, [array objectAtIndex:0]);
    
    // 打印日志
    /*
     2018-09-11 17:17:37.470704+0800 rac_signalForSelector[9845:16539008] 我要做额外操作
     2018-09-11 17:17:37.470959+0800 rac_signalForSelector[9845:16539008] 我要做额外操作
     2018-09-11 17:17:37.471245+0800 rac_signalForSelector[9845:16539008] 我要做额外操作
     2018-09-11 17:17:37.472027+0800 rac_signalForSelector[9845:16539008] 我要做额外操作
     2018-09-11 17:17:37.472994+0800 rac_signalForSelector[9845:16539008] 我要做额外操作
     2018-09-11 17:17:37.491610+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.494734+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.513366+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.517950+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.518108+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.519791+0800 rac_signalForSelector[9845:16539008] 我要做额外操作
     2018-09-11 17:17:37.520042+0800 rac_signalForSelector[9845:16539008] 我要做额外操作
     2018-09-11 17:17:37.605739+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.605923+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.606092+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.606213+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.606333+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.606440+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.607601+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.607765+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     2018-09-11 17:17:37.633991+0800 rac_signalForSelector[9845:16538959] 我要做额外操作
     Test Suite 'Selected tests' started at 2018-09-11 17:17:37.683
     Test Suite 'rac_signalForSelectorTests.xctest' started at 2018-09-11 17:17:37.684
     Test Suite 'rac_signalForSelectorTests' started at 2018-09-11 17:17:37.685
     Test Case '-[rac_signalForSelectorTests test_runtime]' started.
     2018-09-11 17:17:37.686383+0800 rac_signalForSelector[9845:16538959] (
     runtime
     ) -- runtime
     */
}

@end
