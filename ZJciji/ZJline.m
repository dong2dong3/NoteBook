//
//  ZJline.m
//  ZJciji
//
//  Created by 张洁 on 2018/9/23.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import "ZJline.h"

@implementation ZJline

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeCGPoint:_begin forKey:@"begin"];
    [aCoder encodeCGPoint:_end forKey:@"end"];
    [aCoder encodeObject:_lineColor forKey:@"lineColor"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        self.begin = [aDecoder decodeCGPointForKey:@"begin"];
        self.end = [aDecoder decodeCGPointForKey:@"end"];
        self.lineColor = [aDecoder decodeObjectForKey:@"lineColor"];
    }
    return self;
}


+ (BOOL) accessInstanceVariablesDirectly {
    return YES;
}
@end




