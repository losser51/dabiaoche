//
//  dabiaocheEditBoxViewController.m
//  dabiaoche
//
//  Created by li losser on 4/28/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheEditBoxViewController.h"
#import "Const.h"

@interface dabiaocheEditBoxViewController ()

@end

@implementation dabiaocheEditBoxViewController
@synthesize editBox_text = _editBox_text;
@synthesize notification = _notification;
@synthesize editTag = _editTag;
@synthesize editModel = _editModel;
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
    if (_editModel==EDIT_MODEL_PASSWORD) {
        _editBox_text.secureTextEntry = YES;
    }
    [_editBox_text setText:_defaultValue];
    [_editBox_text becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickRightButton:(id)sender {
    if (_editModel==EDIT_MODEL_EMAIL) {
        if (![self validateEmail:_editBox_text.text]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"输入格式错误" message:@"请输入正确的邮件格式" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
            return;
        }
    }else if (_editModel==EDIT_MODEL_NICKNAME){
        if (![self validateNickname:_editBox_text.text]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"输入格式错误" message:@"请输入正确的昵称格式" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
            return;
        }
    }
    else if (_editModel==EDIT_MODEL_PASSWORD){
        if (![self validatePassword:_editBox_text.text]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"输入格式错误" message:@"请输入正确的密码格式" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
            return;
        }
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    NSMutableDictionary* one = [[NSMutableDictionary alloc]init];
    NSString * tem = [[NSString alloc]initWithFormat:@"%d",_editTag];
    [one setObject:tem forKey:@"editTag"];
    [one setObject:_editBox_text.text forKey:@"text"];
    NSError *error;
    id result = [NSJSONSerialization dataWithJSONObject:one options:kNilOptions error:&error];
    [nc postNotificationName:_notification object:result];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL) validateNickname: (NSString *) candidate
{
    if (candidate.length>44) {
        return NO;
    }
    return YES;
}

- (BOOL) validatePassword: (NSString *) candidate
{
    if (candidate.length<4||candidate.length>39) {
        return NO;
    }
    return YES;
}
@end
