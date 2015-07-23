//
//  MapViewController.m
//  CHiTO
//
//  Created by Tank Lin on 2015/7/19.
//  Copyright © 2015年 CHiTO. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CustomInfoWindow.h"
#import "CSMarker.h"

#define chitoURL_ @"http://www.chito.city/api/v1/restaurants.json"

@interface MapViewController () <GMSMapViewDelegate, CLLocationManagerDelegate>
{
    GMSMapView *mapView_;
}

@property (strong, nonatomic) NSURLSession *markerSession;
//@property (strong, nonatomic) GMSMapView *mapView_;
@property (copy, nonatomic) NSSet *markers;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:2*1024*1024 diskCapacity:10*1024*1024 diskPath:@"MarkerData"];
    self.markerSession = [NSURLSession sessionWithConfiguration:config];

    [self mapViewDidLoad];
//    [self setUpMarkerData];
//    [self mrtLocationData];
//    [self downloadMarkerData];
}

/// Download Marker Data
- (void)downloadMarkerData {
    NSURL *chitoURL = [NSURL URLWithString:chitoURL_];

    NSURLSessionDataTask *task = [self.markerSession dataTaskWithURL:chitoURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {


        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:0
                                                          error:nil];
//        NSLog(@"demo json: %@", json);

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self createMarkerObjectsWithJson:json];
        }];
    }];

    [task resume];
}

/// MRT location
/*
- (void)mrtLocationData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"yelpJsonTest" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json%@", json);
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self createMarkerObjectsWithJson:json];
    }];
}
*/

/// Create market with JSON
- (void)createMarkerObjectsWithJson:(NSArray *)json {
    NSMutableSet *mutableSet = [[NSMutableSet alloc] initWithSet:self.markers];
    for (NSDictionary *markerData in json) {
        CSMarker *newMarker = [[CSMarker alloc] init];
        newMarker.objectID = [markerData[@"id"] stringValue];
        newMarker.appearAnimation = [markerData[@"appearAnimation"] integerValue];
        newMarker.position = CLLocationCoordinate2DMake([markerData[@"lat"] doubleValue],
                                                        [markerData[@"lat"] doubleValue]);
        newMarker.title = markerData[@"title"];
        newMarker.snippet = markerData[@"snippet"];
        newMarker = nil;

        [mutableSet addObject:newMarker];
    }
    self.markers = [mutableSet copy];
    [self drawMarkers];
}



- (void)mapViewDidLoad
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:25.0517118
                                                            longitude:121.5319346
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    
    mapView_.delegate = self;
    
    mapView_.myLocationEnabled = YES;
    NSLog(@"User's location: %@", mapView_.myLocation);
    mapView_.accessibilityElementsHidden = NO;
    
    mapView_.settings.scrollGestures = YES;
    mapView_.settings.zoomGestures = YES;
    mapView_.settings.compassButton = YES;
    mapView_.settings.rotateGestures = YES;
    
    mapView_.padding = UIEdgeInsetsMake(self.topLayoutGuide.length + 5, 0, self.bottomLayoutGuide.length + 5, 0);
    
    [mapView_ setMinZoom:8 maxZoom:18];
    [self.view addSubview:mapView_];
}


/// Custom marker info window
/*
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    CustomInfoWindow *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"InfoWindow" owner:self options:nil] objectAtIndex:0];
    infoWindow.shopImage.image = [UIImage imageNamed:@"sort_cocoa"];
    infoWindow.shopImage.transform = CGAffineTransformMakeRotation(-.08);
    infoWindow.shopName.text = @"佳佳牛排";
    infoWindow.shopTel.text= @"02-2631-2436";
    infoWindow.shopAddress.text = @"台灣台北市內湖區東湖路119巷30號";
    
    return infoWindow;
}
*/

// Info window 舊寫法
/*
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    // info window setup
    UIView *infoWindow = [[UIView alloc] init];
    infoWindow.frame = CGRectMake(15, 0, 230, 227);
    infoWindow.backgroundColor = [UIColor clearColor];
    
    // custom Info Window
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customInfoWindow"]];
    [infoWindow addSubview:backgroundImage];
    
    
    // name label setup
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(14, 11, 175, 16);
    [infoWindow addSubview:titleLabel];
    titleLabel.text = marker.title;
    
    // tel label setup
    UILabel *snippetLabel = [[UILabel alloc] init];
    snippetLabel.frame = CGRectMake(14, 42, 175, 16);
    [infoWindow addSubview:snippetLabel];
    snippetLabel.text = marker.snippet;
    
    return infoWindow;
}
*/

/// Alert視窗
/*
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    NSString *message = [NSString stringWithFormat:@"你按的地點是%@", marker.title];
    UIAlertView *windowTapped = [[UIAlertView alloc]
                                 initWithTitle:@"餐廳限時優惠中"
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:@"點我詳情"
                             otherButtonTitles:nil];
    
    [windowTapped show];
}
*/

// 手刻Markers資料
/*
- (void)setUpMarkerData
{
    GMSMarker *testMarker = [[GMSMarker alloc] init];
    testMarker.position = CLLocationCoordinate2DMake(25.035981, 121.553327);
    testMarker.appearAnimation = kGMSMarkerAnimationPop;
//    testMarker.title = @"Taiwan";
//    testMarker.snippet = @"I love Google Map !!!";
//    testMarker.infoWindowAnchor = CGPointMake(0, 0);
    testMarker.infoWindowAnchor = CGPointMake(0.44f, 0.45f);
//    testMarker.groundAnchor = CGPointMake(1, 1);
    testMarker.icon = [UIImage imageNamed:@"CHiTO_Pin"];
    testMarker.map = nil;
    
    GMSMarker *testMarker2 = [[GMSMarker alloc] init];
    testMarker2.position = CLLocationCoordinate2DMake(25.04, 121.56);
    testMarker2.appearAnimation = kGMSMarkerAnimationPop;
    testMarker2.icon = [UIImage imageNamed:@"CHiTO_Pin"];
    testMarker2.map = nil;

    self.markers = [NSSet setWithObjects:testMarker, testMarker2, nil];
    
    [self drawMarkers];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
