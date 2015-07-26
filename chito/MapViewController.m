//
//  MapViewController.m
//  CHiTO
//
//  Created by Tank Lin on 2015/7/19.
//  Copyright © 2015年 CHiTO. All rights reserved.
//

#import "MapViewController.h"
#import <AFNetworking.h>
#import <GoogleMaps/GoogleMaps.h>
#import "CustomInfoWindow.h"
#import "CSMarker.h"
#import "RightViewController.h"

#define chitoURL_ @"http://www.chito.city/api/v1/restaurants.json"
#define testURL_ @"https://raw.githubusercontent.com/evenchange4/mrt_opendata/master/mrt.json"

@interface MapViewController () <GMSMapViewDelegate, CLLocationManagerDelegate>
{
    GMSMapView *mapView_;
}

@property (strong, nonatomic) NSURLSession *markerSession;
@property (copy, nonatomic) NSSet *markers;
@property BOOL isFirstTimeGetLocation;



//@property (strong, nonatomic) NSData *yelpData;

@end

@implementation MapViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"myLocation"] && [object isKindOfClass:[GMSMapView class]]) {
        if (self.isFirstTimeGetLocation) {
            [mapView_ animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:mapView_.myLocation.coordinate.latitude longitude:mapView_.myLocation.coordinate.longitude zoom:15]];
            self.isFirstTimeGetLocation = NO;
            NSLog(@"User's location: %@", (NSString*)mapView_.myLocation);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstTimeGetLocation = YES;
/// Session generate markers
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:2*1024*1024 diskCapacity:10*1024*1024 diskPath:@"MarkerData"];
    self.markerSession = [NSURLSession sessionWithConfiguration:config];

    [self mapViewDidLoad];


//    [self setUpMarkerData];
//    [self downloadMarkerData];
//    [self yelpLocationData];
    [self postJson];

}


/// POST and GET Restaurant Categories.
- (void)postJson
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"category":@3,
                                 @"latitude":@25.055288,
                                 @"longitude":@121.6175001
                                 };
    [manager POST:chitoURL_ parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"auth_token"]
//                                                 forKey:@"auto_token"];
        [[NSUserDefaults standardUserDefaults] synchronize];

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

/// Create market with JSON
- (void)createMarkerObjectsWithJson:(NSObject *)json {
    NSDictionary *dicJson = (NSDictionary*)json;
    NSMutableSet *mutableSet = [[NSMutableSet alloc] initWithSet:self.markers];
    for (NSDictionary *markerData in dicJson[@"data"]) {
        CSMarker *newMarker = [[CSMarker alloc] init];
        newMarker.objectID = [markerData[@"id"] stringValue];
        newMarker.title = markerData[@"name"];
        newMarker.snippet = markerData[@"tel"];
        newMarker.appearAnimation = kGMSMarkerAnimationPop;
        newMarker.position = CLLocationCoordinate2DMake([markerData[@"latitude"] doubleValue],
                                                        [markerData[@"longtitude"] doubleValue]);
        newMarker.icon = [UIImage imageNamed:@"CHiTO_Pin"];
        newMarker.map = nil;

        [mutableSet addObject:newMarker];
    }
    self.markers = [mutableSet copy];
    [self drawMarkers];
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    
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

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    NSString *tel = [NSString stringWithFormat:@"%@", marker.snippet];
    NSString *message = [NSString stringWithFormat:@"您撥打的餐廳是%@", marker.title];
    UIAlertView *windowTapped = [[UIAlertView alloc]
                                 initWithTitle:tel
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:@"確定撥打電話"
                             otherButtonTitles:nil];
    
    [windowTapped show];
}


/// 手刻Markers資料
/*
- (void)setUpMarkerData
{
    GMSMarker *testMarker = [[GMSMarker alloc] init];
    testMarker.position = CLLocationCoordinate2DMake(25.051775, 121.534016);
    testMarker.appearAnimation = kGMSMarkerAnimationPop;
    testMarker.title = @"品田牧場";
    testMarker.snippet = @"0225077279";
//    testMarker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
    testMarker.icon = [UIImage imageNamed:@"CHiTO_Pin"];
//    testMarker.icon = [self imageFromView:[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] [0]];
    testMarker.map = mapView_;
    
    GMSMarker *testMarker2 = [[GMSMarker alloc] init];
    testMarker2.position = CLLocationCoordinate2DMake(25.050643, 121.532047);
    testMarker2.appearAnimation = kGMSMarkerAnimationPop;
    testMarker2.title = @"京東洋食燒烤";
    testMarker2.snippet = @"0225236737";
//    testMarker2.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
    testMarker2.icon = [UIImage imageNamed:@"CHiTO_Pin"];
    testMarker2.map = mapView_;

//    self.markers = [NSSet setWithObjects:testMarker, testMarker2, nil];

//    [self drawMarkers];
}
*/

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
