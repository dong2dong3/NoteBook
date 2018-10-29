//
//  DrawView.m
//  ZJciji
//
//  Created by 张洁 on 2018/9/22.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.finishdedLines = [[NSMutableArray alloc]init];
        self.linesInProgress = [[NSMutableDictionary alloc]init];
        self.backgroundColor = [UIColor grayColor];
    }
    self.multipleTouchEnabled = YES;
    
    self.finishdedLines = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFilePath]]? : [[NSMutableArray alloc]init];
    _button = [[UIButton alloc]initWithFrame: CGRectMake(100, 600, [UIScreen mainScreen].bounds.size.width - 200, 50)];
//    NSLog(@"%@",_button.frame);
    _button.backgroundColor = [UIColor brownColor];
    _button.layer.cornerRadius = _button.bounds.size.height/2;
    [_button setTitle:@"清空！" forState:UIControlStateNormal];
    _button.titleLabel.textAlignment = NSTextAlignmentCenter;
    _button.layer.masksToBounds = YES;
    [_button addTarget:self action:@selector(clearPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    return self;
}

- (void)clearPage
{
    [self.finishdedLines removeAllObjects];
    [self setNeedsDisplay];
    [[NSFileManager defaultManager] removeItemAtPath:[self getFilePath] error:nil];
}


- (void)drawRect:(CGRect)rect
{
    //用黑色绘制已经完成的线条
    for (ZJline *line in self.finishdedLines) {
        [line.lineColor set];
        [self strokeLine:line];
    }
    
    for (NSValue *key in _linesInProgress) {
        ZJline *line = _linesInProgress[key];
        [line.lineColor set];
        [self strokeLine: line];
    }
    
    
}

- (void)strokeLine:(ZJline *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

-(NSString *)getFilePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingPathComponent:@"User"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        ZJline *line = [[ZJline alloc] init];
        line.begin = location;
        line.end = location;
        int R = (arc4random() % 256) ;
        int G = (arc4random() % 256) ;
        int B = (arc4random() % 256) ;
        line.lineColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        _linesInProgress[key] = line;
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        ZJline *line = _linesInProgress[key];
        CGPoint location = [t locationInView:self];
        line.end = location;
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        ZJline *line = _linesInProgress[key];
        CGPoint location = [t locationInView:self];
        line.end = location;
        [self.finishdedLines addObject:line];
        [_linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
    
    [NSKeyedArchiver archiveRootObject:self.finishdedLines toFile:[self getFilePath]];
}


- (void)layoutSubviews
{
    NSLog(@"%@",_button.frame);
}

@end
