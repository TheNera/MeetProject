//
//  DateDistanceCell.h
//  WTM
//
//   04/02/15.
//
//

#import <UIKit/UIKit.h>

@interface DateDistanceCell : UITableViewCell{
    NSDateFormatter *dayFormatter;
    NSDateFormatter *timeFormatter;
}
@property (weak, nonatomic) IBOutlet UILabel *lblWhen;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStart;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblUnit;

@property(nonatomic,strong) NSDate *startDate;
@property(nonatomic,assign)CLLocationCoordinate2D location;
@property (weak, nonatomic) IBOutlet UIView *viewDayContainer;
@property (weak, nonatomic) IBOutlet UIView *viewTimeContainer;
@property (weak, nonatomic) IBOutlet UIView *viewDistanceContainer;

@end
