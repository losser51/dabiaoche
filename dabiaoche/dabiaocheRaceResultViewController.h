//
//  dabiaocheRaceResultViewController.h
//  dabiaoche
//
//  Created by li losser on 5/17/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dabiaocheRaceResultViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  
@property (strong, nonatomic) NSMutableArray *recordArr;
@property (assign, nonatomic) int raceDistance;
- (IBAction)changeDeleteModel:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
