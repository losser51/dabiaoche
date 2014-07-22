//
//  dabiaocheRegisterViewController.h
//  dabiaoche
//
//  Created by li losser on 4/5/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import <UIKit/UIKit.h> 

@interface dabiaocheRegisterViewController : UIViewController
- (IBAction)editClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nickname_btn;
@property (weak, nonatomic) IBOutlet UIButton *password_btn;
@property (weak, nonatomic) IBOutlet UIButton *email_btn;
@property (weak, nonatomic) IBOutlet UILabel *carModel_lable;
@property (weak, nonatomic) IBOutlet UIImageView *carModel_image;
@property (weak, nonatomic) IBOutlet UILabel *carModel_tem_lable;
@property (weak, nonatomic) IBOutlet UILabel *city_lable;
@property (weak, nonatomic) IBOutlet UIButton *changeImage_btn;
- (IBAction)saveBtnClick:(id)sender;
- (IBAction)changeImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changeImageBtn;
@property (assign, nonatomic) NSInteger carModelId;
@property (assign, nonatomic) NSInteger cityId;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *headUrl;
@property (strong, nonatomic) NSString* imagePath;
@end
