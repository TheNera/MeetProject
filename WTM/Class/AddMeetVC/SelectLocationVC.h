//
//  SelectLocationVC.h
//  WTM
//

//
//

#import <UIKit/UIKit.h>

@protocol SelectLocationDelegate <NSObject>
-(void)selectLocationDidFinishedWithLocationInfo:(NSDictionary*)locationInfo;
-(void)selectLocationDidCancelled;
@end

@interface SelectLocationVC : UIViewController

@property(nonatomic,strong)NSMutableDictionary *selectedLocation;
@property(nonatomic,strong)id<SelectLocationDelegate>delegate;
@end
