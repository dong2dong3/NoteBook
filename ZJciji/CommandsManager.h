//
//  CommandsManager.h
//  ZJciji
//
//  Created by 张洁 on 2018/10/13.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"
@interface CommandsManager : NSObject

@property (nonatomic, strong)NSMutableArray<Command *> *arrayCommands;

+ (instancetype)sharedManager;

+ (void)executeCommand:(Command *)cmd complition:(CommandComplitonCallBack)complition;
+ (void)cancleCommand:(Command *)cmd;

@end
