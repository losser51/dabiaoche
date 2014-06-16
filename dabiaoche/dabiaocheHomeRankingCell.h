//
//  dabiaocheHomeRankingCell.h
//  dabiaoche
//
//  Created by xin.li on 14-6-8.
//  Copyright (c) 2014年 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dabiaocheHomeRankingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rankingImage;
@property (weak, nonatomic) IBOutlet UIImageView *rankingCarModelImage;
@property (weak, nonatomic) IBOutlet UILabel *rankingCarModelName;
@property (weak, nonatomic) IBOutlet UILabel *rankingUserName;
@property (weak, nonatomic) IBOutlet UILabel *rankingSpend;
@property (weak, nonatomic) IBOutlet UILabel *rankingCity;

@end
