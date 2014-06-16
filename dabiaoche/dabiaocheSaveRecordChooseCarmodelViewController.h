//
//  dabiaocheSaveRecordChooseCarmodelViewController.h
//  dabiaoche
//
//  Created by li losser on 5/25/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dabiaocheSaveRecordChooseCarmodelViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *otherChooseFlagImage;
@property (weak, nonatomic) IBOutlet UIImageView *userDefaultCarModelFlagImage;
@property (weak, nonatomic) IBOutlet UIImageView *otherChooseCarmodelImage;
@property (weak, nonatomic) IBOutlet UILabel *otherChooseCarmodelLable;
@property (weak, nonatomic) IBOutlet UILabel *otherChooseLable;
@property (weak, nonatomic) IBOutlet UILabel *userDefaultCarModelLable;
@property (weak, nonatomic) IBOutlet UIImageView *userDefaultCarModelImage;
@property (strong, nonatomic) NSArray *recordArr;
@property (strong, nonatomic) NSDictionary *hostUser;
@property (strong, nonatomic) NSDictionary *carModel;
@property (assign, nonatomic) int raceDistance;
- (IBAction)saveRecords:(id)sender;

@end
