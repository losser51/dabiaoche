//
//  dabiaocheEditBoxViewController.h
//  dabiaoche
//
//  Created by li losser on 4/28/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dabiaocheEditBoxViewController : UIViewController
- (IBAction)clickRightButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *editBox_text;
@property (strong, nonatomic) NSString *notification;
@property (assign, nonatomic) NSInteger editTag;
@property (assign, nonatomic) NSInteger editModel;
@end
