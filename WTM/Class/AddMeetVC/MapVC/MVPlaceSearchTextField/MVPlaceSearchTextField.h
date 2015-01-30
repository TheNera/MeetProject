//
//  MVPlaceSearchTextField.h
//  PlaceSearchAPIDEMO
//
//  Created by indianic on 26/04/14.
//  Copyright (c) 2014 Indianic. All rights reserved.
//

#import "MLPAutoCompleteTextField.h"
#import "PlaceDetail.h"
#import "PlaceObject.h"

@protocol PlaceSearchTextFieldDelegate <NSObject>
-(void)placeSearchResponseForSelectedPlace:(NSMutableDictionary*)responseDict;
-(void)placeSearchWillShowResult;
-(void)placeSearchWillHideResult;
@end

@interface MVPlaceSearchTextField : MLPAutoCompleteTextField<MLPAutoCompleteFetchOperationDelegate,MLPAutoCompleteSortOperationDelegate,MLPAutoCompleteTextFieldDataSource,MLPAutoCompleteTextFieldDelegate,PlaceDetailDelegate>
@property(nonatomic,strong)NSString*strApiKey;

@property(nonatomic,strong)id<PlaceSearchTextFieldDelegate>placeSearchDelegate;
@end
