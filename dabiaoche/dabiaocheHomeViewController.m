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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *url = [NSString stringWithFormat:@"%@getHomeRanking",API_HOST];
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    rankingDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    if (!rankingDic) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        rankingArr = [[rankingDic objectForKey:@"50"] copy];
    }
    
    url = [NSString stringWithFormat:API_HOST_HTMLADDRESS_BY_KEY,HTMLADDRESS_HOME];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary* htmlAddressDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    if (htmlAddressDic!=Nil) {
        url = [htmlAddressDic objectForKey:@"url"];
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [webVIew loadRequest:request];
    }
    else{
        webVIew.hidden = YES;
        webViewtoggleBtn.hidden = YES;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* hostUser = [standardUserDefaults objectForKey:@"hostUser"];
    if (hostUser != nil) {
        NSString *imageUrl = [hostUser objectForKey:@"headUrl"];
//        myButtomView.
        NSURL *url = [NSURL URLWithString:imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        myImage.image = [[UIImage alloc] initWithData:data];
        
        loginButtomView.hidden = YES;
        myButtomView.hidden = NO;
    }
    else
    {
        loginButtomView.hidden = NO;
        myButtomView.hidden = YES;
        NSLog(@"hostUser id: %d",[[hostUser objectForKey:@"id"]integerValue]);
    }
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
    
    dabiaocheHomeRankingCell *cell = (dabiaocheHomeRankingCell *)[tableView dequeueReusableCellWithIdentifier:@"homeRankingCell"];
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    NSDictionary* one = [rankingArr objectAtIndex:row];
    cell.rankingCarModelName.text = [one objectForKey:@"carModelName"];
    cell.rankingCity.text = [one objectForKey:@"cityName"];
    cell.rankingUserName.text = [one objectForKey:@"userName"];
    NSNumber* spend = [one objectForKey:@"spend"];
    cell.rankingSpend.text = [NSString stringWithFormat:@"%0.3f秒",[spend floatValue]];
    if (row==0) {
        cell.rankingImage.image = [UIImage imageNamed:@"home-jin-input@2x.png"];
        cell.rankingImage.hidden = NO;
    }else if(row==1){
        cell.rankingImage.image = [UIImage imageNamed:@"home-yin-input@2x.png"];
        cell.rankingImage.hidden = NO;
    }else if(row==2){
        cell.rankingImage.image = [UIImage imageNamed:@"home-tong-input@2x.png"];
        cell.rankingImage.hidden = NO;
    }else{
        cell.rankingImage.hidden = YES;
    }
    

    NSString *imageUrl = [NSString stringWithFormat:IMAGE_URL_CARMODEL,[one objectForKey:@"carModel"]];

    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.rankingCarModelImage.image = [[UIImage alloc] initWithData:data];

    return cell;
}
- (IBAction)closeWebView:(id)sender {
    webViewtoggleBtn.hidden = YES;
    webVIew.hidden = YES;
}
@end
