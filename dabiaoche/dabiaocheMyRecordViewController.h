//
//  dabiaocheMyRecordViewController.h
//  dabiaoche
//
//  Created by xin.li on 14-6-2.
//  Copyright (c) 2014年 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dabiaocheMyRecordViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> 
@property (strong, nonatomic) NSArray *myRecordsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *myRecordsDic;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviBar;
@property (strong, nonatomic) NSArray* levelImageArray;
- (IBAction)back:(id)sender;
@end
