//
//  LCCoreLocationDelegate.h
//  Done
//
//  Created by Hansel Chung on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


// keys for notification user info
extern NSString * const kLCNewLocation;
extern NSString * const kLCLocationError;

// notification identifiers
extern NSString * const LCCoreLocationUpdateAvailable;
extern NSString * const LCCoreLocationUpdateFailed;


@interface LCCoreLocationDelegate : NSObject <CLLocationManagerDelegate> 
{
	CLLocationManager *locationManager;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)locationManager:(CLLocationManager *)manager
	  didUpdateToLocation:(CLLocation *)newLocation
		       fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	     didFailWithError:(NSError *)error;

+ (LCCoreLocationDelegate *)sharedInstance;

@end
