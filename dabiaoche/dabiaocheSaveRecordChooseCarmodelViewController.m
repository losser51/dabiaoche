//
//  dabiaocheSaveRecordChooseCarmodelViewController.m
//  dabiaoche
//
//  Created by li losser on 5/25/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheSaveRecordChooseCarmodelViewController.h"

@interface dabiaocheSaveRecordChooseCarmodelViewController ()

@end

@implementation dabiaocheSaveRecordChooseCarmodelViewController
@synthesize otherChooseFlagImage,otherChooseCarmodelImage,otherChooseCarmodelLable,otherChooseLable;
@synthesize userDefaultCarModelFlagImage,userDefaultCarModelImage,userDefaultCarModelLable;
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
    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseCarModel" object:nil];
    [center addObserver:self selector:@selector(chooseCarModel:) name:@"chooseCarModel" object:nil];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* hostUser = [standardUserDefaults objectForKey:@"hostUser"];
    
    [hostUser objectForKey:@"id"];
    
    NSError *error;
    //加载一个NSURL对象
    NSString *url = [NSString stringWithFormat:@"http://192.168.1.103:8080/getCarModelByUserId?userId=%@",[hostUser objectForKey:@"id"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    //    NSDictionary *brandsDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *carModel = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if (!carModel) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        
        NSString *imageUrl = [carModel objectForKey:@"imgurl2"];
        NSURL *url = [NSURL URLWithString:imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage* image = [[UIImage alloc] initWithData:data];
        
        userDefaultCarModelLable.text = [carModel objectForKey:@"name"];
        userDefaultCarModelImage.image = image;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Notification
- (void) chooseCarModel:(NSNotification *)notification{
    NSLog(@"Received notification: %@", [notification object]);
    NSError *error;
    NSDictionary *one = [NSJSONSerialization JSONObjectWithData:[notification object] options:NSJSONReadingAllowFragments error:&error];
    
    NSString *imageUrl = [one objectForKey:@"imgurl2"];
    UIImage *image;
    if([imageUrl isEqualToString:@""]){
        image = [UIImage imageNamed:@"carModel.png"];
    }else{
        NSURL *url = [NSURL URLWithString:imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [[UIImage alloc] initWithData:data];
    }
    otherChooseCarmodelImage.image = image;
    otherChooseCarmodelLable.text = [one objectForKey:@"name"];
    
    otherChooseLable.hidden = YES;
    otherChooseFlagImage.hidden = NO;
    userDefaultCarModelFlagImage.hidden = YES;
    otherChooseCarmodelLable.hidden = NO;
    otherChooseCarmodelImage.hidden = NO;  
}
@end
