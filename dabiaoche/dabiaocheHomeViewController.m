//
//  dabiaocheHomeViewController.m
//  dabiaoche
//
//  Created by li losser on 4/5/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheHomeViewController.h"
#import "dabiaocheDragRaceViewController.h"
@interface dabiaocheHomeViewController ()

@end

@implementation dabiaocheHomeViewController
@synthesize myButtomView,loginButtomView;
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
//    NSError *error;
//    //加载一个NSURL对象
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.weather.com.cn/data/101180601.html"]];
//    //将请求的url数据放到NSData对象中
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    NSDictionary *weatherInfo = [weatherDic objectForKey:@"weatherinfo"];
////    txtView.text = [NSString stringWithFormat:@"今天是 %@  %@  %@  的天气状况是：%@  %@ ",[weatherInfo objectForKey:@"date_y"],[weatherInfo objectForKey:@"week"],[weatherInfo objectForKey:@"city"], [weatherInfo objectForKey:@"weather1"], [weatherInfo objectForKey:@"temp1"]];
//    NSLog(@"weatherInfo字典里面的内容为--》%@", weatherDic );
}

- (void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* hostUser = [standardUserDefaults objectForKey:@"hostUser"];
    if (hostUser != nil) {
        loginButtomView.hidden = YES;
        myButtomView.hidden = NO;
    }
    else
    {
        loginButtomView.hidden = NO;
        myButtomView.hidden = YES;
        NSLog(@"hostUser id: %d",[[hostUser objectForKey:@"id"]integerValue]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickToRace:(id)sender {
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    dabiaocheDragRaceViewController *dragRaceView = [storyBoard instantiateViewControllerWithIdentifier:@"dragRaceView"];
    dragRaceView.raceDistance = [sender tag];
    [self.navigationController pushViewController:dragRaceView animated:YES];
}
@end
