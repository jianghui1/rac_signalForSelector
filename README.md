###### RAC 的应用 ----- rac_signalForSelector
不熟悉`RAC`的可能不知道这个方法，这个方法的作用就是将一个对象的方法触发事件转换成信号，通过对该信号的订阅获取该方法执行的时机。

那么使用该方法的优势是什么呢？

想一下，在做项目的时候，对于系统的或者第三方的实例方法，如果我们想要在对应的方法中执行其他额外操作，会如何操作呢？

一般来说，就会使用`Runtime`黑魔法替换方法，然后在替换后的方法中做需要的操作。但是，这种方法需要新建类目，在类目中实现对应方法的替换。

如果使用`rac_signalForSelector`方法，直接进行额外代码的添加，非常方便。


完整测试用例在[这里]()。

测试用例如下：

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

NSArray+Category.h中的代码如下：

// 这些代码来源于 [这里](https://www.jianshu.com/p/aae1411b9cdc)。
    
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


