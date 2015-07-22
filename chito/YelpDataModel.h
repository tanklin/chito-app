//
//  YelpDataModel.h
//  CHiTO
//
//  Created by Tank Lin on 2015/7/22.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YelpDataModelDelegate <NSObject>


@end


@interface YelpDataModel : NSObject

@property (strong, nonatomic) NSDictionary *yelpDownloadDictionary;

- (void)fetchYelpData;
- (void)postFacebookData;

@end
