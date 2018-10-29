//
//  Command.m
//  ZJciji
//
//  Created by 张洁 on 2018/10/13.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import "Command.h"
#import "CommandsManager.h"
@implementation Command

- (void)excute
{
    //override by subclass
    [self done];
}

- (void)cancel
{
    self.complition = nil;
}

- (void)done
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_complition) {
            self->_complition(self);
        }
        //避免循环引用
        self.complition = nil;
        [[CommandsManager sharedManager].arrayCommands removeObject:self];
    })
    
}


@end
