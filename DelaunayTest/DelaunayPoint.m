//
//  DelaunayPoint.m
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "DelaunayPoint.h"
#import "DelaunayTriangle.h"

@implementation DelaunayPoint
@synthesize neighbors;
@synthesize x, y;

+ (DelaunayPoint *)pointAtX:(float)newX andY:(float)newY
{
    DelaunayPoint *point = [[[self alloc] init] autorelease];
    point.neighbors = [NSMutableSet set];
    point.x = newX;
    point.y = newY;
    return point;
}

- (void) addNeighbor:(DelaunayPoint *)neighbor
{
    [self.neighbors addObject:neighbor];
    [neighbor.neighbors addObject:self];
}

@end
