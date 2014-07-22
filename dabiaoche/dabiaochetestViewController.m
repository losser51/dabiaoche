//
//  dabiaochetestViewController.m
//  dabiaoche
//
//  Created by xin.li on 14-7-9.
//  Copyright (c) 2014年 li losser. All rights reserved.
//

#import "dabiaochetestViewController.h"

@interface dabiaochetestViewController ()

@end

@implementation dabiaochetestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 600, 600)];
//    [iv setImage:[UIImage imageNamed:@"tc_wheel.png"]];
    //CALayer *rotate_layer = iv.layer;
//    [self.view addSubview:iv];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.delegate = self;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(20 , 0, 0, 1)];
    animation.duration = 0.15;
//    animation.
//    animation.autoreverses = YES;
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
//    animation set
//    animation.repeatDuration = YES;
    timerCount = 6;
    [_ringStep1Image.layer addAnimation:animation forKey:@"animation"];
    [_ringStep2Image.layer addAnimation:animation forKey:@"animation"];
    [self initTimer];
}

-(void)initTimer
{
    //时间间隔
    NSTimeInterval timeInterval =1.0 ;
    //定时器
    beginTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                  target:self
                                                selector:@selector(handleStartTimer:)
                                                userInfo:nil
                                                 repeats:YES];
//    timerView.hidden = false;
    //    timerLable.hidden = false;
    [beginTimer fire];
}

- (void)handleStartTimer:(NSTimer *)theTimer
{
    NSLog(@"will be start in %d second",timerCount);
    _timeLable.text = [NSString stringWithFormat:@"%d",timerCount-3];
    if (timerCount==3) {
        _viewStep2.hidden = NO;
    }
    if (timerCount==1) {
        _viewStep3.hidden = NO;
    }
    if (timerCount==0) {
        [beginTimer invalidate];
//        timerView.hidden = true;
//        baseX = baseX/baseCount;
//        baseY = baseY/baseCount;
//        baseZ = baseZ/baseCount;
//        isRacing = YES;
        timerCount = 6;
//        [player play];
    }
    timerCount--;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
