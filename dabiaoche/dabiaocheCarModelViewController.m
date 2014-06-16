//
//  dabiaocheCarModelViewController.m
//  dabiaoche
//
//  Created by li losser on 4/26/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheCarModelViewController.h"
#import "dabiaocheImageLableCell.h"
#import "Const.h"

@interface dabiaocheCarModelViewController ()

@end

@implementation dabiaocheCarModelViewController
@synthesize list=_list;
@synthesize brandId=_brandId;
@synthesize tableView=_tableView;
@synthesize imageDic=_imageDic;
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
    NSError *error;
    //加载一个NSURL对象
    NSString *url = [NSString stringWithFormat:API_HOST_CARMODELS_BY_BRAND,(long)self.brandId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    //    NSDictionary *brandsDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", error);
    } else {
        self.list = jsonArray;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.list objectAtIndex:section] objectForKey:@"name"];
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return  nil;
    }
    
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(50, 0, 150, 29);
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    dabiaocheImageLableCell *cell = (dabiaocheImageLableCell *)[tableView dequeueReusableCellWithIdentifier:@"imageLableCell"];
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    NSString *indexKey = [NSString stringWithFormat:@"%d-%d",section,row];

    NSDictionary* one = [[[self.list objectAtIndex:section] objectForKey:@"carModels"]objectAtIndex:row];
    cell.lable.text = [one objectForKey:@"name"];
    UIImage *image = [_imageDic objectForKey:indexKey];
    if (image == nil) {
        
        NSString *imageUrl = [NSString stringWithFormat:IMAGE_URL_CARMODEL,[one objectForKey:@"id"]];
        
        if([imageUrl isEqualToString:@""]){
            image = [UIImage imageNamed:@"carModel.png"];
        }else{
            NSURL *url = [NSURL URLWithString:imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            image = [[UIImage alloc] initWithData:data];
        }
    }
    
    [cell.imageView1 setImage:image];
    [_imageDic setObject:image forKey:indexKey];

    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.list objectAtIndex:section] objectForKey:@"carModels"] count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    NSDictionary* one = [[[self.list objectAtIndex:section] objectForKey:@"carModels"]objectAtIndex:row];
    NSError *error;
//    id result =[NSJSONSerialization dataWithJSONObject:one:kNilOptions error:&error];
    id result = [NSJSONSerialization dataWithJSONObject:one options:kNilOptions error:&error];
    [nc postNotificationName:@"chooseCarModel" object:result];
//    [self.navigationController popViewControllerAnimated:YES];
    int index = [self.navigationController.viewControllers count]-3;
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index]
                                          animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}


@end
