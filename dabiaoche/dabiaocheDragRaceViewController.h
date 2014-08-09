//
//  dabiaocheDragRaceViewController.h
//  dabiaoche
//
//  Created by li losser on 5/8/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "AccelerometerFilter.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>

@interface dabiaocheDragRaceViewController : UIViewController<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>{
    int v_max;
    Boolean isCancel;
    double baseRoll;
    double basePitch;
    double baseYaw;
}
//<UIAccelerometerDelegate>
@property (strong, nonatomic) IBOutlet UIView *alertView;
@property (strong, nonatomic) IBOutlet UILabel *errorLable;
@property (strong, nonatomic) IBOutlet UILabel *beginLable;

@property (strong, nonatomic)AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)beginAndStopBtnClick:(id)sender;
- (IBAction)sayTalking:(id)sender;
- (IBAction)cancelStart:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (weak, nonatomic) IBOutlet UIButton *beginAndStopBtn;
@property (weak, nonatomic) IBOutlet GraphView *unfiltered;
@property (weak, nonatomic) IBOutlet GraphView *unfiltered1;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *timerLable;
@property (weak, nonatomic) IBOutlet UILabel *speedLable;
@property (weak, nonatomic) IBOutlet UILabel *countLable;
@property (strong, nonatomic) IBOutlet UIImageView *ringStep2Image;
@property (strong, nonatomic) IBOutlet UIImageView *ringStep1Image;
@property (strong, nonatomic) IBOutlet UIView *viewStep2;
@property (strong, nonatomic) IBOutlet UIView *viewStep3;

@property (assign, nonatomic) int timerCount;
@property (assign, nonatomic) Boolean isRacing;
@property (assign, nonatomic) Boolean isRuning;
@property (assign, nonatomic) Boolean isRecorded;
@property (weak, nonatomic)NSTimer *beginTimer;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *gLable;
@property (weak, nonatomic) IBOutlet UILabel *raceTypeLable;
@property (strong, nonatomic) NSMutableDictionary *recordDic;
@property (strong, nonatomic) NSMutableArray *timeArr;
@property (strong, nonatomic) NSMutableArray *accArr;
@property (strong, nonatomic) NSMutableArray *speedArr;
@property (strong, nonatomic) NSMutableArray *recordArr;
@property (strong, nonatomic) NSMutableArray *dateArr;

@property (assign, nonatomic) double baseX;
@property (assign, nonatomic) double baseY;
@property (assign, nonatomic) double baseZ;
@property (assign, nonatomic) double baseT;
@property (assign, nonatomic) int baseCount;

@property (assign, nonatomic) int raceDistance;

@property (nonatomic, nonatomic)  int nn;
@property (nonatomic, nonatomic)  double ax0;
@property (nonatomic, nonatomic)  double aax;
@property (nonatomic, nonatomic)  double vx0;
@property (nonatomic, nonatomic)  double ay0;
@property (nonatomic, nonatomic)  double aay;
@property (nonatomic, nonatomic)  double vy0;
@property (nonatomic, nonatomic)  double az0;
@property (nonatomic, nonatomic)  double aaz;
@property (nonatomic, nonatomic)  double vz0;
@property (nonatomic, nonatomic)  double tt0;
@property (nonatomic, nonatomic)  double vv;
@property (nonatomic, nonatomic)  double t0;
@property (nonatomic, nonatomic)  Boolean flag45;
@property (nonatomic, nonatomic)  Boolean flag46;
@property (nonatomic, nonatomic)  Boolean flag47;
@property (nonatomic, nonatomic)  Boolean flag48;
@property (nonatomic, nonatomic)  Boolean flag49;
@property (nonatomic, nonatomic)  Boolean flag50;
@property (nonatomic, nonatomic)  Boolean flag100;
@end
