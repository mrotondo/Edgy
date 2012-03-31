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

@interface DelaunayTriangulation : NSObject <NSCopying> {
 
    NSMutableSet *points;
    NSMutableSet *edges;
    NSMutableSet *triangles;
}

@property (nonatomic, retain) NSMutableSet *points;
@property (nonatomic, retain) NSMutableSet *edges;
@property (nonatomic, retain) NSMutableSet *triangles;
@property (nonatomic, retain) NSSet *frameTrianglePoints;

+ (DelaunayTriangulation *)triangulation;
+ (DelaunayTriangulation *)triangulationWithSize:(CGSize)size;
- (BOOL)addPoint:(DelaunayPoint *)newPoint withColor:(UIColor *)color;
- (DelaunayTriangle *)triangleContainingPoint:(DelaunayPoint *)point;
- (void)enforceDelaunayProperty;
- (NSDictionary*)voronoiCells;
- (void)interpolateWeightsWithPoint:(DelaunayPoint *)point;
- (void)print;

@end
