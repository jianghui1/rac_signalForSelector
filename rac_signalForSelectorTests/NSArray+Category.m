//
//  NSArray+Category.m
//  rac_signalForSelectorTests
//
//  Created by ys on 2018/9/11.
//  Copyright © 2018年 ys. All rights reserved.
//

#import "NSArray+Category.h"

#import <objc/runtime.h>

@implementation NSArray (Category)

// 这些代码来源于 https://www.jianshu.com/p/aae1411b9cdc
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayI") hft_hookOrigMenthod:@selector(objectAtIndex:) NewMethod:@selector(safe_objectAtIndex:)];
    });
}

- (void)safe_objectAtIndex:(NSInteger)index
{
    NSLog(@"我要做额外操作");
    [self safe_objectAtIndex:index];
}

+ (BOOL)hft_hookOrigMenthod:(SEL)origSel NewMethod:(SEL)altSel {
    Class class = self;
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method altMethod = class_getInstanceMethod(class, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    BOOL didAddMethod = class_addMethod(class,origSel,
                                        method_getImplementation(altMethod),
                                        method_getTypeEncoding(altMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,altSel,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, altMethod);
    }
    
    return YES;
}

@end
