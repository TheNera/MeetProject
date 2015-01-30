//
//  MeetTableViewCell.m
//  WTM
//
//   27/01/15.

//

#import "MeetTableViewCell.h"

#define kKeyTitle                @""
#define kKeyLocation         @""
#define kKeyDate                @""
#define kKeyCoverPage      @""
#define kKeyDistance          @""


@interface MeetTableViewCell ()

@end

@implementation MeetTableViewCell


-(void)setMeetInfo:(NSMutableDictionary *)meetInfo{
    _meetInfo = meetInfo;
    
    _lblTitle.text = _meetInfo[kKeyTitle];
    _lblLocation.text =_meetInfo[kKeyLocation];
    _lblDate.text =_meetInfo[kKeyDate];
    [self checkForDistanceAndShowIfAvailable:meetInfo];

}

-(void)checkForDistanceAndShowIfAvailable:(NSDictionary*)meetInfo{
    
    if(_meetInfo[kKeyDistance] && [_meetInfo[kKeyDistance] length]>0)
    {
        _viewDistance.hidden = NO;
        _lblDistance.text = _meetInfo[kKeyDistance];
        _lblUnit.text = @"MI";
    }else{
        _viewDistance.hidden =  YES;
    }
}

-(void)setDistance:(CGFloat)distance{
    _distance = distance;
    [_meetInfo setObject:[NSString stringWithFormat:@"%f",distance] forKey:kKeyDistance];
    [self checkForDistanceAndShowIfAvailable:_meetInfo];
}
@end
