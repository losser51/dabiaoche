//
//  dabiaocheEditBoxViewController.m
//  dabiaoche
//
//  Created by li losser on 4/28/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheEditBoxViewController.h"

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
    if (_editModel==2) {
        _editBox_text.secureTextEntry = YES;
    }
    [_editBox_text becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickRightButton:(id)sender {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    NSMutableDictionary* one = [[NSMutableDictionary alloc]init];
    NSString * tem = [[NSString alloc]initWithFormat:@"%d",_editTag];
    [one setObject:tem forKey:@"editTag"];
    [one setObject:_editBox_text.text forKey:@"text"];
    NSError *error;
    id result = [NSJSONSerialization dataWithJSONObject:one options:kNilOptions error:&error];
    [nc postNotificationName:_notification object:result];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]
                                          animated:YES];
}
@end
