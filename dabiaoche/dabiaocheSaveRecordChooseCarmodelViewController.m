//
//  dabiaocheSaveRecordChooseCarmodelViewController.m
//  dabiaoche
//
//  Created by li losser on 5/25/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheSaveRecordChooseCarmodelViewController.h"

@interface dabiaocheSaveRecordChooseCarmodelViewController ()

@end

@implementation dabiaocheSaveRecordChooseCarmodelViewController
@synthesize otherChooseFlagImage,otherChooseCarmodelImage,otherChooseCarmodelLable,otherChooseLable;
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
    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseCarModel" object:nil];
    [center addObserver:self selector:@selector(chooseCarModel:) name:@"chooseCarModel" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Notification
- (void) chooseCarModel:(NSNotification *)notification{
    NSLog(@"Received notification: %@", [notification object]);
    NSError *error;
    NSDictionary *one = [NSJSONSerialization JSONObjectWithData:[notification object] options:NSJSONReadingAllowFragments error:&error];
    
    NSString *imageUrl = [one objectForKey:@"imgurl2"];
    UIImage *image;
    if([imageUrl isEqualToString:@""]){
        image = [UIImage imageNamed:@"carModel.png"];
    }else{
        NSURL *url = [NSURL URLWithString:imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [[UIImage alloc] initWithData:data];
    }
    otherChooseCarmodelImage.image = image;
    otherChooseCarmodelLable.text = [one objectForKey:@"name"];
    
    otherChooseLable.hidden = YES;
    otherChooseFlagImage.hidden = NO;
    otherChooseCarmodelLable.hidden = NO;
    otherChooseCarmodelImage.hidden = NO;  
}
@end
