//
//  ZJline.h
//  ZJciji
//
//  Created by 张洁 on 2018/9/23.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZJline : NSObject<NSCoding>

@property (nonatomic, assign) CGPoint begin;
@property (nonatomic, assign) CGPoint end;
@property (nonatomic, strong) UIColor *lineColor;


@end
