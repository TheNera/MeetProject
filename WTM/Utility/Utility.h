//
//  Utility.h
//  CDS Mobile
//
//  Created by Prashant Bhayani on 24/09/14.
//
//

#import <Foundation/Foundation.h>

typedef void(^Completion)(NSString*);
typedef void(^ResponseBlock)(id);
@interface Utility : NSObject
{
    
}

@property(nonatomic,strong) Completion competion;
+ (BOOL)validateEmail:(NSString*)email;
+ (NSString *) removeWhiteSpaceFromString:(NSString *)aStrwhiteSpace;
+(id)sharedInstance;
-(void)setAttendingStatus:(BOOL)isAttenging forMeet:(PFObject*)meetInfo attendeeId:(NSString*)strAttendeeId completion:(Completion)completion;
-(void)shareMeet:(PFObject*)object viewController:(UIViewController*)viewcontroller;
-(void)getAttendeesForMeetId:(NSString*)strMeetId userId:(NSString*)strUserId completion:(ResponseBlock)responseBlock;
-(void)getGallaryForMeetId:(NSString*)strMeetId userId:(NSString*)strUserId completion:(ResponseBlock)responseBlock;
-(BOOL)isDate:(NSDate*)date InPastToDate:(NSDate*)refDate;
@end
