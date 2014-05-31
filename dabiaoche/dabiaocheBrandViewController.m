//
//  dabiaocheBrandViewController.m
//  dabiaoche
//
//  Created by li losser on 4/21/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheBrandViewController.h"
#import "dabiaocheCarModelViewController.h"
#import "dabiaocheImageLableCell.h"

@interface dabiaocheBrandViewController ()

@end

@implementation dabiaocheBrandViewController
@synthesize list = _list;
@synthesize imageDic=_imageDic;
@synthesize imageUrlList=_imageUrlList;
@synthesize tableView = _tableView;
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
    NSLog(@"aaa");
	// Do any additional setup after loading the view.
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.103:8080/getBrands"]];
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

    NSMutableArray *tmpImageUrlArray = [[NSMutableArray alloc] init];
    _imageDic = [[NSMutableDictionary alloc]init];
    for (int i=0; i<[jsonArray count]; i++) {
        NSMutableArray *tmpImageUrlArray_letter = [[NSMutableArray alloc] init];
        NSArray *jsonArray_letter = [jsonArray objectAtIndex:i];
        for (int j=0; j<[jsonArray_letter count]; j++) {
            NSString *imageUrl = [[jsonArray_letter objectAtIndex:j] objectForKey:@"imgurl"];
            if([imageUrl isEqualToString:@""]){
                [tmpImageUrlArray_letter addObject:@"carModel.png"];
            }else{
                [tmpImageUrlArray_letter addObject:imageUrl];
            }
        }
        [tmpImageUrlArray addObject:tmpImageUrlArray_letter];
    }
    self.imageUrlList = [tmpImageUrlArray copy];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseCarModel" object:nil];
//    [center addObserver:self selector:@selector(chooseCarModel:) name:@"chooseCarModel" object:nil];
    NSLog(@"bbb");
}

- (void)viewWillAppear:(BOOL)animated{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    dabiaocheImageLableCell *cell = (dabiaocheImageLableCell *)[tableView
                                                                dequeueReusableCellWithIdentifier:@"imageLableCell"];
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    NSString *indexKey = [NSString stringWithFormat:@"%d-%d",section,row];

    NSDictionary* one = [[self.list objectAtIndex:section] objectAtIndex:row];
    cell.lable.text = [one objectForKey:@"name"];

    UIImage *image = [_imageDic objectForKey:indexKey];
    if (image == nil) {
        NSString *imageUrl = [[self.imageUrlList objectAtIndex:section]objectAtIndex:row];
        
        if([imageUrl isEqualToString:@"carModel.png"]){
            image = [UIImage imageNamed:@"carModel.png"];
        }else{
            NSURL *url = [NSURL URLWithString:imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            image = [[UIImage alloc] initWithData:data];
        }
    }

    cell.imageView1.image = image;
    [_imageDic setObject:image forKey:indexKey];
    return cell;
}

#pragma mark table view
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.list objectAtIndex:section] objectAtIndex:0] objectForKey:@"letter"];
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return  nil;
    }
    
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(50, 0, 50, 29);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.list objectAtIndex:section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return [self.list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    NSDictionary* one = [[self.list objectAtIndex:section] objectAtIndex:row];
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    dabiaocheCarModelViewController *carModelView = [storyBoard instantiateViewControllerWithIdentifier:@"carModelView"];
    carModelView.brandId = [[one objectForKey:@"id"] intValue];
    
    [self.navigationController pushViewController:carModelView animated:YES];
}

@end
