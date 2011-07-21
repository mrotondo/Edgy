//
//  DelaunayTriangulation.h
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DelaunayPoint;
@class DelaunayTriangle;

@interface DelaunayTriangulation : NSObject {
 
    NSMutableSet *triangles;
    NSSet *frameTriangleEdges;
}

@property (nonatomic, retain) NSMutableSet *triangles;
@property (nonatomic, retain) NSSet *frameTriangleEdges;

+ (DelaunayTriangulation *)triangulationWithSize:(CGSize)size;
- (void)addPoint:(DelaunayPoint *)newPoint;
- (DelaunayTriangle *)triangleContainingPoint:(DelaunayPoint *)point;
- (void)enforceDelaunayProperty;

@end
