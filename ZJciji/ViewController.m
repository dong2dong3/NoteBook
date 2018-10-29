//
//  ViewController.m
//  ZJciji
//
//  Created by 张洁 on 2018/9/22.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import "ViewController.h"
#import "ZJViewController.h"
#import "DrawViewController.h"
#import "NSTimer+ZJTimer.h"
#import "BaseObjectA.h"
#import "BaseObjectB.h"
#import "ObjectA1.h"
#import "ObjectB1.h"
const int cellHeight = 10;
@interface ViewController ()
@property (nonatomic, strong)NSTimer* myTimer;
@end

@implementation ViewController
{
    NSString *_someString;
    dispatch_queue_t _concurrentQueue;
    dispatch_queue_t _serialQueue;
    dispatch_queue_t globalQueue;
}


- (void)fetchData
{
    BaseObjectA *a1 = [[ObjectA1 alloc]init];
    BaseObjectB *b1= [[ObjectB1 alloc]init];
    a1.objB = b1;
    [a1 handle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setValue:@"zhangjie" forKey:@"name"];
    NSLog(@"%@",self.name);
    [self setValue:@"zhangjie" forKey:@"age"];
    NSLog(@"%@",[self valueForKey:@"name"]);
    _concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
    _serialQueue = dispatch_queue_create("serialQueue", NULL);
    _uiLabel = [[UILabel alloc]initWithFrame: CGRectZero];
    [self.view addSubview:_uiLabel];

    _uiLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_uiLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraint11 = [NSLayoutConstraint constraintWithItem:_uiLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint21 = [NSLayoutConstraint constraintWithItem:_uiLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-300];
    NSLayoutConstraint *constraint31 = [NSLayoutConstraint constraintWithItem:_uiLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:30];
    NSLayoutConstraint *constraint41 = [NSLayoutConstraint constraintWithItem:_uiLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:30];
//    constraint41.priority = 500;
    [_uiLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.view addConstraints:@[constraint11,constraint21,constraint31,constraint41]];
//                CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    _uiLabel.text = @"大吉大利，今晚吃鸡！";
    _uiLabel.textAlignment = NSTextAlignmentCenter;
    _uiLabel.backgroundColor = [UIColor redColor];
    _uiLabel.layer.cornerRadius = _uiLabel.bounds.size.height/2;
    _uiLabel.layer.masksToBounds = YES;
    _flag = YES;
    _button = [[UIButton alloc]initWithFrame: CGRectMake(100, 200, [UIScreen mainScreen].bounds.size.width - 200, 50)];
    _button.backgroundColor = [UIColor brownColor];
    _button.layer.cornerRadius = _button.bounds.size.height/2;
    [_button setTitle:@"点我！" forState:UIControlStateNormal];
    _button.layer.masksToBounds = YES;
    [_button addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_button];
    

    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
//    [[UIImageView alloc]initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 300)];
    imgView.image = [UIImage imageNamed:@"mengji.jpeg"];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgView];
    [imgView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:100];
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:300];
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:300];

    [self.view addConstraints:@[constraint1,constraint2,constraint3,constraint4]];
//    [self setuptimer];
//    [self testThread];
    // Do any additional setup after loading the view, typically from a nib.
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(testThread) object:nil];
//    [thread start];
//    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(testThread) object:nil];
//    [thread1 start];
    [self testSync];
}

- (void)setuptimer
{
    __weak ViewController *weakSelf = self;
    _myTimer = [NSTimer zj_scheduledTimerWithTimeInterval:1.0 repeats:YES block:^{
        ViewController *strongSelf = weakSelf;
        [strongSelf changeText];
    }];
}

- (void)changeText
{
    _flag = !_flag;
    NSString *str = @"wu";
    NSString *str1 = @"zhang";
    
//    CGFloat a = _flag? 100: -100;
    _uiLabel.text = _flag? str : str1;
//    [UIView animateWithDuration:5.0 animations:^{
//        CGRect frame = self->_uiLabel.frame;
//        frame.origin.x += a;
//        self->_uiLabel.frame = frame;
//    }];

    

    
}
- (void)testSync
{
    dispatch_async(_serialQueue, ^{
        dispatch_async(self->_serialQueue, ^{
            sleep(4);
            NSLog(@"1");
            
        });
        sleep(1);
        NSLog(@"2");
        dispatch_async(self->_serialQueue, ^{
            
            NSLog(@"3");
            
        });
    });
    
//    sleep(1);
    NSLog(@"4");
}

- (void)testThread
{
    NSLog(@"---start%@-----",[NSThread currentThread]);

    dispatch_sync(_concurrentQueue, ^{
        NSLog(@"---1---%@",[NSThread currentThread]);
    });
    dispatch_sync(_concurrentQueue, ^{
        NSLog(@"---2---%@",[NSThread currentThread]);
    });
    dispatch_sync(_concurrentQueue, ^{
        NSLog(@"---3---%@",[NSThread currentThread]);
    });
    
    dispatch_barrier_sync(_concurrentQueue, ^{
        NSLog(@"dispatch_barrier_async------%@",[NSThread currentThread]);

    });
    dispatch_sync(_concurrentQueue, ^{
        NSLog(@"---4---%@",[NSThread currentThread]);
    });
    dispatch_sync(_concurrentQueue, ^{
        NSLog(@"---5---%@",[NSThread currentThread]);
    });
    dispatch_sync(_concurrentQueue, ^{
        NSLog(@"---6---%@",[NSThread currentThread]);
    });
    NSLog(@"---end%@-----",[NSThread currentThread]);

}

- (NSString *)someString {
    __block NSString *localSomeString;
    dispatch_sync(_concurrentQueue, ^{
        localSomeString = self->_someString;
    });
    return localSomeString;
}

- (void)setsomeString:(NSString *)someString {
    dispatch_barrier_async(_concurrentQueue, ^{
        self->_someString = someString;
    });
}

-(void)nextPage
{
    DrawViewController *zj = [[DrawViewController alloc]init];
    [self.navigationController pushViewController:zj animated:YES];
//    [self presentViewController:nav animated:YES completion:nil];
}

//- (void)viewDidLayoutSubviews
//{
//    [UIView animateWithDuration:5.0 animations:^{
//        CGRect frame = self->_uiLabel.frame;
//        frame.origin.x += 100;
//        self->_uiLabel.frame = frame;
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
