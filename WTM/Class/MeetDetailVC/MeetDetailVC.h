//
//  MeetDetailVCViewController.h
//  WTM
//
//   04/02/15.
//
//

#import <UIKit/UIKit.h>
#import "AddMeetVC.h"

@interface MeetDetailVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,EditMeetDelegate>{
    UIImageView *imgViewCover;
}
@property (nonatomic,strong)PFObject *meetObject;

@property (nonatomic,assign)double distance;
@property(nonatomic,strong)NSString *strAttendeeId,*strMeetId;
@property(nonatomic,assign)BOOL isAttending;
@property(nonatomic,strong)NSMutableArray *mutArrPeople,*mutPhotostream;
@property (weak, nonatomic) IBOutlet UITableView *tblDetails;
@property (weak, nonatomic) IBOutlet UIView *viewBtnPanel;
@property (weak, nonatomic) IBOutlet UIButton *btnGoing;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;


@end
