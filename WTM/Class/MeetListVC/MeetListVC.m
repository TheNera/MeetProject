//
//  MeetListVC.m
//  WTM
//
//   27/01/15.

//

#import "MeetListVC.h"
#import "MeetTableViewCell.h"
@interface MeetListVC ()
{
    NSMutableArray *mutArrMeetsDatasource;
    
}
@end

@implementation MeetListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    mutArrMeetsDatasource = [NSMutableArray arrayWithArray:[self getMeetListFromParse]];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    
}
#pragma mark - Parse Methods

-(NSArray*)getMeetListFromParseWithUser:(PFUser*)user
{
    PFQuery *query = [ PFQuery queryWithClassName:@"Meets"];
    [query whereKey:@"user" equalTo:user];
    return  [query findObjects];
    
}


-(NSArray*)getMeetListFromParse
{
    PFQuery *query = [ PFQuery queryWithClassName:@"Meets"];
    return  [query findObjects];
    
}

#pragma mark - TableView Delegates and Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mutArrMeetsDatasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetTableViewCell *meetCell =[tableView dequeueReusableCellWithIdentifier:@"MeetCell"];
    meetCell.meetInfo = [mutArrMeetsDatasource objectAtIndex:indexPath.row];
    meetCell.distance = 2.0;
    
    return meetCell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
