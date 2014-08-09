//
//  dabiaocheHomeViewController.m
//  dabiaoche
//
//  Created by li losser on 4/5/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheHomeViewController.h"
#import "dabiaocheDragRaceViewController.h"
#import "Const.h"
#import "dabiaocheHomeRankingCell.h"
#import "dabiaocheMyRecordViewController.h"
#import "UIDevice+Resolutions.h"

@interface dabiaocheHomeViewController ()

@end

@implementation dabiaocheHomeViewController
@synthesize myButtomView,loginButtomView,rankingDic,rankingArr,typeSegmented,tableView,myImage,webVIew,webViewtoggleBtn;
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
    NSError *error;
    //加载一个NSURL对象
    //将请求的url数据放到NSData对象中
    NSString *url = [NSString stringWithFormat:API_HOST_HTMLADDRESS_BY_KEY,HTMLADDRESS_HOME];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary* htmlAddressDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
//    NSLog(@"-------------3");
    if ((NSNull *)htmlAddressDic != [NSNull null]) {
        url = [htmlAddressDic objectForKey:@"url"];
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [webVIew loadRequest:request];
    }
    else{
        webVIew.hidden = YES;
        webViewtoggleBtn.hidden = YES;
    }
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber* isGuideOver = [standardUserDefaults objectForKey:@"isGuideOver"];
    if (![isGuideOver isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        [self buildIntro];
    }
    
//    NSLog(@"-------------1");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"-------------4");
    
    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"guideOver" object:nil];
    [center addObserver:self selector:@selector(guideOver:) name:@"guideOver" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
//    [self buildIntro];
//      self.navigationController.view.hidden = YES;
    
}

-(void)buildIntro{
    MYIntroductionView *introductionView;
//    if ([UIDevice isRunningOniPhone5]) {
        //STEP 1 Construct Panels
        MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"启动画面01@2x.jpg"] description:@""];
        
        //You may also add in a title for each panel
        MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"启动画面02@2x.jpg"] description:@""];
        
        MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"启动画面03@2x.jpg"] description:@""];
        introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2,panel3]];
//        NSLog(@"%f",self.view.frame.size.height);
//    }
//    else{
//        //STEP 1 Construct Panels
//        MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"启动画面01_640@2x.jpg"] description:@""];
//        
//        //You may also add in a title for each panel
//        MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"启动画面02_640@2x.jpg"] description:@""];
//        
//        MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"启动画面03_640@2x.jpg"] description:@""];
//        introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2,panel3]];
//        NSLog(@"%f",self.view.frame.size.height);
//    }
    
    //STEP 2 Create IntroductionView
    
    /*A standard version*/
    //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"SampleHeaderImage.png"] panels:@[panel, panel2]];
    
    
    /*A version with no header (ala "Path")*/
    
    
    /*A more customized version*/
//    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) headerText:@"" panels:@[panel, panel2,panel3] languageDirection:MYLanguageDirectionLeftToRight];
    [introductionView setBackgroundImage:[UIImage imageNamed:@"SampleBackground"]];
    
    
    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [introductionView showInView:self.view];
    [self.navigationController setNavigationBarHidden:YES];


}


- (void) viewWillAppear:(BOOL)animated
{
    NSString *url = API_HOST_GET_HOME_RANKING;
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSLog(@"-------------2");
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    rankingDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    if (!rankingDic) {
//        NSLog(@"Error parsing JSON: %@", error);
    } else {
//        rankingArr = [[rankingDic objectForKey:@"50"] copy];
        NSInteger index = typeSegmented.selectedSegmentIndex;
        if (index==0) {
            rankingArr = [rankingDic objectForKey:@"50"];
        }else{
            rankingArr = [rankingDic objectForKey:@"100"];
        }
    }
    
    [tableView reloadData];
    
    
    
//    NSLog(@"-------------5");
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* hostUser = [standardUserDefaults objectForKey:@"hostUser"];
//    NSLog(@"-------------5-----1");
    if (hostUser != nil) {
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
        [parmeters setValue:[hostUser objectForKey:@"id"] forKey:@"userId"];
        [parmeters setValue:[NSNumber numberWithInt:100] forKey:@"type"];
        
        [manager GET:API_HOST_GET_USER_TOP_RECORD
           parameters:parmeters
              success:^(NSURLSessionDataTask * __unused task, id JSON) {
                  if([[JSON objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:0]]){
                      NSDictionary * record = [JSON objectForKey:@"data"];
                      if (!record) {
                      } else {
                          [myBestSpendLable setText:[NSString stringWithFormat:@"%.3f秒",[[record objectForKey:@"spend"]floatValue]]];
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
//                  NSLog(@"%@",error);
              }];
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        //指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
        //创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        //保存图片的路径
        NSString *imagePath = [imageDocPath stringByAppendingPathComponent:@"image.png"];
        UIImage *image=[UIImage imageWithContentsOfFile:imagePath];
        
//        NSString *imageUrl = [hostUser objectForKey:@"headUrl"];
//        myButtomView.
//        NSURL *url = [NSURL URLWithString:imageUrl];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        myImage.image = [[UIImage alloc] initWithData:data];
        myImage.image = image;
        
        loginButtomView.hidden = YES;
        myButtomView.hidden = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else
    {
        loginButtomView.hidden = NO;
        myButtomView.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
//        NSLog(@"hostUser id: %ld",(long)[[hostUser objectForKey:@"id"]integerValue]);
    }
    [isWaiting setHidden:YES];
//    NSLog(@"-------------6");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickToRace:(id)sender {
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    dabiaocheDragRaceViewController *dragRaceView = [storyBoard instantiateViewControllerWithIdentifier:@"dragRaceView"];
    dragRaceView.raceDistance = [sender tag];
    [self.navigationController pushViewController:dragRaceView animated:YES];
}

- (IBAction)rankingTypeChange:(id)sender {
    NSInteger index = typeSegmented.selectedSegmentIndex;
    if (index==0) {
        rankingArr = [rankingDic objectForKey:@"50"];
    }else{
        rankingArr = [rankingDic objectForKey:@"100"];
    }
    [tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rankingArr count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 32)];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    return sectionView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"--------------7");
    dabiaocheHomeRankingCell *cell = (dabiaocheHomeRankingCell *)[tableView dequeueReusableCellWithIdentifier:@"homeRankingCell"];
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    NSDictionary* one = [rankingArr objectAtIndex:row];
    cell.rankingCarModelName.text = [one objectForKey:@"carModelName"];
    cell.rankingCity.text = [one objectForKey:@"cityName"];
    cell.rankingUserName.text = [one objectForKey:@"userName"];
    NSNumber* spend = [one objectForKey:@"spend"];
    cell.rankingSpend.text = [NSString stringWithFormat:@"%0.3f秒",[spend floatValue]];
    NSString* imageName = [NSString stringWithFormat:@"home-ranking-%d@2x",row+1];
    cell.rankingImage.image = [UIImage imageNamed:imageName];
    cell.rankingImage.hidden = NO;
//    if (row==0) {
//        cell.rankingImage.image = [UIImage imageNamed:@"home-jin-input@2x.png"];
//        cell.rankingImage.hidden = NO;
//    }else if(row==1){
//        cell.rankingImage.image = [UIImage imageNamed:@"home-yin-input@2x.png"];
//        cell.rankingImage.hidden = NO;
//    }else if(row==2){
//        cell.rankingImage.image = [UIImage imageNamed:@"home-tong-input@2x.png"];
//        cell.rankingImage.hidden = NO;
//    }else{
//        cell.rankingImage.hidden = YES;
//    }
    

    NSString *imageUrl = [NSString stringWithFormat:IMAGE_URL_CARMODEL,[one objectForKey:@"carModel"]];

    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.rankingCarModelImage.image = [[UIImage alloc] initWithData:data];

//    NSLog(@"--------------8");
    return cell;
}
- (IBAction)closeWebView:(id)sender {
    webViewtoggleBtn.hidden = YES;
    webVIew.hidden = YES;
}

- (IBAction)clickMyRecords:(id)sender
{
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    dabiaocheMyRecordViewController *myReocrdView = [storyBoard instantiateViewControllerWithIdentifier:@"myReocrdView"];
    [self.navigationController pushViewController:myReocrdView animated:YES];
}

- (void) guideOver:(NSNotification *)notification
{
    [self.navigationController setNavigationBarHidden:NO];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setValue:[NSNumber numberWithBool:YES] forKey:@"isGuideOver"];
    [standardUserDefaults synchronize];
}

- (IBAction)toMyRecord:(id)sender {
    [isWaiting setHidden:NO];
    [self performSegueWithIdentifier:@"toMyRecord" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    
//    UIViewController *newView = segue.destinationViewController;
//    newView.model = self.model;
    
}
@end
