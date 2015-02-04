//
//  MapVC.h
//  ParseStarterProject
//
//
//

#import <UIKit/UIKit.h>
#import "MVPlaceSearchTextField.h"
#import <GoogleMaps/GoogleMaps.h>

@protocol SelectLocationDelegate <NSObject>
-(void)selectLocationDidFinishedWithLocationInfo:(NSDictionary*)locationInfo;
-(void)selectLocationDidCancelled;
@end

@interface MapVC : UIViewController<PlaceSearchTextFieldDelegate,GMSMapViewDelegate>
{
    NSMutableDictionary *mutDicLocation;
}
@property(nonatomic,strong)NSMutableDictionary *selectedLocation;
@property(nonatomic,strong)id<SelectLocationDelegate>delegate;

@end
