//
//  MVPlaceSearchTextField.m
//  PlaceSearchAPIDEMO
//
//  Created by indianic on 26/04/14.
//  Copyright (c) 2014 Indianic. All rights reserved.
//

#import "MVPlaceSearchTextField.h"

@implementation MVPlaceSearchTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/



-(void)awakeFromNib{
    
    self.autoCompleteDataSource=self;
    self.autoCompleteDelegate=self;
    self.autoCompleteTableCornerRadius=0.0;
    self.autoCompleteRowHeight=35;
    self.autoCompleteTableCellTextColor=[UIColor colorWithWhite:0.131 alpha:1.000];
    self.autoCompleteTableFrame=CGRectMake(6, 95, 308, 100);

    self.autoCompleteBoldFontName=@"Helvetica";
    self.autoCompleteRegularFontName=@"Helvetica";
    self.autoCompleteFontSize=14;
    self.autoCompleteTableBorderWidth=0.0;
    self.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=NO;
    self.autoCompleteShouldHideOnSelection=YES;
    self.maximumNumberOfAutoCompleteRows= 5;
    
}
#pragma mark - Datasource Autocomplete
//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        
        NSString *aQuery=[textField.text stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        
//        NSString *aStrURl=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/queryautocomplete/json?&key=%@&sensor=false&input=%@",_strApiKey,aQuery];

        NSString *aStrURl=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=true&key=%@",aQuery,_strApiKey];
        
        NSMutableDictionary *aResultDict=[self stringWithUrl:[NSURL URLWithString:aStrURl]].mutableCopy;
        if(aResultDict){
            NSArray *aResult=[[self stringWithUrl:[NSURL URLWithString:aStrURl]] objectForKey:@"predictions"];
            NSMutableArray *arrfinal=[NSMutableArray array];
            for (NSDictionary *aTempDict in aResult) {
                PlaceObject *placeObj=[[PlaceObject alloc]initWithPlaceName:[aTempDict objectForKey:@"description"]];
                placeObj.userInfo=aTempDict;
                [arrfinal addObject:placeObj];
            }
            handler(arrfinal);
        }else{
            handler(nil);
        }
    });
}


#pragma mark - AutoComplete Delegates
-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField didSelectAutoCompleteString:(NSString *)selectedString withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject forRowAtIndexPath:(NSIndexPath *)indexPath{
    PlaceObject *placeObj=(PlaceObject*)selectedObject;
    NSString *aStrPlaceReferance=[placeObj.userInfo objectForKey:@"reference"];
    PlaceDetail *placeDetail=[[PlaceDetail alloc]initWithApiKey:_strApiKey];
    placeDetail.delegate=self;
    [placeDetail getPlaceDetailForReferance:aStrPlaceReferance];
}
-(BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField shouldConfigureCell:(UITableViewCell *)cell withAutoCompleteString:(NSString *)autocompleteString withAttributedString:(NSAttributedString *)boldedString forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.contentView.backgroundColor=[UIColor whiteColor];
    
    return YES;
    
}
-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willShowAutoCompleteTableView:(UITableView *)autoCompleteTableView{
    [_placeSearchDelegate placeSearchWillShowResult];
}
-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willHideAutoCompleteTableView:(UITableView *)autoCompleteTableView{
    [_placeSearchDelegate placeSearchWillHideResult];
}
#pragma mark - PlaceDetail Delegate

-(void)placeDetailForReferance:(NSString *)referance didFinishWithResult:(NSMutableDictionary *)resultDict{
    dispatch_sync(dispatch_get_main_queue(), ^{
        //Respond To Delegate
        [_placeSearchDelegate placeSearchResponseForSelectedPlace:resultDict];
    });
    
}


#pragma mark - URL Operation
- (NSDictionary *)stringWithUrl:(NSURL *)url
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    if(urlData){
        // Construct a Dictionary around the Data from the response
        NSDictionary *aDict=[NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:&error];
        return aDict;
    }else{return nil;}
    
}



@end
