//
//  MeetTableViewCell.m
//  WTM
//
//   27/01/15.

//

#import "MeetTableViewCell.h"

#define kKeyTitle                @"title"
#define kKeyLocation         @"address"
#define kKeyDate                @"startDate"
#define kKeyCoverPage      @"coverImage"
#define kKeyDistance          @"distance"


@interface MeetTableViewCell ()

@end

@implementation MeetTableViewCell


-(void)setMeetInfo:(PFObject *)meetInfo{
    _meetInfo = meetInfo;
    
    _lblTitle.text = _meetInfo[kKeyTitle];
    _lblLocation.text =_meetInfo[kKeyLocation];
    _lblDate.text =[[ AppDelegate dateFormatter ] stringFromDate:_meetInfo[kKeyDate]];
    [_imgViewCover sd_setImageWithURL:[NSURL URLWithString:_meetInfo[kKeyCoverPage]] placeholderImage:nil];
    [self checkForDistanceAndShowIfAvailable:meetInfo];
}

-(void)checkForDistanceAndShowIfAvailable:(PFObject*)meetInfo{
    
    if(_meetInfo[kKeyDistance] && [_meetInfo[kKeyDistance] length]>0)
    {
        _viewDistance.hidden = NO;
        _lblDistance.text = _meetInfo[kKeyDistance];
        _viewDistance.layer.cornerRadius = _viewDistance.frame.size.width/2;
        _lblUnit.text = @"MI";
    }else{
        _viewDistance.hidden =  YES;
    }
}

-(void)setDistance:(CGFloat)distance{
    _distance = distance;
    [_meetInfo setObject:[NSString stringWithFormat:@"%.1f",distance] forKey:kKeyDistance];
    [self checkForDistanceAndShowIfAvailable:_meetInfo];
}
@end
