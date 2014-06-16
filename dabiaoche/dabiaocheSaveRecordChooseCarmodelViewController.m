//
//  dabiaocheSaveRecordChooseCarmodelViewController.m
//  dabiaoche
//
//  Created by li losser on 5/25/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheSaveRecordChooseCarmodelViewController.h"
#import "NSObject+JSONCategories.h"
#import "Const.h"

@interface dabiaocheSaveRecordChooseCarmodelViewController ()

@end

@implementation dabiaocheSaveRecordChooseCarmodelViewController
@synthesize otherChooseFlagImage,otherChooseCarmodelImage,otherChooseCarmodelLable,otherChooseLable;
@synthesize userDefaultCarModelFlagImage,userDefaultCarModelImage,userDefaultCarModelLable;
@synthesize recordArr,hostUser,carModel,raceDistance;
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
    hostUser = [standardUserDefaults objectForKey:@"hostUser"];
    
    NSError *error;
    //加载一个NSURL对象
    NSString *url = [NSString stringWithFormat:API_HOST_CARMODEL_BY_USER,[hostUser objectForKey:@"id"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    //    NSDictionary *brandsDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    carModel = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
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
    NSLog(@"%@",recordArr);

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
    
    carModel = [one copy];
}
- (IBAction)saveRecords:(id)sender {
    //post提交的参数，格式如下：
    //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
    
    NSError *error = [[NSError alloc] init];
//    recordArr.
//    NSData *mDataOrder = [NSKeyedArchiver archivedDataWithRootObject:recordArr];
//    NSData* jsonData =[NSJSONSerialization dataWithJSONObject:[recordArr copy]
//                                                      options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:recordArr options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData
//                                                 encoding:NSUTF8StringEncoding];

    
    NSString *post = [NSString stringWithFormat:@"records=%@&userId=%@&userName=%@&carModelId=%@&carModelName=%@&cityId=%@&type=%d",recordArr,[hostUser objectForKey:@"id"],[hostUser objectForKey:@"name"],[carModel objectForKey:@"id"],[carModel objectForKey:@"name"],[hostUser objectForKey:@"local"],raceDistance];
    
    NSLog(@"post:%@",post);
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSLog(@"postLength=%@",postLength);
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:API_HOST_SAVE_RECORDS]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    //设置http-header:Content-Type
    //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错。不知道什么原因。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    
    //定义
    NSHTTPURLResponse* urlResponse = nil;
    
    //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //将NSData类型的返回值转换成NSString类型
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"user login check result:%@",result);

}
- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}
@end
