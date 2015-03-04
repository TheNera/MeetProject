//
//  MeetTableViewCell.h
//  WTM
//
//   27/01/15.

//

#import <UIKit/UIKit.h>
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
@interface MeetTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UIImageView *imgViewCover;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblUnit;

@property (weak, nonatomic) IBOutlet UIView *viewDistance;

@property(weak,nonatomic)PFObject *meetInfo;
@property(assign,nonatomic)CGFloat distance;
@end
