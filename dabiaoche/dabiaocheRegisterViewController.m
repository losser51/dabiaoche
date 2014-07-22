//
//  dabiaocheRegisterViewController.m
//  dabiaoche
//
//  Created by li losser on 4/5/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheRegisterViewController.h"
#import "dabiaocheEditBoxViewController.h"
#import "RequestPostUploadHelper.h"
#import "NSString+MD5HexDigest.h"
#import "Const.h"

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
@synthesize changeImageBtn,imagePath;

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
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    //保存图片的路径
    self.imagePath = [imageDocPath stringByAppendingPathComponent:@"image.png"];

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
            editBoxView.editModel = EDIT_MODEL_NICKNAME;
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
- (IBAction)saveBtnClick:(id)sender {
    NSLog(@"_nickname:%@",_nickname);
    NSLog(@"_password:%@",_password);
    NSLog(@"_email:%@",_email);
    NSLog(@"_carModelId:%d",_carModelId);
    NSLog(@"_cityId:%d",_cityId);
    
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
    [parmeters setValue:_nickname forKey:@"u"];
    [parmeters setValue:[_password md5HexDigest] forKey:@"s"];
    [parmeters setValue:_email forKey:@"e"];
    [parmeters setValue:[NSNumber numberWithInteger:_carModelId] forKey:@"cm"];
    [parmeters setValue:[NSNumber numberWithInteger:_cityId] forKey:@"c"];
    [parmeters setValue:_headUrl forKey:@"hu"];
    [manager POST:API_HOST_REGISTER parameters:parmeters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFileData:imageData name:@"userHeadFile" fileName:@"1.png" mimeType:@"image/png"];
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
                [self.navigationController popViewControllerAnimated:YES];
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
//    picker.toolbar.
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
//        [changeImageBtn setBackgroundImage:image forState:UIControlStateNormal];
        [changeImageBtn setImage:image forState:UIControlStateNormal];
        [changeImageBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
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

@end
