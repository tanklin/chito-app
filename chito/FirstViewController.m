//
//  FirstViewController.m
//  CHiTO
//
//  Created by Tank Lin on 2015/7/24.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import "FirstViewController.h"
#import "RightViewController.h"
#import "CSMarker.h"

#import <AFNetworking.h>
#import <GoogleMaps/GoogleMaps.h>

#define favoriteURL_ @"http://www.chito.city/api/v1/restaurants"

@interface FirstViewController () <GMSMapViewDelegate, CLLocationManagerDelegate>
{
    GMSMapView *mapView_;
}

@property (copy, nonatomic) NSSet *markers;
@property BOOL isFirstTimeGetLocation;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstTimeGetLocation = YES;

    [self mapViewDidLoad];
//    [self favoriteMarkerData];
    [self getFavoriteRestaurantsJson];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
}

/// Observe User Loction
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"myLocation"] && [object isKindOfClass:[GMSMapView class]]) {
        if (self.isFirstTimeGetLocation) {
            [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:mapView_.myLocation.coordinate.latitude longitude:mapView_.myLocation.coordinate.longitude zoom:15]];
            self.isFirstTimeGetLocation = NO;
        }
    }
}

/// Load Google Map
- (void)mapViewDidLoad
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:mapView_.myLocation.coordinate.latitude
                                                            longitude:mapView_.myLocation.coordinate.longitude
                                                                 zoom:10];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    mapView_.accessibilityElementsHidden = NO;
    mapView_.settings.scrollGestures = YES;
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    mapView_.settings.rotateGestures = YES;

    mapView_.padding = UIEdgeInsetsMake(self.topLayoutGuide.length + 40, 0, self.bottomLayoutGuide.length + 10, 0);

    [mapView_ setMinZoom:8 maxZoom:18];

    [self.view addSubview:mapView_];
}



- (void)getFavoriteRestaurantsJson
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"category":@6,           //南港展覽館
                                 @"latitude":@25.055288,    //25.055288
                                 @"longitude":@121.6175001  //121.6175001
                                 };
    [manager POST:favoriteURL_ parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {

              NSData *favoriteRestaurantsData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
              NSLog(@"=== Get Favorite Restaurants === %@",responseObject);
              NSArray *json = [NSJSONSerialization JSONObjectWithData:favoriteRestaurantsData options:kNilOptions error:nil];
              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                  [self createMarkerObjectsWithJson:json];
              }];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"=== Get Favorite Restaurants Error === %@", error);
          }];
}


//- (void)favoriteMarkerData
//{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"yelpJsonTest" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
//                                                    options:kNilOptions
//                                                      error:nil];
//    NSLog(@"=== Favorite Markers === %@", json);
//    [self createMarkerObjectsWithJson:json];
//}


/// Create market with Networking Json
- (void)createMarkerObjectsWithJson:(NSObject *)json
{
    NSDictionary *dicJson = (NSDictionary*)json;
    NSMutableSet *mutableSet = [[NSMutableSet alloc] initWithSet:self.markers];
    for (NSDictionary *markerData in dicJson[@"data"]) {
        CSMarker *newMarker = [[CSMarker alloc] init];
        newMarker.objectID = [markerData[@"id"] stringValue];
        newMarker.title = markerData[@"name"];
        newMarker.snippet = markerData[@"tel"];
        newMarker.appearAnimation = kGMSMarkerAnimationPop;
        newMarker.infoWindowAnchor = CGPointMake(0.7, 0);
        newMarker.position = CLLocationCoordinate2DMake([markerData[@"latitude"] doubleValue],
                                                        [markerData[@"longitude"] doubleValue]);
        newMarker.icon = [UIImage imageNamed:@"CHiTO_Pin"];
        newMarker.map = nil;
        NSLog(@"hi");
        [mutableSet addObject:newMarker];
    }
    self.markers = [mutableSet copy];
    [self drawMarkers];
}

- (void)drawMarkers
{
    for (CSMarker *marker in self.markers) {
        if (marker.map == nil) {
            marker.map = mapView_;
        }
    }
    NSLog(@"hi2");
}

@end
