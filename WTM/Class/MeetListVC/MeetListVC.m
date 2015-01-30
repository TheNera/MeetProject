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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Delegates and Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mutArrMeetsDatasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        MeetTableViewCell *meetCell =[tableView dequeueReusableCellWithIdentifier:@"MeetCell"];
    
    return meetCell;
                                      
}

@end
