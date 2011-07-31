//
//  DelaunayEdge.m
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/20/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "DelaunayEdge.h"
#import "DelaunayTriangle.h"
#import "DelaunayPoint.h"

@interface DelaunayEdge ()

- (float) determinant:(float[3][3])matrix;

@end

@implementation DelaunayEdge
@synthesize triangles, points;

+ (DelaunayEdge *)edgeWithPoints:(NSArray *)points
{
    DelaunayEdge *edge = [[[self alloc] init] autorelease];
    edge.points = points;
    
    for (DelaunayPoint *point in edge.points)
    {
        [point.edges addObject:edge];
    }
    
    edge.triangles = [NSMutableSet setWithCapacity:3];
    
    return edge;
}

- (DelaunayTriangle *)neighborOf:(DelaunayTriangle *)triangle
{
    // There should only ever be 2 triangles in self.triangles
    for (DelaunayTriangle *edgeTriangle in self.triangles)
    {
        if (edgeTriangle != triangle)
            return edgeTriangle;
    }
    return nil;
}

- (DelaunayPoint *)otherPoint:(DelaunayPoint *)point
{
    if ([self.points objectAtIndex:0] == point)
        return [self.points objectAtIndex:1];
    else if ([self.points objectAtIndex:1] == point)
        return [self.points objectAtIndex:0];
    else
    {
        NSLog(@"ASKED FOR THE OTHER POINT WITH A POINT THAT IS NOT IN THIS EDGE");
        return nil;
    }
}

- (BOOL)pointOnLeft:(DelaunayPoint*)point withStartPoint:(DelaunayPoint *)startPoint
{
    if (![self.points containsObject:startPoint])
    {
        NSLog(@"ASKED IF POINT ON LEFT WITH A START POINT THAT IS NOT IN THIS EDGE");
        return NO;
    }
    
    DelaunayPoint *p0 = [self.points objectAtIndex:0];
    DelaunayPoint *p1 = [self.points objectAtIndex:1];
    
    float check[3][3] = { 
        {p0.x, p0.y, 1},
        {p1.x, p1.y, 1},
        {point.x, point.y, 1}
    };
    
    float det = [self determinant:check];
    
    if (startPoint == p0)
        return det < 0;
    else
        return det > 0;
        
}

- (DelaunayTriangle *)triangleSharingEdge:(DelaunayEdge *)otherEdge
{
    NSMutableSet *sharedTriangles = [self.triangles mutableCopy];
    [sharedTriangles intersectSet:otherEdge.triangles];
    
    if ([sharedTriangles count] == 0)
    {
        NSLog(@"ASKED FOR THE SHARED TRIANGLE WITH AN EDGE THAT DOESN'T SHARE ANY TRIANGLES WITH THIS EDGE");
        return nil;
    }
    if ([sharedTriangles count] > 1)
    {
        NSLog(@"SOMEHOW THIS EDGE SHARES MORE THAN ONE TRIANGLE WITH THE OTHER EDGE?!");
        return nil;
    }
    return [sharedTriangles anyObject];
}

- (void)remove
{
    for (DelaunayPoint *point in self.points)
    {
        [point.edges removeObject:self];
    }
}

- (float) determinant:(float[3][3])matrix
{
    float a = matrix[0][0];
    float b = matrix[0][1];
    float c = matrix[0][2];
    float d = matrix[1][0];
    float e = matrix[1][1];
    float f = matrix[1][2];
    float g = matrix[2][0];
    float h = matrix[2][1];
    float i = matrix[2][2];
    
    return (a * e * i -
            a * f * h -
            b * d * i +
            b * f * g +
            c * d * h -
            c * e * g);
}

@end
