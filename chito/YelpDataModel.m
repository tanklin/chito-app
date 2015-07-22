//
//  YelpDataModel.m
//  CHiTO
//
//  Created by Tank Lin on 2015/7/22.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import "YelpDataModel.h"
#import "ViewController.h"
#import <AFNetworking.h>

#define chitoURL @"http://www.chito.city/api/v1/restaurant.json"

@implementation YelpDataModel

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.yelpDownloadDictionary = [[NSDictionary alloc] init];
    }
    return self;
}


- (void)fetchYelpData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:chitoURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        _garbagesArray = responseObject[@"name"];
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)postFacebookData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"garbage":@{
                                 @"name":@"陶吉吉",
                                 @"description":@"愛很簡單"}
                                 };
    [manager POST:chitoURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"auth_token"] forKey:@"auto_token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}



@end
