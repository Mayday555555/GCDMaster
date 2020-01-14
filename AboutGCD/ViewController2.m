//
//  ViewController2.m
//  AboutGCD
//
//  Created by 陈铉泽 on 2019/3/12.
//  Copyright © 2019 陈铉泽. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()
@property UILabel *label;
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label = [[UILabel alloc]init];
    self.label.font = [UIFont systemFontOfSize:18];
    self.label.textColor = [UIColor colorNamed:@"c5c5c5"];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.frame = CGRectMake(0, 100, UIScreen.mainScreen.bounds.size.width, 44);
    [self.view addSubview:self.label];
    
//    [self groupNotify];
//    [self groupWait];
    [self semaphore];
}

- (void)method {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_queue_t customQueue = dispatch_queue_create("哈哈", DISPATCH_QUEUE_SERIAL);
}

//MARK: 栅栏
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("haha", DISPATCH_QUEUE_CONCURRENT);
    dispatch_barrier_async(queue, ^{
        
    });
}

//MARK:延时
- (void)after {
    dispatch_after(dispatch_time(DISPATCH_WALLTIME_NOW, 2), dispatch_get_main_queue(), ^{
        NSLog(@"两秒后执行");
    });
}

//MARK:一次性代码
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
}

//MARK:单例
+(id)shareInstance {
    static ViewController2 *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ViewController2 alloc]init];
    });
    return shareInstance;
}

//MARK:快速迭代
- (void)apply {
    dispatch_queue_t customQueue = dispatch_queue_create("haha", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply(6, customQueue, ^(size_t index) {
        NSLog(@"%zu", index);
    });
}

//MARK:队列组
- (void)groupNotify {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, globalQueue, ^{
        for (int i; i <3; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1...%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, globalQueue, ^{
        for (int i; i <3; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2...%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, globalQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"notify... %@",[NSThread currentThread]);
    });
}

- (void)groupWait {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    NSLog(@"group begin");
    dispatch_group_async(group, globalQueue, ^{
        for (int i; i <3; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1...%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, globalQueue, ^{
        for (int i; i <3; i ++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2...%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group end");
}

//MARK:信号量
//func semaphore() {
//    let queue = DispatchQueue.global(qos: .default)
//    let semaphore = DispatchSemaphore(value: 1)
//    for i in 0..<100 {
//        queue.async {
//            //                semaphore.wait(timeout: DispatchTime.distantFuture)
//            print("i=\(i)")
//            //                semaphore.signal()
//        }
//    }
//}
- (void)semaphore {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_async(queue, ^{
        for (int i = 0; i < 100; i ++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"i = %d", i);
            dispatch_semaphore_signal(semaphore);
        }
    });
    
    
}

@end
