//
//  dabiaocheSettingViewController.m
//  dabiaoche
//
//  Created by xin.li on 14-6-21.
//  Copyright (c) 2014年 li losser. All rights reserved.
//

#import "dabiaocheSettingViewController.h"
#import "dabiaocheEditBoxViewController.h"
#import "Const.h"

@implementation dabiaocheSettingViewController
@synthesize city_lable = _city_lable;
@synthesize carModel_lable = _carModel_lable;
@synthesize carModel_tem_lable = _carModel_tem_lable;
@synthesize carModel_image = _carModel_image;
@synthesize changeImage_btn = _changeImage_btn;
@synthesize headUrl = _headUrl;
@synthesize changeImageBtn,imagePath,hostUser,nickNameTxt,emailTxt;


- (IBAction)saveUserSetting:(id)sender {
    NSLog(@"asdasd");
    
    NSData *imageData = [[NSData alloc]init];
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(changeImageBtn.imageView.image)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(changeImageBtn.imageView.image);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(changeImageBtn.imageView.image, 1.0);
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
    //[dir setValue:@"save" forKey:@"m"];
    [parmeters setValue:[hostUser objectForKey:@"id"] forKey:@"uId"];
    [parmeters setValue:nickname forKey:@"u"];
    [parmeters setValue:[NSNumber numberWithInteger:_carModelId] forKey:@"cm"];
    [parmeters setValue:[NSNumber numberWithInteger:_cityId] forKey:@"c"];
    [manager POST:API_HOST_UPDATE_USER_INFO parameters:parmeters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        if (imageData) {
            [formData appendPartWithFileData:imageData name:@"userHeadFile" fileName:@"1.png" mimeType:@"image/png"];
        }
        
    }success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSLog(@"success");
        if([[JSON objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:0]]){
            NSDictionary * user = [JSON objectForKey:@"data"];
            if (!user) {
                //                NSLog(@"Error parsing JSON: %@", error);
            } else {
                NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                [standardUserDefaults setValue:user forKey:@"hostUser"];
                [standardUserDefaults synchronize];
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }
            //            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            //            [alert show];
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
    //得到图片的data
//    NSData* data;
//    if(picFilePath){
//        
//        UIImage *image=[UIImage imageWithContentsOfFile:picFilePath];
//        //判断图片是不是png格式的文件
//        if (UIImagePNGRepresentation(image)) {
//            //返回为png图像。
//            data = UIImagePNGRepresentation(image);
//        }else {
//            //返回为JPEG图像。
//            data = UIImageJPEGRepresentation(image, 1.0);
//        }
//    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    //保存图片的路径
    self.imagePath = [imageDocPath stringByAppendingPathComponent:@"image.png"];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    hostUser = [standardUserDefaults objectForKey:@"hostUser"];
    _cityId = [[hostUser objectForKey:@"local"] intValue];
    NSError *error;
    //加载一个NSURL对象
    NSString *url = [NSString stringWithFormat:API_HOST_CARMODEL_BY_USER,[hostUser objectForKey:@"id"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    //    NSDictionary *brandsDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    carModel = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    _carModelId = [[carModel objectForKey:@"id"]intValue];
    [nickNameTxt setTitle:[hostUser objectForKey:@"name"] forState:UIControlStateNormal];
    nickname = [hostUser objectForKey:@"name"];
    [emailTxt setTitle:[hostUser objectForKey:@"email"] forState:UIControlStateNormal];
    [_carModel_lable setText:[carModel objectForKey:@"name"]];
    
    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseCarModel" object:nil];
    [center addObserver:self selector:@selector(chooseCarModel:) name:@"chooseCarModel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseCity" object:nil];
    [center addObserver:self selector:@selector(chooseCity:) name:@"chooseCity" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"register_editBox" object:nil];
    [center addObserver:self selector:@selector(getRegisterEditBox:) name:@"register_editBox" object:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //根据图片路径载入图片
    UIImage *image=[UIImage imageWithContentsOfFile:self.imagePath];
    if (image == nil) {
        //显示默认
        [changeImageBtn setImage:[UIImage imageNamed:@"carModel@2x.png"] forState:UIControlStateNormal];
    }else {
        //显示保存过的
        [changeImageBtn setImage:image forState:UIControlStateNormal];
        [changeImageBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    }
}

- (IBAction)changeImage:(id)sender {
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: @"从相册选择", @"拍照",nil];
    [myActionSheet showInView:self.view];
//    [myActionSheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self LocalPhoto];
            break;
        case 1:
            //拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}
//从相册选择
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
//    [picker release];
}

//拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
//        [picker release];
    }else {
        NSLog(@"该设备无摄像头");
    }
}
#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //图片显示在界面上
        [changeImageBtn setImage:image forState:UIControlStateNormal];
        
        //以下是保存文件到沙盒路径下
        //把图片转成NSData类型的数据来保存文件
        NSData *data;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        //保存
        [[NSFileManager defaultManager] createFileAtPath:self.imagePath contents:data attributes:nil];
        
    }
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark Notification
- (void) chooseCarModel:(NSNotification *)notification{
    NSLog(@"Received notification: %@", [notification object]);
    NSError *error;
    NSDictionary *one = [NSJSONSerialization JSONObjectWithData:[notification object] options:NSJSONReadingAllowFragments error:&error];
    
    _carModel_lable.text = [one objectForKey:@"name"];
    
    NSString *imageUrl = [NSString stringWithFormat:IMAGE_URL_CARMODEL,[one objectForKey:@"id"]];
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    
    //    [changeImageBtn setBackgroundImage:image forState:UIControlStateNormal];
    [changeImageBtn setImage:image forState:UIControlStateNormal];
    [changeImageBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    _carModelId = [[one objectForKey:@"id"]integerValue];
    _headUrl = [imageUrl copy];
    _carModel_tem_lable.hidden = YES;
    _carModel_image.hidden = NO;
    _carModel_lable.hidden = NO;
    _changeImage_btn.hidden = NO;
    carModel = one;
    
    //保存
    [[NSFileManager defaultManager] createFileAtPath:self.imagePath contents:imageData attributes:nil];
    
}

- (void) chooseCity:(NSNotification *)notification{
    NSLog(@"Received notification: %@", [notification object]);
    NSError *error;
    NSDictionary *one = [NSJSONSerialization JSONObjectWithData:[notification object] options:NSJSONReadingAllowFragments error:&error];
    
    _city_lable.text = [one objectForKey:@"name"];
    _cityId = [[one objectForKey:@"id"]integerValue];
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
            editBoxView.editModel = EDIT_MODEL_NICKNAME;
            editBoxView.defaultValue = btn.titleLabel.text;
            break;
        case 12:
            editBoxView.navigationItem.title = @"密码";
            editBoxView.editModel = EDIT_MODEL_PASSWORD;
            break;
        case 13:
            editBoxView.navigationItem.title = @"邮箱";
            editBoxView.editModel = EDIT_MODEL_EMAIL;
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:editBoxView animated:YES];
}
- (void) getRegisterEditBox:(NSNotification *)notification{
    NSLog(@"Received notification: %@", [notification object]);
    NSError *error;
    NSDictionary *one = [NSJSONSerialization JSONObjectWithData:[notification object] options:NSJSONReadingAllowFragments error:&error];
    
    NSInteger textTag = [[one objectForKey:@"editTag"]integerValue];
    UIButton* btn = (UIButton*)[self.view viewWithTag:textTag];
    [btn setTitle:[one objectForKey:@"text"] forState:UIControlStateNormal];
    
//    NSString *pw = @"**************************************************";
    switch (textTag) {
        case 11:
            nickname = [one objectForKey:@"text"];
            break;
//        case 12:
//            _password = [one objectForKey:@"text"];
//            [btn setTitle:[pw substringToIndex:[[one objectForKey:@"text"]length]] forState:UIControlStateNormal];
//            break;
//        case 13:
//            _email = [one objectForKey:@"text"];
//            break;
        default:
            break;
    }
}

@end
