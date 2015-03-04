//
//  Utility.m
//  CDS Mobile
//
//  Created by Prashant Bhayani on 24/09/14.
//
//

#import "Utility.h"
static Utility *sharedInstance = nil;
@implementation Utility
+(id)sharedInstance{
    if(!sharedInstance){
        sharedInstance = [[Utility alloc]init];
    }
    return sharedInstance;
}

+ (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (NSString *) removeWhiteSpaceFromString:(NSString *)aStrwhiteSpace
{
    NSString *strFinal = [aStrwhiteSpace stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return strFinal;
}


-(void)setAttendingStatus:(BOOL)isAttenging forMeet:(PFObject*)meetInfo attendeeId:(NSString*)strAttendeeId completion:(Completion)completion{
    
    if(isAttenging){
        PFObject *aObject = [PFObject objectWithClassName:@"Attendees"];
        [aObject setObject:[PFUser currentUser].objectId forKey:@"userId"];
        [aObject setObject:meetInfo.objectId forKey:@"meetId"];
        [aObject setObject:[PFUser currentUser] forKey:@"user"];
        [aObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            //Successfully Attended.
            if(completion && succeeded){
                completion(aObject.objectId);
            }
        }];
        
    }else{
        PFObject *aObject= [PFObject objectWithoutDataWithClassName:@"Attendees" objectId:strAttendeeId];
        [aObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            // Successfully UnAttended.
            if(completion){
                completion(aObject.objectId);
            }
        }];
    }
}

#pragma mark - Get Attendees and Photostream for Meet and User

-(void)getAttendeesForMeetId:(NSString *)strMeetId userId:(NSString *)strUserId completion:(ResponseBlock)responseBlock{
    [PFCloud callFunctionInBackground:@"getAtteneesOfMeet" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:strMeetId,@"meetId",strUserId,@"userId", nil] block:^(id object, NSError *error) {
        if(responseBlock && object && !error){
            responseBlock(object);
        }
    }];
}

-(void)getGallaryForMeetId:(NSString*)strMeetId userId:(NSString*)strUserId completion:(ResponseBlock)responseBlock{
    
    PFQuery *aQuery = [PFQuery queryWithClassName:@"Photostream"];
    if(strMeetId){
        PFObject *aMeetObject = [PFObject objectWithoutDataWithClassName:@"Meets" objectId:strMeetId];
        [aMeetObject setObjectId:strMeetId];
        [aQuery whereKey:@"meet" equalTo:aMeetObject];
    }
    
    if(strUserId){
        PFObject *aUserObject = [PFUser user];
        [aUserObject setObjectId:strMeetId];
        [aQuery whereKey:@"meet" equalTo:aUserObject];
    }
    
    [aQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(responseBlock && objects && !error){
            responseBlock(objects);
        }
    }];
    
}
-(void)shareMeet:(PFObject*)object viewController:(UIViewController*)viewcontroller
{
    NSString *textToShare = object[@"title"];
    NSURL *myWebsite = [NSURL URLWithString:@"https://www.wheresthemeet.net/"];
      NSString *aStrCoverPath = object[@"coverImage"];
   __block UIImage *img ;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:aStrCoverPath] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if(image)
        {
            img = image;
        }
        else
        img =    [UIImage imageNamed:@"coverPlaceholder.png"];
        
        NSMutableArray *objectsToShare = [NSMutableArray arrayWithObjects:textToShare, myWebsite, nil ] ;
        if (img) {
            [objectsToShare addObject:img];
        }
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
        
        NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                       UIActivityTypePrint,
                                       UIActivityTypeAssignToContact,
                                       UIActivityTypeSaveToCameraRoll,
                                       UIActivityTypeAddToReadingList,
                                       UIActivityTypePostToFlickr,
                                       UIActivityTypePostToVimeo,
                                       UIActivityTypeCopyToPasteboard,UIActivityTypeMail,UIActivityTypeMessage
                                       ];
        
        activityVC.excludedActivityTypes = excludeActivities;
        
        [viewcontroller presentViewController:activityVC animated:YES completion:nil];
    }];
//    [manager downloadWithURL:[NSURL URLWithString:aStrCoverPath] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//        
//        if(image){
//            NSString *localKey = [NSString stringWithFormat:@"Item-%d", i];
//            [[SDImageCache sharedImageCache] storeImage:image forKey:localKey];
//        }
//        
//    }];
  
    

}

-(BOOL)isDate:(NSDate *)date InPastToDate:(NSDate *)refDate{
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:refDate];
    if(timeInterval<0){
        return YES;
    }
    return NO;
}
@end