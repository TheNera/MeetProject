//
//  MeetListVC.h
//  WTM
//
//   27/01/15.

//

#import <UIKit/UIKit.h>

@interface MeetListVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblMeetList;

@end
