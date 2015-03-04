//
//  DateDistanceCell.m
//  WTM
//
//   04/02/15.
//
//

#import "DateDistanceCell.h"
#import <CoreLocation/CoreLocation.h>


@implementation DateDistanceCell

- (void)awakeFromNib {
    // Initialization code
    dayFormatter = [[NSDateFormatter alloc]init];
    timeFormatter = [[NSDateFormatter alloc]init];
    
    [dayFormatter setDateFormat:@"MMM d"];
    [timeFormatter setDateFormat:@"h:mm a"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    float buttonWidth = self.frame.size.width/3.0;
    float buttonHeight = self.frame.size.height;
    
    _viewDayContainer.frame = CGRectMake(0, 0, buttonWidth-1, buttonHeight);
    _viewTimeContainer.frame =CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight);
    float xPosOfDistanceContainer = _viewTimeContainer.frame.origin.x+_viewTimeContainer.frame.size.width+1;
    _viewDistanceContainer.frame = CGRectMake(xPosOfDistanceContainer, 0, buttonWidth, buttonHeight);
}
#pragma mark - Start date Handling
-(void)setStartDate:(NSDate *)startDate{
    _startDate =startDate;
    _lblDate.text = [dayFormatter stringFromDate:startDate];
    _lblWhen.text = [appDel getDayNotation:_startDate withDate:NO];
    NSString *aStrTime = [timeFormatter stringFromDate:startDate];
    
    NSMutableAttributedString *attrStringTime = [[NSMutableAttributedString alloc]initWithString:aStrTime];
    [attrStringTime addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, aStrTime.length-1)];
    [attrStringTime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:108.0/255.0 blue:130.0/255.0 alpha:1.0] range:NSMakeRange(aStrTime.length-2, 2)];
    [attrStringTime addAttribute:NSFontAttributeName value:[UIFont fontWithName:_lblTime.font.fontName size:14] range:NSMakeRange(aStrTime.length-2, 2)];
    _lblTime.attributedText = attrStringTime;
}
#pragma mark - Location Handling
-(void)setLocation:(CLLocationCoordinate2D)location{
    _location = location;
    _lblDistance.text = [appDel getDistanceString:_location];
}
@end
