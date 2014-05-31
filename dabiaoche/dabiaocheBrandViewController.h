//
//  dabiaocheBrandViewController.h
//  dabiaoche
//
//  Created by li losser on 4/21/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dabiaocheBrandViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>  
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSMutableDictionary *imageDic;
@property (strong, nonatomic) NSArray *imageUrlList;
@end
