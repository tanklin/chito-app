//
//  GV.h
//  CHiTO
//
//  Created by Tank Lin on 2015/7/26.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GV : NSObject

#define kRestaurants @"http://chito.city/api/v1/restaurants"

#define kLogin @"http://www.chito.city/api/v1/login"

#define kVisit @"http://www.chito.city/api/v1/visit" //點marker 傳 user_id 及 res_id
#define kVisit_get @"http://www.chito.city/api/v1/visit_get" //最近瀏覽 user_id

#define kFavorite_get @"http://www.chito.city/api/v1/favorite_get" //取得收藏的資料 user_id
#define kFavorite_Like @"http://www.chito.city/api/v1/favorite_like"  //加入收藏 user_id 及 res_id

#define kFavorite_no_more @"http://www.chito.city/api/v1/favorite_no_more"  //取消收藏 user_id 及 res_id
#define kFavorite_dislike @"http://www.chito.city/api/v1/favorite_dislike"  //不再看到餐廳 user_id 及 res_id

#define TEST_REST @"http://4c5f9266.ngrok.com/api/v1/restaurants"
#define TEST_LOGIN @"http://4c5f9266.ngrok.com/api/v1/login"
#define TEST_VISIT @"http://4c5f9266.ngrok.com/api/v1/visit"
#define TEST_VISIT_GET @"http://4c5f9266.ngrok.com/api/v1/visit_get"
#define TEST_FAVORITE_LIKE @"http://4c5f9266.ngrok.com/api/v1/favorite_like"
#define TEST_FAVORITE_GET @"http://4c5f9266.ngrok.com/api/v1/favorite_get"

extern NSInteger kID;
extern int *kCategoryID;
//extern id kLati; // 緯度
//extern id kLong; // 經度

extern NSString *kUser_id;
extern NSString *kAuth_token;
extern NSString *kRes_id;
@end
