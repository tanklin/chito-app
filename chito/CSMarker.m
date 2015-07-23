//
//  CSMarker.m
//  CHiTO
//
//  Created by Tank Lin on 2015/7/22.
//  Copyright © 2015年 CHiTO. All rights reserved.
//

#import "CSMarker.h"

@implementation CSMarker

- (BOOL)isEqual:(id)object {
    CSMarker *otherMarker = (CSMarker *)object;

    if ([otherMarker isKindOfClass:[CSMarker class]]) {
        if (self.objectID == otherMarker.objectID) {
            return YES;
        }

    }
    return NO;
}

- (NSUInteger)hash {
    return [self.objectID hash];
}

@end
