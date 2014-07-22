//
//  dabiaochetestViewController.h
//  dabiaoche
//
//  Created by xin.li on 14-7-9.
//  Copyright (c) 2014年 li losser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dabiaochetestViewController : UIViewController{
    NSTimer *beginTimer;
    int timerCount;
}
@property (strong, nonatomic) IBOutlet UIImageView *ringStep2Image;
@property (strong, nonatomic) IBOutlet UIImageView *ringStep1Image;
@property (strong, nonatomic) IBOutlet UIView *viewStep2;
@property (strong, nonatomic) IBOutlet UIView *viewStep3;
@property (strong, nonatomic) IBOutlet UILabel *timeLable;
@end
