//
//  SelectCategoriesVC.m
//  WTM
//

//
//

#import "SelectCategoriesVC.h"

@interface SelectCategoriesVC ()
{
    NSMutableArray *mutArrAllCategories;
}
@end

@implementation SelectCategoriesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    mutArrAllCategories = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        NSMutableDictionary *aMutDict =[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Category %d",i+1],@"categoryName",@"false",@"isSelected", nil];
        [mutArrAllCategories addObject:aMutDict];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBackAction:(id)sender
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isSelected = 'true'"];
    NSArray *aArrSelectedCategories = [mutArrAllCategories filteredArrayUsingPredicate:predicate];
    [_delegate selectCategoriesDidFinishedWithCategories:aArrSelectedCategories];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView Controller
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mutArrAllCategories.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
    
    
    NSMutableDictionary *aMutDictCategory = [mutArrAllCategories objectAtIndex:indexPath.row];
    [self setSelectedStateForCell:aCell andState:[aMutDictCategory[@"isSelected"] boolValue]];
    
    UILabel *aLabel = (UILabel*)[aCell viewWithTag:51];
    aLabel.text = aMutDictCategory[@"categoryName"];
    return aCell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *aMutDictCategory = [mutArrAllCategories objectAtIndex:indexPath.row];
    [aMutDictCategory setObject:@"false" forKey:@"isSelected"];
    
    UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
    [self setSelectedStateForCell:aCell andState:[aMutDictCategory[@"isSelected"] boolValue]];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *aMutDictCategory = [mutArrAllCategories objectAtIndex:indexPath.row];
    [aMutDictCategory setObject:@"true" forKey:@"isSelected"];

    UITableViewCell *aCell = [tableView cellForRowAtIndexPath:indexPath];
    [self setSelectedStateForCell:aCell andState:[aMutDictCategory[@"isSelected"] boolValue]];
}

-(void)setSelectedStateForCell:(UITableViewCell*)aCell andState:(BOOL)isSelected{
    
    if(isSelected){
        aCell.accessoryView = [[ UIImageView alloc ]
                               initWithImage:[UIImage imageNamed:@"tickMark.png" ]];
        aCell.selected = YES;
    }else{
        aCell.accessoryView =nil;
        aCell.selected = NO;
    }
}
@end
