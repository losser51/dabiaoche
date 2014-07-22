//
//  dabiaocheLoginViewController.h
//  dabiaoche
//
//  Created by li losser on 5/4/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dabiaocheLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nickname_lable;
@property (weak, nonatomic) IBOutlet UITextField *password_lable;
@property (assign, nonatomic) BOOL isGoBack;
- (IBAction)login:(id)sender;
- (IBAction)nickClick:(id)sender;
- (IBAction)passwordClick:(id)sender;

@end
