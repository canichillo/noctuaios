//
//  SCLocationController.h
//  Noctua
//
//  Created by Alberto Javier Sánchez Peralta on 28/7/14.
//  Copyright (c) 2014 Alberto Javier Sánchez Peralta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SPUtilidades.h"

@interface LocationService : NSObject <CLLocationManagerDelegate>

+(LocationService *) sharedInstance;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

-(void) startUpdatingLocation;
-(void) stopUpdatingLocation;

@end
