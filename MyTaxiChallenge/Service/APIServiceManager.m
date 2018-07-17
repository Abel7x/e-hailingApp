//
//  APIServiceManager.m
//  MyTaxiChallenge
//
//  Created by Ricardo Abel Martinez Vivanco on 7/17/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

#import "APIServiceManager.h"

@implementation APIServiceManager

#pragma mark Internal use methods

- (AFHTTPSessionManager*)getNetworkingManager{
    if (self.networkingManager == nil) {
        self.networkingManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        self.networkingManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.networkingManager.responseSerializer.acceptableContentTypes = [self.networkingManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"application/json", @"text/json"]];
    }
    return self.networkingManager;
}

- (NSString*)getError:(NSError*)error {
    if (error != nil) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
        if (responseObject != nil && [responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"message"] != nil && [[responseObject objectForKey:@"message"] length] > 0) {
            return [responseObject objectForKey:@"message"];
        }
    }
    return @"Server Error. Please try again later";
}

#pragma mark API Calls

- (void)getVehiclesFromNePoint:(CLLocation*)nePoint swPoint:(CLLocation*)swPoint success:(NetworkManagerSuccess)success failure:(NetworkManagerFailure)failure {
    
    NSString *lat1 = [NSString stringWithFormat:@"%f",nePoint.coordinate.latitude];
    NSString *lon1 = [NSString stringWithFormat:@"%f",swPoint.coordinate.longitude];
    
    NSString *lat2 = [NSString stringWithFormat:@"%f",swPoint.coordinate.latitude];
    NSString *lon2 = [NSString stringWithFormat:@"%f",nePoint.coordinate.longitude];
    ;
    
    NSDictionary *params = @{
                             @"p1Lat":lat1,
                             @"p1Lon":lon1,
                             @"p2Lat":lat2,
                             @"p2Lon":lon2
                             };
    [[self getNetworkingManager] GET:@"/PoiService/poi/v1" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if (success != nil) {
            success(responseObject);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSString *errorMessage = [self getError:error];
        if (failure != nil) {
            failure(errorMessage, ((NSHTTPURLResponse*)operation.response).statusCode);
        }
    }];
}

- (void)getVehiclesFromNePoint:(NetworkManagerSuccess)success failure:(NetworkManagerFailure)failure{
    CLLocation* nePoint = [[CLLocation alloc] initWithLatitude:53.694865 longitude:10.099891];
    CLLocation* swPoint = [[CLLocation alloc] initWithLatitude:53.394655 longitude:9.757589];
    [self getVehiclesFromNePoint:nePoint swPoint:swPoint success:success failure:failure];
}
@end
