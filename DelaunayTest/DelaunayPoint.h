//
//  DelaunayPoint.h
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DelaunayPoint : NSObject {
    NSMutableSet *neighbors;
    NSValue *point;
}

@property (nonatomic, retain) NSMutableSet *neighbors;
@property (nonatomic) float x;
@property (nonatomic) float y;

+ (DelaunayPoint *) pointAtX:(float)x andY:(float)y;
- (void) addNeighbor:(DelaunayPoint *)neighbor;

@end
