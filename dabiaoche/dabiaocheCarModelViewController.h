//
//  dabiaocheCarModelViewController.h
//  dabiaoche
//
//  Created by li losser on 4/26/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dabiaocheCarModelViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>  
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *list;
@property (assign, nonatomic) NSInteger brandId;
@property (strong, nonatomic) NSMutableDictionary *imageDic;
@end
