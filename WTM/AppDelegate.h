//
//  AppDelegate.h
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)MainController *mainController;
@property(nonatomic,strong)NSDictionary *dictUserInfo;
@property(nonatomic,strong)CLLocation *myLocation;
@property (nonatomic,strong)CLLocationManager *locationManager;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong)NSDictionary *dictPayloadMeetInfo;

-(void)showAlertwithMessage:(NSString*)strMessage;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(NSDate*)convertDateToLocale:(NSDate *)date;
-(NSDate*)convertDateToUTC:(NSDate*)date;
-(NSDate*)convertDate:(NSDate*)date toTimeZone:(NSTimeZone*)timeZone;
+(id)dateFormatter;
-(NSString*)getDayNotation:(NSDate*)date withDate:(BOOL)withDate;
-(NSString *)getDistanceString:(CLLocationCoordinate2D)location;
-(NSInteger)getDistanceBetween:(CLLocationCoordinate2D)myLocation andFromLocation:(CLLocationCoordinate2D)fromLocation;
@end

