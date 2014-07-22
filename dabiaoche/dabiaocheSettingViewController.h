//
//  dabiaocheSettingViewController.h
//  dabiaoche
//
//  Created by xin.li on 14-6-21.
//  Copyright (c) 2014年 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface dabiaocheSettingViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSDictionary *carModel;
    NSString *nickname;
}
- (IBAction)changeImage:(id)sender;
- (IBAction)saveUserSetting:(id)sender;
@property (strong, nonatomic)NSString* imagePath;
@property (strong, nonatomic)NSDictionary* hostUser;
@property (weak, nonatomic) IBOutlet UIButton *changeImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *nickNameTxt;
@property (weak, nonatomic) IBOutlet UIButton *emailTxt;

@property (weak, nonatomic) IBOutlet UILabel *city_lable;
@property (weak, nonatomic) IBOutlet UILabel *carModel_lable;
@property (weak, nonatomic) IBOutlet UIImageView *carModel_image;
@property (weak, nonatomic) IBOutlet UILabel *carModel_tem_lable;
@property (weak, nonatomic) IBOutlet UIButton *changeImage_btn;

@property (assign, nonatomic) NSInteger cityId;
@property (assign, nonatomic) NSInteger carModelId;
@property (strong, nonatomic) NSString *headUrl;

- (IBAction)editClick:(id)sender;
@end
