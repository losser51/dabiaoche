//
//  dabiaocheRegisterViewController.m
//  dabiaoche
//
//  Created by li losser on 4/5/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheRegisterViewController.h"
#import "dabiaocheEditBoxViewController.h"
#import "NSString+MD5HexDigest.h"

@interface dabiaocheRegisterViewController (){
}

@end

@implementation dabiaocheRegisterViewController
@synthesize carModel_lable = _carModel_lable;
@synthesize city_lable = _city_lable;
@synthesize carModel_tem_lable = _carModel_tem_lable;
@synthesize carModel_image = _carModel_image;
@synthesize carModelId = _carModelId;
@synthesize cityId = _cityId;
@synthesize nickname_btn = _nickname_btn;
@synthesize password_btn = _password_btn;
@synthesize email_btn = _email_btn;
@synthesize changeImage_btn = _changeImage_btn;
@synthesize headUrl =_headUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        UIBarButtonItem *backButton=[[UIBarButtonItem alloc] init];
//        [backButton setTitle:@"返回"];
//        self.navigationItem.backBarButtonItem=backButton;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc] init];
    [backButton setTitle:@"返回"];
    self.navigationItem.backBarButtonItem=backButton;
    
    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseCarModel" object:nil];
    [center addObserver:self selector:@selector(chooseCarModel:) name:@"chooseCarModel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseCity" object:nil];
    [center addObserver:self selector:@selector(chooseCity:) name:@"chooseCity" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"register_editBox" object:nil];
    [center addObserver:self selector:@selector(getRegisterEditBox:) name:@"register_editBox" object:nil];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    _nickname_btn.titleLabel.text = _nickname;
//    [_nickname_btn reloadInputViews];
//}

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
    
    _carModel_lable.text = [one objectForKey:@"name"];
    NSString *imageUrl = [one objectForKey:@"imgurl2"];
    UIImage *image;
    if([imageUrl isEqualToString:@""]){
        image = [UIImage imageNamed:@"carModel.png"];
    }else{
        NSURL *url = [NSURL URLWithString:imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [[UIImage alloc] initWithData:data];
    }
    
    _carModel_image.image = image;
    _carModelId = [[one objectForKey:@"id"]integerValue];
    _headUrl = [imageUrl copy];
    _carModel_tem_lable.hidden = YES;
    _carModel_image.hidden = NO;
    _carModel_lable.hidden = NO;
    _changeImage_btn.hidden = NO;
    
}

- (void) chooseCity:(NSNotification *)notification{
    NSLog(@"Received notification: %@", [notification object]);
    NSError *error;
    NSDictionary *one = [NSJSONSerialization JSONObjectWithData:[notification object] options:NSJSONReadingAllowFragments error:&error];
    
    _city_lable.text = [one objectForKey:@"name"];
    _cityId = [[one objectForKey:@"id"]integerValue];
}

- (void) getRegisterEditBox:(NSNotification *)notification{
    NSLog(@"Received notification: %@", [notification object]);
    NSError *error;
    NSDictionary *one = [NSJSONSerialization JSONObjectWithData:[notification object] options:NSJSONReadingAllowFragments error:&error];
    
    NSInteger textTag = [[one objectForKey:@"editTag"]integerValue];
    UIButton* btn = (UIButton*)[self.view viewWithTag:textTag];
    [btn setTitle:[one objectForKey:@"text"] forState:UIControlStateNormal];
    
    NSString *pw = @"**************************************************";
    switch (textTag) {
        case 11:
            _nickname = [one objectForKey:@"text"];
            break;
        case 12:
            _password = [one objectForKey:@"text"];
            [btn setTitle:[pw substringToIndex:[[one objectForKey:@"text"]length]] forState:UIControlStateNormal];
            break;
        case 13:
            _email = [one objectForKey:@"text"];
            break;
        default:
            break;
    }
}

- (IBAction)editClick:(id)sender {
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    dabiaocheEditBoxViewController *editBoxView = [storyBoard instantiateViewControllerWithIdentifier:@"editBoxView"];
    
    editBoxView.navigationItem.rightBarButtonItem.title = @"保存";
    editBoxView.notification = @"register_editBox";
    UIButton *btn = (UIButton *)sender;
    editBoxView.editTag = btn.tag;
    switch (btn.tag) {
        case 11:
            editBoxView.navigationItem.title = @"昵称";
            break;
        case 12:
            editBoxView.navigationItem.title = @"密码";
            editBoxView.editModel = 2;
            break;
        case 13:
            editBoxView.navigationItem.title = @"邮箱";
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:editBoxView animated:YES];
}
- (IBAction)saveBtnClick:(id)sender {
    NSLog(@"_nickname:%@",_nickname);
    NSLog(@"_password:%@",_password);
    NSLog(@"_email:%@",_email);
    NSLog(@"_carModelId:%d",_carModelId);
    NSLog(@"_cityId:%d",_cityId);
    
    //post提交的参数，格式如下：
    //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
    
    NSString *post = [NSString stringWithFormat:@"u=%@&s=%@&e=%@&c=%d&cm=%d&hu=%@",_nickname,[_password md5HexDigest],_email,_cityId,_carModelId,_headUrl];
    
    NSLog(@"post:%@",post);
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSLog(@"postLength=%@",postLength);
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:@"http://192.168.1.103:8080/register"]];
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
    NSError *error = [[NSError alloc] init];
    //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //将NSData类型的返回值转换成NSString类型
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"user login check result:%@",result);
    
    if ([@"success" compare:result]==NSOrderedSame) {
        NSLog(@"YES");
    }
    NSLog(@"NO");
}
@end
