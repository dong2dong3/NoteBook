//
//  DrawView.h
//  ZJciji
//
//  Created by 张洁 on 2018/9/22.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJline.h"
@interface DrawView : UIView

@property (nonatomic, strong) NSMutableArray *finishdedLines;
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) UIButton *button;


@end
