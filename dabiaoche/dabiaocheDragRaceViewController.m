//
//  dabiaocheDragRaceViewController.m
//  dabiaoche
//
//  Created by li losser on 5/8/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheDragRaceViewController.h"
#import "dabiaocheRaceResultViewController.h"
#import <CoreMotion/CoreMotion.h>
#define kUpdateFrequency	60.0
#define beginAcc            0.15
#define TIMERCOUNT          7
#define GPS_NO_MOVE_SPEED   0.2

@interface dabiaocheDragRaceViewController ()
{
//    AccelerometerFilter *filter;
    CMMotionManager *motionManager;
}
@property (nonatomic, retain) CMMotionManager *motionManager;
@end

@implementation dabiaocheDragRaceViewController
@synthesize baseCount,baseX,baseY,baseZ,baseT;
@synthesize timerCount,beginTimer,recordDic;
@synthesize accArr,timeArr,speedArr,recordArr,dateArr;
@synthesize unfiltered,unfiltered1;
@synthesize timeLable,beginAndStopBtn,timerLable,timerView,speedLable,countLable,gLable,raceTypeLable,tableView,alertView,errorLable,beginLable;
@synthesize isRacing,isRuning,isRecorded,raceDistance;
@synthesize ax0,vx0,ay0,vy0,az0,vz0,t0,tt0,vv;
@synthesize aax,aay,aaz,nn,flag45,flag46,flag47,flag48,flag49,flag50,flag100;
@synthesize locationManager,player;
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

    motionManager = [[CMMotionManager alloc] init];
    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reRace" object:nil];
    [center addObserver:self selector:@selector(reRace:) name:@"reRace" object:nil];
	
	[unfiltered setIsAccessibilityElement:YES];
	[unfiltered setAccessibilityLabel:NSLocalizedString(@"unfilteredGraph", @"")];
    [unfiltered1 setIsAccessibilityElement:YES];
	[unfiltered1 setAccessibilityLabel:NSLocalizedString(@"unfilteredGraph", @"")];
    
    raceTypeLable.text = [NSString stringWithFormat:@"0-%dkm/h加速时间",raceDistance];
    
    recordDic = [[NSMutableDictionary alloc]init];
    recordArr = [[NSMutableArray alloc]init];
    timeArr = [[NSMutableArray alloc]init];
    accArr = [[NSMutableArray alloc]init];
    speedArr = [[NSMutableArray alloc]init];
    dateArr = [[NSMutableArray alloc]init];

    isRacing = NO;
    isRuning = NO;
    isRecorded = NO;
    
    baseX = 0.0;
    baseY = 0.0;
    baseZ = 0.0;
    basePitch = 0.0;
    baseRoll = 0.0;
    baseYaw = 0.0;
    baseCount = 0;
    
    ax0=0;
    vx0=0;
    aax=0;
    
    ay0=0;
    vy0=0;
    aay=0;
    
    az0=0;
    vz0=0;
    aaz=0;
    nn=0;
    t0=0;
    
    vv=0;
    v_max = 0;
    
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"race" ofType:@"wav"];
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
    player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [player prepareToPlay];
    
    if ([motionManager isAccelerometerAvailable]){
//        NSLog(@"Accelerometer is available.");
        motionManager.accelerometerUpdateInterval = 0.02; // 告诉manager，更新频率是100Hz
        
//        [motionManager startDeviceMotionUpdates];
//        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//        
//        [motionManager startAccelerometerUpdatesToQueue: queue
//                                            withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
//                                                
//                                                [self performSelectorOnMainThread:@selector(setWave:) withObject:accelerometerData waitUntilDone:NO];
//                                            }];
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.delegate = self;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(20 , 0, 0, 1)];
    animation.duration = 0.25;
    //    animation.
    //    animation.autoreverses = YES;
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    //    animation set
    //    animation.repeatDuration = YES;
    
    [_ringStep1Image.layer addAnimation:animation forKey:@"animation"];
    [_ringStep2Image.layer addAnimation:animation forKey:@"animation"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [motionManager stopAccelerometerUpdates];
    [locationManager stopUpdatingLocation];
    [beginTimer invalidate];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [motionManager startDeviceMotionUpdates];
    [locationManager startUpdatingLocation];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];

    [motionManager startDeviceMotionUpdatesToQueue:queue1 withHandler:
        ^(CMDeviceMotion *motion, NSError *error){
        [self performSelectorOnMainThread:@selector(setWave1:) withObject:motion waitUntilDone:NO];
        }];
//    [motionManager startAccelerometerUpdatesToQueue: queue
//                                        withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
//
//                                            [self performSelectorOnMainThread:@selector(setWave:) withObject:accelerometerData waitUntilDone:NO];
//                                        }];
    timerCount = TIMERCOUNT;

    [speedLable setText:@"0"];
    [timeLable setText:@"0"];
    [alertView setHidden:YES];
    
    isRecorded = NO;
    isRuning = NO;
    isRacing = NO;
    isCancel = NO;
    //    vv = 0;
    vx0 = 0;
    vy0 = 0;
    vz0 = 0;
    baseX = 0.0;
    baseY = 0.0;
    baseZ = 0.0;
    basePitch   = 0.0;
    baseRoll    = 0.0;
    baseYaw     = 0.0;
    baseCount = 0;
    
    ax0=0;
    vx0=0;
    aax=0;
    
    ay0=0;
    vy0=0;
    aay=0;
    
    az0=0;
    vz0=0;
    aaz=0;
    nn=0;
    t0=0;
    
    vv=0;
    v_max = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setWave1:(CMDeviceMotion *)motion
{
//    [motion gravity];
//    CMDeviceMotion
//    CMAcceleration *acc = [motion userAcceleration];
//    NSLog(@"x:%f",[motion userAcceleration].x);
//    NSLog(@"y:%f",[motion attitude].pitch);
//    NSLog(@"z:%f",[motion userAcceleration].z);
    ;
    
    CMAcceleration acc = motion.userAcceleration;
    CMAttitude *attitude = motion.attitude;
    
    if (beginAndStopBtn.selected) {
        if (isRacing) {
            ax0 = acc.x - baseX;
            ay0 = acc.y - baseY;
            az0 = acc.z - baseZ;
            if (!isRuning) {
                if (fabs(ax0)<beginAcc&&fabs(ay0)<beginAcc&&fabs(az0)<beginAcc) {
                    return;
                }
                else{
                    isRuning = YES;
                    [alertView setHidden:YES];
                    t0 = [[NSDate date] timeIntervalSince1970];
                    baseT = t0;
                }
            }else{
                if (fabs(ax0)<0.01) {
                    ax0 = 0;
                }
                if (fabs(ay0)<0.01) {
                    ay0 = 0;
                }
                if (fabs(az0)<0.01) {
                    az0 = 0;
                }
                double t1 = [[NSDate date] timeIntervalSince1970];
                double t = t1 - t0;
                t0 = t1;
                vx0 += ax0 * t * 9.8 * 3.6;
                vy0 += ay0 * t * 9.8 * 3.6;
                vz0 += az0 * t * 9.8 * 3.6;
                
                vv=sqrt(vx0*vx0+vy0*vy0+vz0*vz0);
                double aa = sqrt(ax0*ax0+ay0*ay0+az0*az0);
                if (isCancel) {
                    gLable.text = @"0";
                    speedLable.text = @"0";
                    timeLable.text = @"0";
                    
                }else{
                    gLable.text = [NSString stringWithFormat:@"%0.3f",aa];
                    speedLable.text = [NSString stringWithFormat:@"%0.3f",vv];
                    timeLable.text = [NSString stringWithFormat:@"%0.3f",t1 - baseT];
                }
                
                [accArr     addObject:[NSNumber numberWithDouble:aa]];
                [speedArr   addObject:[NSNumber numberWithDouble:vv]];
                [timeArr    addObject:[NSNumber numberWithDouble:t1 - baseT]];
                if(vv>raceDistance&&!isRecorded){
                    isRecorded = YES;
                    isCancel = YES;
                    [beginLable setText:@"成功"];
                    [beginLable setHidden:NO];
                    [errorLable setHidden:YES];
                    [alertView setHidden:NO];
                    //                    NSDate *d = [NSDate date];
                    //                    [dateArr addObject:[[NSDate date]copy]];
                    
                    [recordDic setObject:[NSDate date] forKey:@"date"];
                    [recordDic setObject:[accArr copy] forKey:@"accArr"];
                    [recordDic setObject:[speedArr copy] forKey:@"speedArr"];
                    [recordDic setObject:[timeArr copy] forKey:@"timeArr"];
                    double time1 = [[timeArr objectAtIndex:[timeArr count]-1]doubleValue];
                    if (time1>=4&&time1<5) {
                        time1 = time1 * 1.02;
                    }else if (time1>=5&&time1<6){
                        time1 = time1 * 1.03;
                    }else if (time1>=6&&time1<7){
                        time1 = time1 * 1.0424;
                    }else if (time1>=7&&time1<8){
                        time1 = time1 * 1.05;
                    }else if (time1>=8&&time1<9){
                        time1 = time1 * 1.0575;
                    }else if (time1>=9&&time1<10){
                        time1 = time1 * 1.06;
                    }else if (time1>=10&&time1<11){
                        time1 = time1 * 1.08;
                    }else if (time1>=11&&time1<12){
                        time1 = time1 * 1.09;
                    }else if (time1>=12&&time1<13){
                        time1 = time1 * 1.10;
                    }else if (time1>=13&&time1<14){
                        time1 = time1 * 1.11;
                    }else if (time1>=14){
                        time1 = time1 * 1.18;
                    }
                    [recordDic setObject:[NSNumber numberWithDouble:time1] forKey:@"spend"];
                    
                    [recordArr addObject:[recordDic copy]];
                    //                    NSLog(@"%@",[timeArr objectAtIndex:0]);
                    [accArr removeAllObjects];
                    [speedArr removeAllObjects];
                    [timeArr removeAllObjects];
                    [recordDic removeAllObjects];
                    [dateArr removeAllObjects];
                    
                    countLable.text = [NSString stringWithFormat:@"%lu",(unsigned long)[recordArr count]];
                    [tableView reloadData];
                }else{
                    if (vv>v_max) {
                        v_max = vv;
                    }else if (vv<(v_max-1)&&!isRecorded){
                        isRecorded = YES;
                        isCancel = YES;
                        [beginLable setHidden:YES];
                        [errorLable setText:@"失败：此次测试中有减速"];
                        [errorLable setHidden:NO];
                        
                        [alertView setHidden:NO];
                        
                    }
                    NSLog(@"%f",attitude.yaw);
                    if (fabs(attitude.yaw-baseYaw)>0.3||fabs(attitude.roll-baseRoll)>0.3||fabs(attitude.pitch-basePitch)>0.3) {
                        isRecorded = YES;
                        isCancel = YES;
                        [beginLable setHidden:YES];
                        [errorLable setText:@"失败：此次测试中有倾斜"];
                        [errorLable setHidden:NO];
                        
                        [alertView setHidden:NO];
                    }
                }
            }
            
        }else{
            baseX += acc.x;
            baseY += acc.y;
            baseZ += acc.z;
            baseYaw += attitude.yaw;
            basePitch += attitude.pitch;
            baseRoll += attitude.roll;
            baseCount++;
        }
    }
    
}

- (void)setWave:(CMAccelerometerData *)accData
{
    CMAcceleration acc = accData.acceleration;
    
    if (beginAndStopBtn.selected) {
        if (isRacing) {
            ax0 = acc.x - baseX;
            ay0 = acc.y - baseY;
            az0 = acc.z - baseZ;
            if (!isRuning) {
                if (fabs(ax0)<beginAcc&&fabs(ay0)<beginAcc&&fabs(az0)<beginAcc) {
                    return;
                }
                else{
                    isRuning = YES;
                    [alertView setHidden:YES];
                    t0 = [[NSDate date] timeIntervalSince1970];
                    baseT = t0;
                }
            }else{
                if (fabs(ax0)<0.01) {
                    ax0 = 0;
                }
                if (fabs(ay0)<0.01) {
                    ay0 = 0;
                }
                if (fabs(az0)<0.01) {
                    az0 = 0;
                }
                double t1 = [[NSDate date] timeIntervalSince1970];
                double t = t1 - t0;
                t0 = t1;
                vx0 += ax0 * t * 9.8 * 3.6;
                vy0 += ay0 * t * 9.8 * 3.6;
                vz0 += az0 * t * 9.8 * 3.6;
                
                vv=sqrt(vx0*vx0+vy0*vy0+vz0*vz0);
                double aa = sqrt(ax0*ax0+ay0*ay0+az0*az0);
                if (isCancel) {
                    gLable.text = @"0";
                    speedLable.text = @"0";
                    timeLable.text = @"0";
                    
                }else{
                    gLable.text = [NSString stringWithFormat:@"%0.3f",aa];
                    speedLable.text = [NSString stringWithFormat:@"%0.3f",vv];
                    timeLable.text = [NSString stringWithFormat:@"%0.3f",t1 - baseT];
                }
                
                [accArr     addObject:[NSNumber numberWithDouble:aa]];
                [speedArr   addObject:[NSNumber numberWithDouble:vv]];
                [timeArr    addObject:[NSNumber numberWithDouble:t1 - baseT]];
                if(vv>raceDistance&&!isRecorded){
                    isRecorded = YES;
                    isCancel = YES;
                    [beginLable setText:@"成功"];
                    [beginLable setHidden:NO];
                    [errorLable setHidden:YES];
                    [alertView setHidden:NO];
//                    NSDate *d = [NSDate date];
//                    [dateArr addObject:[[NSDate date]copy]];
                    
                    [recordDic setObject:[NSDate date] forKey:@"date"];
                    [recordDic setObject:[accArr copy] forKey:@"accArr"];
                    [recordDic setObject:[speedArr copy] forKey:@"speedArr"];
                    [recordDic setObject:[timeArr copy] forKey:@"timeArr"];
                    double time1 = [[timeArr objectAtIndex:[timeArr count]-1]doubleValue];
                    if (time1>=4&&time1<5) {
                        time1 = time1 * 1.02;
                    }else if (time1>=5&&time1<6){
                        time1 = time1 * 1.03;
                    }else if (time1>=6&&time1<7){
                        time1 = time1 * 1.0424;
                    }else if (time1>=7&&time1<8){
                        time1 = time1 * 1.05;
                    }else if (time1>=8&&time1<9){
                        time1 = time1 * 1.0575;
                    }else if (time1>=9&&time1<10){
                        time1 = time1 * 1.06;
                    }else if (time1>=10&&time1<11){
                        time1 = time1 * 1.08;
                    }else if (time1>=11&&time1<12){
                        time1 = time1 * 1.09;
                    }else if (time1>=12&&time1<13){
                        time1 = time1 * 1.10;
                    }else if (time1>=13&&time1<14){
                        time1 = time1 * 1.11;
                    }else if (time1>=14){
                        time1 = time1 * 1.18;
                    }
                    [recordDic setObject:[NSNumber numberWithDouble:time1] forKey:@"spend"];
                    
                    [recordArr addObject:[recordDic copy]];
//                    NSLog(@"%@",[timeArr objectAtIndex:0]);
                    [accArr removeAllObjects];
                    [speedArr removeAllObjects];
                    [timeArr removeAllObjects];
                    [recordDic removeAllObjects];
                    [dateArr removeAllObjects];
                    
                    countLable.text = [NSString stringWithFormat:@"%lu",(unsigned long)[recordArr count]];
                    [tableView reloadData];
                }else{
                    if (vv>v_max) {
                        v_max = vv;
                    }else if (vv<(v_max-1)&&!isRecorded){
                        isRecorded = YES;
                        isCancel = YES;
                        [beginLable setHidden:YES];
                        [errorLable setText:@"失败：此次测试中有减速"];
                        [errorLable setHidden:NO];
                        
                        [alertView setHidden:NO];
                        
                    }
                }
            }
            
        }else{
            baseX += acc.x;
            baseY += acc.y;
            baseZ += acc.z;
            baseCount++;
        }
    }
//    timeLable.text = [NSString stringWithFormat:@"%@",y];
    [unfiltered1 addX:acc.x y:sqrt(ax0*ax0+ay0*ay0+az0*az0)-1 z:acc.z];
//    timeLable.text = @"adsasd";

}

//- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
//{
//    [filter addAcceleration:acceleration];
//    [unfiltered addX:acceleration.x y:acceleration.y z:acceleration.z];
//    NSLog(@"222   X = %.04f, Y = %.04f, Z = %.04f",acceleration.x, acceleration.y, acceleration.z);
////    [filtered addX:filter.x y:filter.y z:filter.z];
//}

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
    timerView.hidden = false;
//    timerLable.hidden = false;
    [beginTimer fire];
}

//- (void)handleStartTimer:(NSTimer *)theTimer
//{
//    NSLog(@"will be start in %d second",timerCount);
//    timerLable.text = [NSString stringWithFormat:@"%d",timerCount];
//    if (timerCount==0) {
//        [beginTimer invalidate];
//        timerView.hidden = true;
////        timerLable.hidden = NO;
//        baseX = baseX/baseCount;
//        baseY = baseY/baseCount;
//        baseZ = baseZ/baseCount;
//        isRacing = YES;
//        timerCount = 3;
//        [player play];
//    }
//    timerCount--;
//}
- (void)handleStartTimer:(NSTimer *)theTimer
{
//    NSLog(@"will be start in %d second",timerCount);
    timerLable.text = [NSString stringWithFormat:@"%d",timerCount-3];
    if (timerCount==3) {
        _viewStep2.hidden = NO;
    }
    if (timerCount==1) {
        _viewStep3.hidden = NO;
    }
    if (timerCount==0) {
        [beginTimer invalidate];
        timerView.hidden = YES;
        _viewStep2.hidden = YES;
        _viewStep3.hidden = YES;
        baseX = baseX/baseCount;
        baseY = baseY/baseCount;
        baseZ = baseZ/baseCount;
        baseRoll = baseRoll/baseCount;
        basePitch = basePitch/baseCount;
        baseYaw = baseYaw/baseCount;
        isRacing = YES;
//        timerCount = 6;
        [player play];
    }
    timerCount--;
}

- (IBAction)beginAndStopBtnClick:(id)sender {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (![CLLocationManager locationServicesEnabled]||kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请开启定位功能" message:@"大飙车需要开启定位功能辅助测试校验，请在 设置－隐私－定位服务 开启" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alter show];
        return;
    }
    beginAndStopBtn.selected = !beginAndStopBtn.selected;
    if (beginAndStopBtn.selected) {
        [self initTimer];
    }
    else
    {
        if ([recordArr count]>0) {
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            dabiaocheRaceResultViewController *raceResultView = [storyBoard instantiateViewControllerWithIdentifier:@"raceResultView"];
            raceResultView.recordArr = [[NSMutableArray alloc]initWithArray:recordArr];
            raceResultView.raceDistance = self.raceDistance;
            [self.navigationController pushViewController:raceResultView animated:YES];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"newLocation:%f",newLocation.speed);
//    NSLog(@"oldLocation:%f",oldLocation.speed);
    if (isRuning) {
//        NSLog(@"isRunning speed ===== %f",newLocation.speed);
        
        if (isRuning) {
//            NSLog(@"speed ===== %f",newLocation.speed);
            if (newLocation.speed<GPS_NO_MOVE_SPEED&&oldLocation.speed<GPS_NO_MOVE_SPEED) {
                //            NSLog(@"speed ===== %f",newLocation.speed);
                //            [motionManager stopAccelerometerUpdates];
                
                //            isRecorded = NO;
                [self initRace];
            }
        }else{
//            if (newLocation.speed<GPS_NO_MOVE_SPEED&&oldLocation.speed<GPS_NO_MOVE_SPEED) {
//                isRuning = NO;
//                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你需要跑起来才行" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
////                UIAlertView
//                [self reRace:nil];
////                isRuning = YES;
//                [self initRace];
//                NSLog(@"Running NG");
//            }
        }
    }
    
    //获取所在地城市名
//    [self locationAddressWithLocation:newLocation];
//    [locationManager stopUpdatingLocation];
    
}

- (void)initRace
{
    isRecorded = NO;
    isRuning = NO;
//    isRacing = NO;
//    vv = 0;
    vx0 = 0;
    vy0 = 0;
    vz0 = 0;
    [accArr removeAllObjects];
    [speedArr removeAllObjects];
    [timeArr removeAllObjects];
    [recordDic removeAllObjects];
    speedLable.text = @"0";
//    [alertView setHidden:YES];
    [beginLable setText:@"开始"];
    [beginLable setHidden:NO];
    [errorLable setHidden:YES];
    
    [alertView setHidden:NO];
    isCancel = NO;
    v_max = 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [recordArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"recordCell"];
    NSInteger row = [indexPath row];
//    NSInteger section = [indexPath section];
    
    UILabel *indexLable = (UILabel*)[cell viewWithTag:101];
    indexLable.text = [NSString stringWithFormat:@"%ld",(long)row+1];
    UILabel *timeLable1 = (UILabel*)[cell viewWithTag:102];
    
    NSDictionary * one = [recordArr objectAtIndex:row];
//    NSArray *timeArr1 = [one objectForKey:@"timeArr"];
    
//    double time1 = [[timeArr1 objectAtIndex:[timeArr1 count]-1]doubleValue];
    timeLable1.text = [NSString stringWithFormat:@"%0.3f",[[one objectForKey:@"spend"]doubleValue]];
    return cell;
}

-(IBAction)sayTalking:(id)sender
{
//    NSLog(@"播放声音");
    [player play];
    
}

- (IBAction)cancelStart:(id)sender {
    [beginTimer invalidate];
    timerView.hidden = YES;
    _viewStep2.hidden = YES;
    _viewStep3.hidden = YES;
    timerCount = TIMERCOUNT;
    [beginAndStopBtn setSelected:NO];
}

- (void)reRace:(NSNotification *)notification{
    
    recordDic = [[NSMutableDictionary alloc]init];
    recordArr = [[NSMutableArray alloc]init];
    timeArr = [[NSMutableArray alloc]init];
    accArr = [[NSMutableArray alloc]init];
    speedArr = [[NSMutableArray alloc]init];
    dateArr = [[NSMutableArray alloc]init];
    [countLable setText:@"0"];
//    timerCount = 6;
    isRacing = NO;
    isRuning = NO;
    isRecorded = NO;
    
    baseX = 0.0;
    baseY = 0.0;
    baseZ = 0.0;
    baseYaw = 0.0;
    basePitch = 0.0;
    baseRoll = 0.0;
    baseCount = 0;
    
    ax0=0;
    vx0=0;
    aax=0;
    
    ay0=0;
    vy0=0;
    aay=0;
    
    az0=0;
    vz0=0;
    aaz=0;
    nn=0;
    t0=0;
    
    vv=0;

    [self.tableView reloadData];
//    [motionManager startDeviceMotionUpdates];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    
//    [motionManager startAccelerometerUpdatesToQueue: queue
//                                        withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
//                                            
//                                            [self performSelectorOnMainThread:@selector(setWave:) withObject:accelerometerData waitUntilDone:NO];
//                                        }];

}
@end
