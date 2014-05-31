//
//  dabiaocheCityViewController.h
//  dabiaoche
//
//  Created by li losser on 5/1/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h> 

@interface dabiaocheCityViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *dic;
@property (strong, nonatomic) NSMutableArray *keys;
@property (nonatomic, retain) CLLocationManager *locationManager;
@end
