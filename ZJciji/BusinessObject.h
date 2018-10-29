//
//  BusinessObject.h
//  ZJciji
//
//  Created by 张洁 on 2018/10/13.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BusinessObject;
typedef void(^ComplitionBlock)(BOOL handled);
typedef void(^ResultBlock)(BusinessObject *handler, BOOL handled);

@interface BusinessObject : NSObject
//下一个响应者, (响应链构成的关键)
@property (nonatomic, strong) BusinessObject *nextHandler;

//响应者的处理方法
- (void)handle:(ResultBlock)result;
//各个业务在该方法中做实际的业务
- (void)handleBusiness:(ComplitionBlock)complition;
@end
