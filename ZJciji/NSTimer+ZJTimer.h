//
//  NSTimer+ZJTimer.h
//  ZJciji
//
//  Created by 张洁 on 2018/9/27.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ZJTimer)

+ (NSTimer *) zj_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)())block;

@end
