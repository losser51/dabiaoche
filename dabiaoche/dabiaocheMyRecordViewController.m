//
//  dabiaocheMyRecordViewController.m
//  dabiaoche
//
//  Created by xin.li on 14-6-2.
//  Copyright (c) 2014年 li losser. All rights reserved.
//

#import "dabiaocheMyRecordViewController.h"
#import "Const.h"
#import "dabiaocheCarModelRecordTableViewCell.h"
#import "dabiaocheCarModelSingleRecordTableViewCell.h"

@interface dabiaocheMyRecordViewController ()

@end

@implementation dabiaocheMyRecordViewController
@synthesize myRecordsArray,myRecordsDic,tableView,levelImageArray;
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
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* hostUser = [standardUserDefaults objectForKey:@"hostUser"];
    NSString *url = [NSString stringWithFormat:@"%@getPersonRecords?userId=%@",API_HOST,[hostUser objectForKey:@"id"]];
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    myRecordsDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    if (!myRecordsDic) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        
    }
    UIImage* image1 = [UIImage imageNamed:@"myResult-1-input@2x.png"];
    UIImage* image2 = [UIImage imageNamed:@"myResult-2-input@2x.png"];
    UIImage* image3 = [UIImage imageNamed:@"myResult-3-input@2x.png"];
    UIImage* image4 = [UIImage imageNamed:@"myResult-4-input@2x.png"];
    UIImage* image5 = [UIImage imageNamed:@"myResult-5-input@2x.png"];
    levelImageArray = [[NSArray alloc] initWithObjects:image1,image2,image3,image4,image5, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [[myRecordsDic objectForKey:@"main"] count];
    }else if (section){
        return [[myRecordsDic objectForKey:@"other"] count];
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* title;
    if (section==0) {
        title = @"默认车型";
    }else{
        title = @"其他车型";
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    NSArray *dataArr;
    if (section==0) {
        dataArr = [myRecordsDic objectForKey:@"main"];
    }else{
        dataArr = [myRecordsDic objectForKey:@"other"];
    }
//    UITableViewCell *cell;
    NSDictionary* dic = [dataArr objectAtIndex:row];

    if ([[dic objectForKey:@"carModel"] isKindOfClass:[NSDictionary class]]) {
        NSNumber* spend = [dic objectForKey:@"spend"];
        
        dabiaocheCarModelRecordTableViewCell* cell = (dabiaocheCarModelRecordTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"carModelRecordCell"];
        cell.carModelLable.text = [[dic objectForKey:@"carModel"] objectForKey:@"name"];
        NSString *imageUrl = [[dic objectForKey:@"carModel"] objectForKey:@"imgurl2"];
        NSURL *url = [NSURL URLWithString:imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage* image = [[UIImage alloc] initWithData:data];
        cell.carModelImage.image = image;

        NSNumber* type =[dic objectForKey:@"type"];
        if (type.intValue==100) {
            cell.carModelRecordLable.text = [NSString stringWithFormat:@"0-%@km/h最好成绩：%0.3f秒",[dic objectForKey:@"type"],spend.floatValue];
            NSNumber * rankingPercent = [dic objectForKey:@"rankingPercent"];
            cell.carModelRateLable.text = [NSString stringWithFormat:@"击败%i%%对手 排名%@",rankingPercent.intValue,[dic objectForKey:@"ranking"]];

            if (spend.doubleValue<4) {
                cell.carModelLevelImage.image = levelImageArray[0];
            }else if (spend.doubleValue<7){
                cell.carModelLevelImage.image = levelImageArray[1];
            }else if (spend.doubleValue<9){
                cell.carModelLevelImage.image = levelImageArray[2];
            }else if (spend.doubleValue<15){
                cell.carModelLevelImage.image = levelImageArray[3];
            }else{
                cell.carModelLevelImage.image = levelImageArray[4];
            }
            
            cell.carModelRateLable.hidden = NO;
            cell.carModelRecordLable.hidden = NO;
            cell.carModelLevelImage.hidden = NO;
        }else{
            cell.carModelRateLable.hidden = YES;
            cell.carModelRecordLable.hidden = YES;
            cell.carModelLevelImage.hidden = YES;
        }
        
        return cell;

    }else{
        NSDictionary* dateDic = [dic objectForKey:@"createTime"];
        NSNumber* spend = [dic objectForKey:@"spend"];
        
        dabiaocheCarModelSingleRecordTableViewCell* cell = (dabiaocheCarModelSingleRecordTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"carModelSingleRecordCell"];
        cell.timeLable.text = [NSString stringWithFormat:@"%0.3f秒", spend.floatValue];
        cell.raceTypeLable.text = [NSString stringWithFormat:@"0-%@km/h：",[dic objectForKey:@"type"]];
        cell.dateLable.text = [NSString stringWithFormat:@"%@月%@日%@:%@",[dateDic objectForKey:@"month"],[dateDic objectForKey:@"day"],[dateDic objectForKey:@"hours"],[dateDic objectForKey:@"minutes"]];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    NSArray *dataArr;
    if (section==0) {
        dataArr = [myRecordsDic objectForKey:@"main"];
    }else{
        dataArr = [myRecordsDic objectForKey:@"other"];
    }
    //    UITableViewCell *cell;
    NSDictionary* dic = [dataArr objectAtIndex:row];
    
    if ([[dic objectForKey:@"carModel"] isKindOfClass:[NSDictionary class]]) {
        return 105;
    }else{
        return 75;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return  nil;
    }
    
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, 100, 29);
    label.text = sectionTitle;
    label.textColor = [UIColor blackColor];
    
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    sectionView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    
    UIView * contendView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, tableView.bounds.size.width, 30-1)];
    contendView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    
    [contendView addSubview:label];
    [sectionView addSubview:contendView];
    
    return sectionView;
}
@end
