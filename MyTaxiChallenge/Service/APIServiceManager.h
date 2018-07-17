//
//  APIServiceManager.h
//  MyTaxiChallenge
//
//  Created by Ricardo Abel Martinez Vivanco on 7/17/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

#define BASE_URL @"https://poi-api.mytaxi.com" //This could later be added on a plist for manage different envs

typedef void (^NetworkManagerSuccess)(id responseObject);
typedef void (^NetworkManagerFailure)(NSString *failureReason, NSInteger statusCode);

@interface APIServiceManager : NSObject

- (void)getVehiclesFromNePoint:(CLLocation*)nePoint swPoint:(CLLocation*)swPoint success:(NetworkManagerSuccess)success failure:(NetworkManagerFailure)failure;
- (void)getVehiclesFromNePoint:(NetworkManagerSuccess)success failure:(NetworkManagerFailure)failure;

@property (nonatomic, strong) AFHTTPSessionManager *networkingManager;

@end
