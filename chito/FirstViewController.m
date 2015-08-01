//
//  FirstViewController.m
//  CHiTO
//
//  Created by Tank Lin on 2015/7/24.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import "FirstViewController.h"
#import "RightViewController.h"
#import "MBProgressHUD.h"
#import "CSMarker.h"
#import "GV.h"
#import <AFNetworking.h>
#import <GoogleMaps/GoogleMaps.h>
#import <SIAlertView/SIAlertView.h>

@interface FirstViewController () <GMSMapViewDelegate, CLLocationManagerDelegate>
{
    GMSMapView *mapView_;
    NSString *tel;
}

@property (copy, nonatomic) NSSet *markers;
@property BOOL isFirstTimeGetLocation;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstTimeGetLocation = YES;
    [self progressHUD];
    [self mapViewDidLoad];
//    [self favoriteMarkerData];
    self.title = @"我的收藏";
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor blackColor]];
    [bar setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:111.0/255.0 blue:28.0/255.0 alpha:1]];
    [bar setTranslucent:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getFavoriteRestaurantsJson];
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

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    tel = [NSString stringWithFormat:@"%@", marker.snippet];

    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:marker.title
                                                     andMessage:tel];
    [alertView addButtonWithTitle:@"撥打電話"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              [self callServices];
                              NSLog(@"Call Button Clicked");
                          }];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Cancel Button Clicked");
                          }];

    alertView.willShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willShowHandler", alertView);
    };
    alertView.didShowHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didShowHandler", alertView);
    };
    alertView.willDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, willDismissHandler", alertView);
    };
    alertView.didDismissHandler = ^(SIAlertView *alertView) {
        NSLog(@"%@, didDismissHandler", alertView);
    };

    alertView.transitionStyle = SIAlertViewTransitionStyleFade;
    
    [alertView show];

    return YES;
}

- (void)callServices
{
    NSString *temp = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *phoneURL = [NSString stringWithFormat:@"tel://%@", temp];
    NSLog(@"Call %@", phoneURL);
    BOOL ifCall = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURL]];
    if (!ifCall) {
        NSLog(@"calling error");
    }
}

- (void)progressHUD
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Do something...
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)getFavoriteRestaurantsJson
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{
                                 @"auth_token": [defaults stringForKey:kAuth_token],
                                 @"user_id":[defaults stringForKey:kUser_id]
                                 };
    [manager POST:kFavorite_get parameters:parameters
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [mapView_ removeObserver:self forKeyPath:@"myLocation"];
}


@end
