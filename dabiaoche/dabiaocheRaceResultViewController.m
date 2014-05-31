//
//  dabiaocheRaceResultViewController.m
//  dabiaoche
//
//  Created by li losser on 5/17/14.
//  Copyright (c) 2014 li losser. All rights reserved.
//

#import "dabiaocheRaceResultViewController.h"
#import "dabiaocheRaceRecordCell.h"

@interface dabiaocheRaceResultViewController ()

@end

@implementation dabiaocheRaceResultViewController
@synthesize recordArr,raceDistance;

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [recordArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	dabiaocheRaceRecordCell *cell = (dabiaocheRaceRecordCell *)[tableView
                                      dequeueReusableCellWithIdentifier:@"recordCell"];
    NSInteger row = [indexPath row];
//    NSInteger section = [indexPath section];
    NSDictionary * one = [recordArr objectAtIndex:row];
    NSArray *timeArr = [one objectForKey:@"timeArr"];
    NSArray *accArr = [one objectForKey:@"accArr"];

    double time = [[timeArr objectAtIndex:[timeArr count]-1]doubleValue];
    NSNumber *avg = [accArr valueForKeyPath:@"@avg.floatValue"];
    NSNumber *max = [accArr valueForKeyPath:@"@max.floatValue"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日H:mm"];
    
//    NSString *destDateString = [dateFormatter stringFromDate:[dateArr objectAtIndex:row]];
    
    cell.dateLable.text = [dateFormatter stringFromDate:[one objectForKey:@"date"]];
    cell.raceTypeLable.text = [NSString stringWithFormat:@"0-%dkm/h：",raceDistance];
    cell.gLable.text = [NSString stringWithFormat:@"最大G值：%0.3f，平均G值%0.3f",[max doubleValue],[avg doubleValue]];
    cell.indexLable.text = [NSString stringWithFormat:@"%d",row+1];
    cell.timeLable.text = [NSString stringWithFormat:@"%0.3f",time];
    return cell;
}

- (IBAction)changeDeleteModel:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
}

//这个方法根据参数editingStyle是UITableViewCellEditingStyleDelete
//还是UITableViewCellEditingStyleDelete执行删除或者插入
- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = [indexPath row];
//        [self.list removeObjectAtIndex:row];
        [recordArr removeObjectAtIndex:row];
//        recordArr removeObjectAtIndex:<#(NSUInteger)#>
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end
