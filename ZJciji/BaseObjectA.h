//
//  BaseObjectA.h
//  ZJciji
//
//  Created by 张洁 on 2018/10/13.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObjectB.h"
@interface BaseObjectA : NSObject

//桥接模式的核心实现
@property (nonatomic, strong) BaseObjectB *objB;

- (void) handle;

@end



