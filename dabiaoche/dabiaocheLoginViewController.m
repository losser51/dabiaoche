//
//  dabiaocheLoginViewController.m
//  dabiaoche
//
//  Created by li losser on 5/4/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheLoginViewController.h"
#import "NSString+MD5HexDigest.h"
#import "Const.h"

@interface dabiaocheLoginViewController ()

@end

@implementation dabiaocheLoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    NSString *nickname = _nickname_lable.text;
    NSString *password = _password_lable.text;
    NSString *post = [NSString stringWithFormat:@"u=%@&s=%@",nickname,[password md5HexDigest]];
    
    NSLog(@"post:%@",post);
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSLog(@"postLength=%@",postLength);
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:API_HOST_LOGIN]];
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

    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    
    if ([result objectForKey:@"rtn"]) {
        NSLog(@"YES");
        NSDictionary * user = [result objectForKey:@"user"];
        if (!user) {
            NSLog(@"Error parsing JSON: %@", error);
        } else {
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//            if([standardUserDefaults objectForKey:@"hostUser"] == nil)
//            {
                [standardUserDefaults setValue:user forKey:@"hostUser"];
                [standardUserDefaults synchronize];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0]
                                                      animated:YES];
//            }
        }
    }else{
        NSLog(@"NO");
    }
}

- (IBAction)nickClick:(id)sender {
    [_nickname_lable becomeFirstResponder];
}

- (IBAction)passwordClick:(id)sender {
    [_password_lable becomeFirstResponder];
}
@end
