//
//  Command.h
//  ZJciji
//
//  Created by 张洁 on 2018/10/13.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Command;
typedef void(^CommandComplitonCallBack)(Command *cmd);

@interface Command : NSObject

@property (nonatomic, strong)CommandComplitonCallBack complition;
- (void)excute;
- (void)cancel;
- (void)done;

@end
