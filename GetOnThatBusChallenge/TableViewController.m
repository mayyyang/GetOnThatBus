//
//  TableViewController.m
//  GetOnThatBusChallenge
//
//  Created by May Yang on 11/4/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView reloadData];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dictionary = self.pinStops[indexPath.row];
    NSString *string = [dictionary objectForKey:@"cta_stop_name"];
    cell.textLabel.text = string;
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pinStops.count;
}
@end
