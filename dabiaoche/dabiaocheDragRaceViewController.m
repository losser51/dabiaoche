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
#define beginAcc            0.1

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
@synthesize timeLable,beginAndStopBtn,timerLable,timerView,speedLable,countLable,gLable,raceTypeLable,tableView;
@synthesize isRacing,isRuning,isRecorded,raceDistance;
@synthesize ax0,vx0,ay0,vy0,az0,vz0,t0,tt0,vv;
@synthesize aax,aay,aaz,nn,flag45,flag46,flag47,flag48,flag49,flag50,flag100;
@synthesize locationManager;
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
//    [self changeFilter:[LowpassFilter class]];
    motionManager = [[CMMotionManager alloc] init];
//	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / kUpdateFrequency];
//	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	
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
    timerCount = 3;
    isRacing = NO;
    isRuning = NO;
    isRecorded = NO;
    
    baseX = 0.0;
    baseY = 0.0;
    baseZ = 0.0;
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

    if ([motionManager isAccelerometerAvailable]){
        NSLog(@"Accelerometer is available.");
        motionManager.accelerometerUpdateInterval = 0.02; // 告诉manager，更新频率是100Hz
        
        [motionManager startDeviceMotionUpdates];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [motionManager startAccelerometerUpdatesToQueue: queue
                                                 withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                     
//                                                     NSLog(@"111   X = %.04f, Y = %.04f, Z = %.04f",accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
//                                                     timeLable.text = [NSString stringWithFormat:@"%.04f",accelerometerData.acceleration.y];
//                                                     NSNumber *y = [NSNumber numberWithDouble:accelerometerData.acceleration.y];
//                                                     CMAccelerometerData *accData = accelerometerData;
                                                     [self performSelectorOnMainThread:@selector(setWave:) withObject:accelerometerData waitUntilDone:NO];
//                                                     [unfiltered1 addX:accelerometerData.acceleration.x y:accelerometerData.acceleration.y z:accelerometerData.acceleration.z];
                                                 }];
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [motionManager stopAccelerometerUpdates];
    [beginTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                gLable.text = [NSString stringWithFormat:@"%0.3f",aa];
                speedLable.text = [NSString stringWithFormat:@"%0.3f",vv];
                [accArr     addObject:[NSNumber numberWithDouble:aa]];
                [speedArr   addObject:[NSNumber numberWithDouble:vv]];
                [timeArr    addObject:[NSNumber numberWithDouble:t1 - baseT]];
                if(vv>raceDistance&&!isRecorded){
                    isRecorded = YES;
//                    NSDate *d = [NSDate date];
//                    [dateArr addObject:[[NSDate date]copy]];
                    
                    [recordDic setObject:[NSDate date] forKey:@"date"];
                    [recordDic setObject:[accArr copy] forKey:@"accArr"];
                    [recordDic setObject:[speedArr copy] forKey:@"speedArr"];
                    [recordDic setObject:[timeArr copy] forKey:@"timeArr"];
                    
                    [recordArr addObject:[recordDic copy]];
                    NSLog(@"%@",[timeArr objectAtIndex:0]);
                    [accArr removeAllObjects];
                    [speedArr removeAllObjects];
                    [timeArr removeAllObjects];
                    [recordDic removeAllObjects];
                    [dateArr removeAllObjects];
                    
                    countLable.text = [NSString stringWithFormat:@"%lu",(unsigned long)[recordArr count]];
                    [tableView reloadData];
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
    [unfiltered1 addX:acc.x y:acc.y z:acc.z];
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

- (void)handleStartTimer:(NSTimer *)theTimer
{
    NSLog(@"will be start in %d second",timerCount);
    timerLable.text = [NSString stringWithFormat:@"%d",timerCount];
    if (timerCount==0) {
        [beginTimer invalidate];
        timerView.hidden = true;
//        timerLable.hidden = NO;
        baseX = baseX/baseCount;
        baseY = baseY/baseCount;
        baseZ = baseZ/baseCount;
        isRacing = YES;
        timerCount = 3;
    }
    timerCount--;
}


- (IBAction)beginAndStopBtnClick:(id)sender {
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
    if (isRuning&isRecorded) {
        if (newLocation.speed<0.01&&oldLocation.speed<0.01) {
            NSLog(@"speed =====0");
//            [motionManager stopAccelerometerUpdates];
            
//            isRecorded = NO;
            [self initRace];
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
    NSArray *timeArr1 = [one objectForKey:@"timeArr"];
    
    double time1 = [[timeArr1 objectAtIndex:[timeArr1 count]-1]doubleValue];
    timeLable1.text = [NSString stringWithFormat:@"%0.3f",time1];
    return cell;
}

@end
