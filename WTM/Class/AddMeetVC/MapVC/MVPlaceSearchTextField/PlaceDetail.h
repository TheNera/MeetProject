//
//  PlaceDetail.h
//  PlaceSearchAPIDEMO
//
//  Created by indianic on 26/04/14.
//  Copyright (c) 2014 Indianic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlaceDetailDelegate <NSObject>

-(void)placeDetailForReferance:(NSString*)referance didFinishWithResult:(NSMutableDictionary*)resultDict;
@end

@interface PlaceDetail : NSObject{
    NSString *aStrApiKey;
}

@property(nonatomic,strong)id <PlaceDetailDelegate> delegate;
-(id)initWithApiKey:(NSString*)ApiKey;
-(void)getPlaceDetailForReferance:(NSString*)strReferance;
@end
