//
//  MapViewController.m
//  CHiTO
//
//  Created by Tank Lin on 2015/7/19.
//  Copyright © 2015年 CHiTO. All rights reserved.
//

#import "MapViewController.h"
#import "CustomInfoWindow.h"
#import "CSMarker.h"
#import "RightViewController.h"
#import "GV.h"
#import <SIAlertView/SIAlertView.h>
#import <AFNetworking.h>
#import <GoogleMaps/GoogleMaps.h>

#define chitoURL_ @"http://www.chito.city/api/v1/restaurants"

#define visit @"http://www.chito.city/api/v1/visit" //點marker 傳 user_id 及 res_id
#define visit_get @"http://www.chito.city/api/v1/visit_get" //最近瀏覽 user_id

#define favorite_get @"http://www.chito.city/api/v1/favorite_get" //取得收藏的資料 user_id
#define favorite_Like @"http://www.chito.city/api/v1/favorite_like"  //加入收藏 user_id 及 res_id

#define favorite_no_more @"http://www.chito.city/api/v1/favorite_no_more"  //取消收藏 user_id 及 res_id
#define favorite_dislike @"http://www.chito.city/api/v1/favorite_dislike"  //不再看到餐廳 user_id 及 res_id


@interface MapViewController () <GMSMapViewDelegate, CLLocationManagerDelegate>
{
    GMSMapView *mapView_;
    double kLati;
    double kLong;
    id kkLati;
    NSString *tel;
}

@property (strong, nonatomic) NSURLSession *markerSession;
@property (copy, nonatomic) NSSet *markers;
@property BOOL isFirstTimeGetLocation;

//@property (assign, nonatomic) id receiveIndexpath;

//@property (strong, nonatomic) NSData *yelpData;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstTimeGetLocation = YES;
/// Session generate markers
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:2*1024*1024 diskCapacity:10*1024*1024 diskPath:@"MarkerData"];
    self.markerSession = [NSURLSession sessionWithConfiguration:config];

    [self mapViewDidLoad];


    [self setUpMarkerData];
//    [self downloadMarkerData];
//    [self yelpLocationData];
    [self postJson];

    NSLog(@"Restaurant Type: %@", kID);
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
            kLati = mapView_.myLocation.coordinate.latitude;
            kLong = mapView_.myLocation.coordinate.longitude;
            NSLog(@"User's location:%f,%f", kLati, kLong);
        }
    }
}

/// POST and GET Restaurant Categories.
- (void)postJson
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"category":kID,           //南港展覽館
                                 @"latitude":@25.055288,    //25.055288
                                 @"longitude":@121.6175001  //121.6175001
                                 };
    [manager POST:chitoURL_ parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"auth_token"]
//                                                 forKey:@"auto_token"];
//        [[NSUserDefaults standardUserDefaults] synchronize];

//          NSData *yelpData_ = (NSData *)responseObject;
          NSData *yelpData_ = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];

            NSArray *json = [NSJSONSerialization JSONObjectWithData:yelpData_
                                                            options:kNilOptions
                                                              error:nil];

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self createMarkerObjectsWithJson:json];
            }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"=== Post Error === %@", error);
    }];
}

/// Download Marker Data
//- (void)downloadMarkerData {
//    NSURL *chitoURL = [NSURL URLWithString:testURL_];
//
//    NSURLSessionDataTask *task = [self.markerSession dataTaskWithURL:chitoURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
//
//
//        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
//                                                        options:0
//                                                          error:nil];
//        NSLog(@"### Download json ### %@", json);
//
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self createMarkerObjectsWithJson:json];
//        }];
//    }];
//
//    [task resume];
//}


/// MRT location
/*
- (void)yelpLocationData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"yelpJsonTest" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"===Yelp Test JSON=== %@", json);
    [self createMarkerObjectsWithJson:json];
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//
//    }];
}
*/

/// Create market with Networking Json
- (void)createMarkerObjectsWithJson:(NSObject *)json {
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
    
    mapView_.padding = UIEdgeInsetsMake(self.topLayoutGuide.length + 10, 0, self.bottomLayoutGuide.length + 10, 0);
    
    [mapView_ setMinZoom:8 maxZoom:18];

    [self.view addSubview:mapView_];
}


/// 用nib客製marker infoWindow
/*
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    CustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
//    infoWindow.frame = CGRectMake(150, 200, 230, 227);
    infoWindow.shopImage.image = [UIImage imageNamed:@"sort_cocoa"];
//    infoWindow.shopImage.transform = CGAffineTransformMakeRotation(-.08);
    infoWindow.shopName.text = @"佳佳牛排";
    infoWindow.shopTel.text= @"02-2631-2436";
    infoWindow.shopAddress.text = @"台灣台北市內湖區東湖路119巷30號";
    
    return infoWindow;
}
*/

/// 手刻marker InfoWindow
/*
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    // info window setup
    UIView *infoWindow = [[UIView alloc] init];
    infoWindow.frame = CGRectMake(100, 250, 500, 270);
    infoWindow.contentMode = UIViewContentModeScaleAspectFit;
    infoWindow.backgroundColor = [UIColor clearColor];
    
    // custom Info Window
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customInfoWindow"]];
    [infoWindow addSubview:backgroundImage];
    
    
    // shopName label setup
    UILabel *shopName = [[UILabel alloc] init];
    shopName.frame = CGRectMake(100, 10, 175, 16);
    [infoWindow addSubview:shopName];
    shopName.text = marker.title;
    
    // shopTel label setup
    UILabel *shopTel = [[UILabel alloc] init];
    shopTel.frame = CGRectMake(100, 45, 175, 16);
    [infoWindow addSubview:shopTel];
    shopTel.text = marker.snippet;

    //shopAddress
    UILabel *shopAddress = [[UILabel alloc] init];
    shopAddress.frame = CGRectMake(14, 42, 175, 16);
    [infoWindow addSubview:shopAddress];
    shopAddress.text = @"台灣台北市內湖區東湖路119巷30號";

    // shopImage label setup
    UIImageView *shopView = [[UIImageView alloc] init];
    shopView.frame = CGRectMake(10, 10, 90, 90);
    shopView.contentMode = UIViewContentModeScaleAspectFit;
    [infoWindow addSubview:shopView];
    shopView.image = [UIImage imageNamed:@"sort_cocoa"];

    return infoWindow;
}
*/
/*
- (UIImage *)imageFromView:(UIView *) view
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
*/

/// Alert視窗

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    tel = [NSString stringWithFormat:@"%@", marker.snippet];
    NSString *message = [NSString stringWithFormat:@"您撥打的餐廳是%@", marker.title];
//    UIAlertView *windowTapped = [[UIAlertView alloc]
//                                 initWithTitle:tel
//                                       message:message
//                                      delegate:nil
//                             cancelButtonTitle:@"取消"
//                             otherButtonTitles:@"確定撥打電話", nil];
//    
//    [windowTapped show];

    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:tel andMessage:message];

    [alertView addButtonWithTitle:@"確定撥打電話"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              [self callServices];
                              NSLog(@"Button1 Clicked");
                          }];
    [alertView addButtonWithTitle:@"再看看"
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Button2 Clicked");
                          }];
    //    [alertView addButtonWithTitle:@"Button3"
    //                             type:SIAlertViewButtonTypeDestructive
    //                          handler:^(SIAlertView *alert) {
    //                              NSLog(@"Button3 Clicked");
    //                          }];

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
    
    alertView.transitionStyle = SIAlertViewTransitionStyleDropDown;
    
    [alertView show];
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

/// 手刻Markers資料
- (void)setUpMarkerData
{
    GMSMarker *markerTank = [[GMSMarker alloc] init];
    markerTank.position = CLLocationCoordinate2DMake(24.163397, 120.662579);
    markerTank.appearAnimation = kGMSMarkerAnimationPop;
    markerTank.title = @"我是Tank, I❤️CODE";
    markerTank.snippet = @"iOS Developer, I need a job";
//    testMarker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
    markerTank.icon = [UIImage imageNamed:@"tank_marker"];
//    testMarker.icon = [self imageFromView:[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] [0]];
    markerTank.map = mapView_;
    
//    GMSMarker *testMarker2 = [[GMSMarker alloc] init];
//    testMarker2.position = CLLocationCoordinate2DMake(25.050643, 121.532047);
//    testMarker2.appearAnimation = kGMSMarkerAnimationPop;
//    testMarker2.title = @"京東洋食燒烤";
//    testMarker2.snippet = @"0225236737";
////    testMarker2.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
//    testMarker2.icon = [UIImage imageNamed:@"CHiTO_Pin"];
//    testMarker2.map = mapView_;

//    self.markers = [NSSet setWithObjects:testMarker, testMarker2, nil];

//    [self drawMarkers];
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
