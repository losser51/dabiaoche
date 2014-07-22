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
@synthesize isGoBack;
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

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* hostUser = [standardUserDefaults objectForKey:@"hostUser"];
    if (hostUser != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)login:(id)sender {
    NSString *nickname = _nickname_lable.text;
    NSString *password = _password_lable.text;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
    [parmeters setValue:nickname forKey:@"u"];
    [parmeters setValue:[password md5HexDigest] forKey:@"s"];

    [manager POST:API_HOST_LOGIN
       parameters:parmeters
          success:^(NSURLSessionDataTask * __unused task, id JSON) {
              if([[JSON objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:0]]){
                  NSDictionary * user = [JSON objectForKey:@"data"];
                  if (!user) {
                  } else {
                      NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                      [standardUserDefaults setValue:user forKey:@"hostUser"];
                      [standardUserDefaults synchronize];
                      //获取Documents文件夹目录
                      NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                      NSString *documentPath = [path objectAtIndex:0];
                      //指定新建文件夹路径
                      NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
                      //创建ImageFile文件夹
                      [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
                      //保存图片的路径
                      NSString *imagePath = [imageDocPath stringByAppendingPathComponent:@"image.png"];
                      NSURL *url = [NSURL URLWithString:[user objectForKey:@"headUrl"]];
                      NSData *data = [NSData dataWithContentsOfURL:url];
                      [[NSFileManager defaultManager] createFileAtPath:imagePath contents:data attributes:nil];
                      if (isGoBack) {
                          [self.navigationController popViewControllerAnimated:TRUE];
                      }else{
                          [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                      }
                      
                  }
//                  UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"登陆成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                  [alert show];
              }
              else{
                  UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[JSON objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                  [alert show];
              }
          }
          failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络状况不稳定，请稍后再试。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
              [alert show];
          }];
}

- (IBAction)nickClick:(id)sender {
    [_nickname_lable becomeFirstResponder];
}

- (IBAction)passwordClick:(id)sender {
    [_password_lable becomeFirstResponder];
}
@end
