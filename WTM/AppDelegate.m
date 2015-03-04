//
//  AppDelegate.m
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>
#define kParse_AppId @"WrdjimzqwGjt0MqY86abJ6QEmPGFb4mFoHiUwgkX" //@"sSmfO69GlXZUM5TDtbipc7OjBCOmFwzhPSzE3B81" //"

#define kParse_clientId @"HN0aV2nEvASPQClYLKIBxcTO7Eg9Ogfw5MMPmFPl" //@"Hd6bCosZbUZshNweaEOSCAngZW2E6IFYnfnQudX3"


@interface AppDelegate (){
    NSTimer *timerLocation;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    appDel = self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [Parse setApplicationId:kParse_AppId clientKey:kParse_clientId];


    [GMSServices provideAPIKey:@"AIzaSyDx76torLMSXSGUYxUysD1TQ_mLi4PJjLY"];
    _dictUserInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    _myLocation = [[CLLocation alloc]initWithLatitude:[[NSUserDefaults standardUserDefaults]floatForKey:@"latitude"] longitude:[[NSUserDefaults standardUserDefaults]floatForKey:@"longitude"]];
    
//===== This is to forcefully logout the User as of now, until we didnt have Settings Screen ready
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userDetail"];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isLoggedIn"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    [PFUser logOut];
//======================================================================

    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy =kCLLocationAccuracyKilometer;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    
    // Register for Push Notitications
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];


    
    
    return YES;
}
-(void)timerAction:(NSTimer*)timer{
        [self pollLocation:_myLocation];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
            [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if(timerLocation){
        [timerLocation invalidate];
        timerLocation = nil;
    }
    timerLocation = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
#pragma mark - Utility Methods
-(void)showAlertwithMessage:(NSString*)strMessage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"WTM" message:strMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Prashant.WTM" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WTM" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WTM.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Date Conversion
//===================================================================================
// Convert UTC Date to Locale Date
//===================================================================================
-(NSDate*)convertDateToLocale:(NSDate *)date{
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:date];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    NSDate *destinationDate =[[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:date];
    return destinationDate;
    
}
static NSDateFormatter *sharedObject=nil;
+(id)dateFormatter{
    if(!sharedObject){
        sharedObject = [[NSDateFormatter alloc]init];
           [sharedObject setDateFormat:@"MMMM d, yyyy 'at' h:mm a"];
    }
    return sharedObject;
}


//===================================================================================
// Convert Locale Date to UTC
//===================================================================================
-(NSDate*)convertDateToUTC:(NSDate*)date{
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:date];
    NSTimeInterval gmtInterval = gmtOffset-currentGMTOffset;
    
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:date];
    
    return destinationDate;
}


-(NSDate*)convertDate:(NSDate*)date toTimeZone:(NSTimeZone*)timeZone{
    
    NSTimeZone *currentTimeZone = timeZone;
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:date];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    NSDate *destinationDate =[[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:date];
    return destinationDate;
}

-(NSString*)getDayNotation:(NSDate*)date withDate:(BOOL)withDate{

    NSCalendar *aCalender = [NSCalendar calendarWithIdentifier:NSGregorianCalendar];
    aCalender.timeZone = [NSTimeZone defaultTimeZone];

    NSDateComponents *componentsForDate = [aCalender components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitWeekday fromDate:date];
    NSDateComponents *componentsForToday = [aCalender components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitWeekday fromDate:[NSDate date]];
   NSDateComponents *componenets = [aCalender components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitWeekday fromDateComponents:componentsForToday toDateComponents:componentsForDate options:0];
    
    NSInteger noOfdays = (7- componentsForToday.weekday)+ 7 + (componentsForDate.weekday==1?1:0);
    
    if(componenets.day ==1){
        return @"Tomorrow";
    }else if (componenets.day==0){
        return @"Today";
    }else
        //Check if Date is saturday or Sunday
        if((componentsForDate.weekday == 1 || componentsForDate.weekday == 7) && noOfdays == componenets.day){
            return @"Next Weekend";
        }else if((componentsForDate.weekday == 1 || componentsForDate.weekday == 7) && noOfdays-7==componenets.day){
            return @"This Weekend";
        }else
        {
            if(withDate)
                [[AppDelegate dateFormatter]setDateFormat:@"EEEE, MMM d"];
            else{
                [[AppDelegate dateFormatter]setDateFormat:@"EEEE"];
            }
            NSString *strDate =  [[AppDelegate dateFormatter]stringFromDate:date];
            [[AppDelegate dateFormatter] setDateFormat:@"MMMM d, yyyy 'at' h:mm a"];

            return strDate;
        }
}


-(NSString *)getDistanceString:(CLLocationCoordinate2D)location{
    NSInteger distanceInMeters = [self getDistanceBetween:appDel.myLocation.coordinate andFromLocation:location];
    CGFloat distanceInMiles = distanceInMeters * 0.000621371;
    
    return [NSString stringWithFormat:@"%.1f",distanceInMiles];
}

// This will return distance in Meters
-(NSInteger)getDistanceBetween:(CLLocationCoordinate2D)myLocation andFromLocation:(CLLocationCoordinate2D)fromLocation{
    CLLocation *aMyLocation = [[CLLocation alloc]initWithLatitude:myLocation.latitude longitude:myLocation.longitude];
    
    CLLocation *aFromLocation = [[CLLocation alloc]initWithLatitude:fromLocation.latitude longitude:fromLocation.longitude];
    
    NSInteger distance = [aMyLocation distanceFromLocation:aFromLocation];
    return distance;
    
}

#pragma mark - Location manager Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if(locations.count>0){
        
        if(_myLocation.coordinate.latitude!=[[locations firstObject] coordinate].latitude || _myLocation.coordinate.longitude!=[[locations firstObject] coordinate].longitude){
            _myLocation = [locations firstObject];
            NSLog(@"Location changed : %f,%f",_myLocation.coordinate.latitude,_myLocation.coordinate.longitude);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"locationUpdated" object:nil];
            
        }

    
    [[NSUserDefaults standardUserDefaults]setFloat:_myLocation.coordinate.latitude forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults]setFloat:_myLocation.coordinate.longitude forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    }
    
}

-(void)pollLocation:(CLLocation*)aLocation{
    if(![PFUser currentUser]){
        return;
    }
    NSMutableDictionary *aMutDictLocation = [NSMutableDictionary dictionary];
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:aLocation];
    [aMutDictLocation setObject:geoPoint forKey:@"userLocation"];
    [aMutDictLocation setObject:[PFUser currentUser].objectId forKey:@"userId"];
    [PFCloud callFunctionInBackground:@"sendPushForLocation" withParameters:aMutDictLocation block:^(id object, NSError *error) {
        if([object isKindOfClass:[NSDictionary class]]){
            [self sendLocalNotificationforMeet:object];
        }
    }];
    
}

-(void)sendLocalNotificationforMeet:(NSDictionary*)meetObject{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification && [UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        NSInteger aIntTag =  [UIApplication sharedApplication].applicationIconBadgeNumber;
        aIntTag ++;
        notification.fireDate = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber =  aIntTag;
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody = [NSString stringWithFormat:@"There is meet around you"];
        notification.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"meetDetail",@"type", nil];
        _dictPayloadMeetInfo = meetObject;
        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if(notification.userInfo && [notification.userInfo[@"type"] isEqualToString:@"meetDetail"]){
        [self.mainController showMeetDetailScreenWithObject:_dictPayloadMeetInfo];
    }
}

#pragma mark - Push Management and Registration
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
@end
