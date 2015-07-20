//
//  GlobalVariable.h
//  CHiTO
//
//  Created by Tank Lin on 2015/7/20.
//  Copyright (c) 2015年 CHiTO. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GlobalVariable;
@protocol gvDelegate <NSObject>
@required
- (void)receiveUserID:(GlobalVariable *)receiveUserID;
@end

@interface GlobalVariable : NSObject

@property (strong, nonatomic) id<gvDelegate> delegate;

@property (weak, nonatomic) NSString *userIDtoSave;

@end
