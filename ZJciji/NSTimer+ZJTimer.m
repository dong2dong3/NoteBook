//
//  NSTimer+ZJTimer.m
//  ZJciji
//
//  Created by 张洁 on 2018/9/27.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import "NSTimer+ZJTimer.h"

@implementation NSTimer (ZJTimer)

+ (NSTimer *) zj_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)())block
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(zj_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)zj_blockInvoke:(NSTimer* )timer
{
    void(^block)(void) = timer.userInfo;
    if(block)
    {
        block();
    }
}

@end
