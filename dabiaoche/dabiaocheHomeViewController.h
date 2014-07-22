//
//  dabiaocheHomeViewController.h
//  dabiaoche
//
//  Created by li losser on 4/5/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYIntroductionView.h"

@interface dabiaocheHomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MYIntroductionDelegate>{
    
    
    IBOutlet UIView *isWaiting;
    IBOutlet UILabel *myBestSpendLable;
}
- (IBAction)toMyRecord:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *myButtomView;
@property (weak, nonatomic) IBOutlet UIView *loginButtomView;
@property (strong,nonatomic) NSDictionary * rankingDic;
@property (strong,nonatomic) NSArray* rankingArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)clickToRace:(id)sender;
- (IBAction)rankingTypeChange:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmented;
@property (weak, nonatomic) IBOutlet UIButton *webViewtoggleBtn;
- (IBAction)closeWebView:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webVIew;
- (IBAction)clickMyRecords:(id)sender;
@end
