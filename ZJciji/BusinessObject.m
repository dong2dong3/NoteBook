//
//  BusinessObject.m
//  ZJciji
//
//  Created by 张洁 on 2018/10/13.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import "BusinessObject.h"

@implementation BusinessObject

- (void)handle:(ResultBlock)result
{
    ComplitionBlock complition = ^(BOOL handled){
        //当前业务处理完成, 上抛结果
        if (handled)
        {
            result(self, handled);
        }
        else {
            //沿着责任链,交给下一个响应者处理
            if (self.nextHandler) {
                [self.nextHandler handle:result];
            } else {
                //没有业务处理,上抛
                result (nil, NO);
            }
        }
    };
    //当前业务进行处理
    [self handleBusiness:complition];
}

- (void)handleBusiness:(ComplitionBlock)complition
{
    //网络请求,异步下载图片,本地图片查询
    // 请求完成后调用
    complition(YES);
    complition(NO);
}

@end
