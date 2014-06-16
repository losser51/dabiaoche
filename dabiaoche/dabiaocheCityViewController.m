//
//  dabiaocheCityViewController.m
//  dabiaoche
//
//  Created by li losser on 5/1/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheCityViewController.h"
#import "Const.h"

@interface dabiaocheCityViewController ()

@end

@implementation dabiaocheCityViewController
@synthesize dic = _dic;
@synthesize keys = _keys;
@synthesize tableView = _tableView;
@synthesize locationManager = _locationManager;

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
    NSString *url = [NSString stringWithFormat:API_HOST_CITYS];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    _dic = [[NSMutableDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error]];
    if (!_dic) {
        NSLog(@"Error parsing JSON: %@", error);
    }
    _keys = [[_dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [[_dic objectForKey: [_keys objectAtIndex:section]]count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [_keys objectAtIndex:section];
    if ([title isEqualToString:@"0"]) {
        title = @"GPS定位城市";
    }
    else if ([title isEqualToString:@"1"]) {
        title = @"热门城市";
    }
    return title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray* indexArray = [[NSMutableArray alloc]initWithArray:_keys];
    [indexArray replaceObjectAtIndex:0 withObject:@"    "];
    [indexArray replaceObjectAtIndex:1 withObject:@"热门"];
    return indexArray;
}
//(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    // Return the index for the given section title
//    return [indexLetters indexOfObject:title];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tag"];
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
//    NSString *indexKey = [NSString stringWithFormat:@"%d-%d",section,row];
    //    UITableViewCell *cell = [_cellDic objectForKey:indexKey];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"tag"];
    }
    cell.textLabel.text = [[[_dic objectForKey: [_keys objectAtIndex:section]]objectAtIndex:row]objectForKey:@"name"];
    //    else{
    //        return cell;
    //    }
//    NSDictionary* one = [[self.list objectAtIndex:section] objectAtIndex:row];
//    cell.textLabel.text = [one objectForKey:@"name"];
//    UIImage *image = [_imageDic objectForKey:indexKey];
//    if (image == nil) {
//        NSString *imageUrl = [[self.imageUrlList objectAtIndex:section]objectAtIndex:row];
//        
//        if([imageUrl isEqualToString:@"carModel.png"]){
//            image = [UIImage imageNamed:@"carModel.png"];
//        }else{
//            NSURL *url = [NSURL URLWithString:imageUrl];
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            image = [[UIImage alloc] initWithData:data];
//        }
//    }
//    
//    [cell.imageView setFrame:CGRectMake(10, 10,61, 37)];
//    [cell.imageView setImage:image];
//    [_imageDic setObject:image forKey:indexKey];
    //    [_cellDic setObject:cell forKey:indexKey];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    NSDictionary* one = [[_dic objectForKey: [_keys objectAtIndex:section]]objectAtIndex:row];
    NSError *error;
    //    id result =[NSJSONSerialization dataWithJSONObject:one:kNilOptions error:&error];
    id result = [NSJSONSerialization dataWithJSONObject:one options:kNilOptions error:&error];
    [nc postNotificationName:@"chooseCity" object:result];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]
                                          animated:YES];
}

#pragma mark location
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    //获取所在地城市名
    [self locationAddressWithLocation:newLocation];
    [_locationManager stopUpdatingLocation];
}

- (void)locationAddressWithLocation:(CLLocation *)locationGps
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:locationGps completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error) {
             NSLog(@"error: %@",error.description);
         }
         else{
             NSLog(@"placemarks count %lu",(unsigned long)placemarks.count);
             for (CLPlacemark *placeMark in placemarks)
             {
                 NSString *cityName = placeMark.administrativeArea;
                 NSRange foundObj=[cityName rangeOfString:@"市" options:NSCaseInsensitiveSearch];
                 if(foundObj.length>0) {
                     cityName = [cityName substringToIndex:cityName.length-1];
                 }
                 for (NSString* key in _keys) {
                     for (NSDictionary* city in [_dic objectForKey:key]) {
                         if ([[city objectForKey:@"name"]isEqualToString:cityName]) {
                             NSArray *tem = [[NSArray alloc]initWithObjects:city.copy, nil];
                             [_dic setObject:tem forKey:@"0"];
                             NSLog(@"1 city name %@",[city objectForKey:@"name"]);
                             [_tableView reloadData];
                             return;
                         }
                         if ([[city objectForKey:@"englishName"]isEqualToString:[cityName lowercaseString]]) {
                             NSArray *tem = [[NSArray alloc]initWithObjects:city.copy, nil];
                             [_dic setObject:tem forKey:@"0"];
                             NSLog(@"2 city name %@",[city objectForKey:@"name"]);
                             [_tableView reloadData];
                             return;
                         }
                     }
                 }

                 NSLog(@"地址administrativeArea:%@",placeMark.administrativeArea);

             }
         }
         
     }];
}
- (IBAction)didEditChange:(id)sender {
    UITextField* textField = (UITextField*)sender;
    
}
@end
