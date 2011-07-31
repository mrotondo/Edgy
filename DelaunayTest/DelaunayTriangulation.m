//
//  DelaunayTriangulation.m
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "DelaunayTriangulation.h"
#import "DelaunayPoint.h"
#import "DelaunayEdge.h"
#import "DelaunayTriangle.h"
#import "VoronoiCell.h"

@interface DelaunayTriangulation ()

- (void)removeTriangle:(DelaunayTriangle *)triangle;

@end

@implementation DelaunayTriangulation
@synthesize points;
@synthesize triangles;
@synthesize frameTriangleEdges, frameTrianglePoints;

+ (DelaunayTriangulation *)triangulationWithSize:(CGSize)size
{
    DelaunayTriangulation *dt = [[[self alloc] init] autorelease];
    
    // ADD FRAME TRIANGLE
    float w = size.width;
    float h = size.height;
    DelaunayPoint *p1 = [DelaunayPoint pointAtX:-10000 andY:0];
    DelaunayPoint *p2 = [DelaunayPoint pointAtX:w * 0.5 andY:10000];
    DelaunayPoint *p3 = [DelaunayPoint pointAtX:10000 andY:0];
    
//    DelaunayPoint *p1 = [DelaunayPoint pointAtX:w * 0.25 andY:h * 0.25];
//    DelaunayPoint *p2 = [DelaunayPoint pointAtX:w * 0.5 andY:h * 0.75];
//    DelaunayPoint *p3 = [DelaunayPoint pointAtX:w * 0.75 andY:h * 0.25];
    
    DelaunayEdge *e1 = [DelaunayEdge edgeWithPoints:[NSArray arrayWithObjects:p1, p2, nil]];
    DelaunayEdge *e2 = [DelaunayEdge edgeWithPoints:[NSArray arrayWithObjects:p2, p3, nil]];
    DelaunayEdge *e3 = [DelaunayEdge edgeWithPoints:[NSArray arrayWithObjects:p3, p1, nil]];
    
    DelaunayTriangle *triangle = [DelaunayTriangle triangleWithEdges:[NSArray arrayWithObjects:e1, e2, e3, nil] andStartPoint:p1];
    dt.frameTriangleEdges = [NSSet setWithObjects:e1, e2, e3, nil];
    dt.frameTrianglePoints = [NSSet setWithObjects:p1, p2, p3, nil];
    
    dt.triangles = [NSMutableSet setWithObject:triangle];

    dt.points = [NSMutableSet setWithObjects:p1, p2, p3, nil];
    
    return dt;
}

- (id)copyWithZone:(NSZone *)zone
{
    // TODO(mrotondo): Implement this in maybe any other way than the least efficient way possible?!
    DelaunayTriangulation *dt = [DelaunayTriangulation triangulationWithSize:CGSizeMake(1000, 1000)];
    for ( DelaunayPoint *point in self.points )
    {
        if ( [self.frameTrianglePoints containsObject:point] )
            continue;
        [dt addPoint:[DelaunayPoint pointAtX:point.x andY:point.y withUUID:point.UUIDString]];
    }
    return dt;
}

- (void)removeTriangle:(DelaunayTriangle *)triangle
{
    [triangle remove];
    [self.triangles removeObject:triangle];
}

- (BOOL)addPoint:(DelaunayPoint *)newPoint
{
    DelaunayTriangle * triangle = [[[self triangleContainingPoint:newPoint] retain] autorelease];
    if (triangle != nil)
    {
        [self.points addObject:newPoint];
        
        [self removeTriangle:triangle];
        
        DelaunayEdge *e1 = [triangle.edges objectAtIndex:0];
        DelaunayEdge *e2 = [triangle.edges objectAtIndex:1];
        DelaunayEdge *e3 = [triangle.edges objectAtIndex:2];
        
        DelaunayPoint *edgeStartPoint = triangle.startPoint;
        DelaunayEdge *new1 = [DelaunayEdge edgeWithPoints:[NSArray arrayWithObjects:edgeStartPoint, newPoint, nil]];
        edgeStartPoint = [e1 otherPoint:edgeStartPoint];
        DelaunayEdge *new2 = [DelaunayEdge edgeWithPoints:[NSArray arrayWithObjects:edgeStartPoint, newPoint, nil]];
        edgeStartPoint = [e2 otherPoint:edgeStartPoint];
        DelaunayEdge *new3 = [DelaunayEdge edgeWithPoints:[NSArray arrayWithObjects:edgeStartPoint, newPoint, nil]];
        
        // Use start point and counter-clockwise ordered edges to enforce counter-clockwiseness in point-containment checking
        DelaunayTriangle * e1Triangle = [DelaunayTriangle triangleWithEdges:[NSArray arrayWithObjects:new1, e1, new2, nil] andStartPoint:newPoint];
        DelaunayTriangle * e2Triangle = [DelaunayTriangle triangleWithEdges:[NSArray arrayWithObjects:new2, e2, new3, nil] andStartPoint:newPoint];
        DelaunayTriangle * e3Triangle = [DelaunayTriangle triangleWithEdges:[NSArray arrayWithObjects:new3, e3, new1, nil] andStartPoint:newPoint];
        
        [self.triangles addObject:e1Triangle];        
        [self.triangles addObject:e2Triangle];        
        [self.triangles addObject:e3Triangle];
        
        [self enforceDelaunayProperty];
        return YES;
    }
    return NO;
}

- (DelaunayTriangle *)triangleContainingPoint:(DelaunayPoint *)point
{
    for (DelaunayTriangle* triangle in self.triangles)
    {
        if ([triangle containsPoint:point])
        {
            return triangle;
        }
    }
    return nil;
}

// TODO(mrotondo): Clean this up! The code should not be copy/pasted 3x like it is :(:( It should also modify the list in place somehow
- (void)enforceDelaunayProperty
{
    bool hadToFlip;
    
    do {
        hadToFlip = NO;
        
        NSMutableSet *trianglesToRemove = [NSMutableSet set];
        NSMutableSet *trianglesToAdd = [NSMutableSet set];
        
        // Flip all non-Delaunay edges
        for (DelaunayTriangle *triangle in self.triangles)
        {
            CGPoint circumcenter = [triangle circumcenter];
            
            float radius = sqrtf(powf(triangle.startPoint.x - circumcenter.x, 2) + powf(triangle.startPoint.y - circumcenter.y, 2));
            
            for (DelaunayEdge *sharedEdge in triangle.edges)
            {
                DelaunayTriangle *neighborTriangle = [sharedEdge neighborOf:triangle];
                if (neighborTriangle != nil)
                {
                    // Find the non-shared point in the other triangle
                    DelaunayPoint *nonSharedPoint = [neighborTriangle pointNotInEdge:sharedEdge];
                    if (sqrtf(powf(nonSharedPoint.x - circumcenter.x, 2) + powf(nonSharedPoint.y - circumcenter.y, 2)) < radius )
                    {
                        // If the non-shared point is within the circumcircle of this triangle, flip to share the other two points
                        [trianglesToRemove addObject:triangle];
                        [trianglesToRemove addObject:neighborTriangle];

                        // Get the edges before & after the shared edge in the triangle
                        DelaunayEdge *beforeEdge = [triangle edgeStartingWithPoint:[triangle pointNotInEdge:sharedEdge]];
                        DelaunayEdge *afterEdge = [triangle edgeEndingWithPoint:[triangle pointNotInEdge:sharedEdge]];

                        DelaunayEdge *newEdge = [DelaunayEdge edgeWithPoints:[NSArray arrayWithObjects:nonSharedPoint, [triangle pointNotInEdge:sharedEdge], nil]];

                        // Get the edges before & after the shared edge in the neighbor triangle
                        DelaunayEdge *neighborBeforeEdge = [neighborTriangle edgeStartingWithPoint:[neighborTriangle pointNotInEdge:sharedEdge]];
                        DelaunayEdge *neighborAfterEdge = [neighborTriangle edgeEndingWithPoint:[neighborTriangle pointNotInEdge:sharedEdge]];
                        
                        DelaunayTriangle *newTriangle1 = [DelaunayTriangle triangleWithEdges:[NSArray arrayWithObjects:newEdge, beforeEdge, neighborAfterEdge, nil]
                                                                               andStartPoint:nonSharedPoint ];
                        
                        DelaunayTriangle *newTriangle2 = [DelaunayTriangle triangleWithEdges:[NSArray arrayWithObjects:neighborBeforeEdge, afterEdge, newEdge, nil]
                                                                               andStartPoint:nonSharedPoint];
                        
                        [trianglesToAdd addObject:newTriangle1];
                        [trianglesToAdd addObject:newTriangle2];
                        [sharedEdge remove];
                        hadToFlip = YES;
                        break;
                    }
                }
            }
            if (hadToFlip)
                break;
        }
        
        for (DelaunayTriangle* triangleToRemove in trianglesToRemove)
        {
            [self removeTriangle:triangleToRemove];
        }
        for (DelaunayTriangle* triangleToAdd in trianglesToAdd)
        {
            [self.triangles addObject:triangleToAdd];
        }
    } while (hadToFlip);
}

- (NSDictionary*)voronoiCells
{
    NSMutableDictionary *cells = [NSMutableDictionary dictionary];
    for (DelaunayPoint *point in self.points)
    {
        // Don't add voronoi cells at the frame triangle points
        if ([self.frameTrianglePoints containsObject:point])
            continue;
        
        NSArray *edges = [point counterClockwiseEdges];
        NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:[edges count]];
        DelaunayEdge *prevEdge = [edges lastObject];
        for (DelaunayEdge *edge in edges)
        {
            DelaunayTriangle *sharedTriangle = [edge triangleSharingEdge:prevEdge];
            [nodes addObject:[NSValue valueWithCGPoint:[sharedTriangle circumcenter]]];
            prevEdge = edge;
        }
        //[cells addObject:[VoronoiCell voronoiCellAtSite:point withNodes:nodes]];
        [cells setObject:[VoronoiCell voronoiCellAtSite:point withNodes:nodes] forKey:point];
    }
    return cells;
}

- (void)interpolateWeightsWithPoint:(DelaunayPoint *)point
{
    DelaunayTriangulation *testTriangulation = [self copy];
    BOOL added = [testTriangulation addPoint:point];
    // TODO(mrotondo): Special-case touches right on top of existing points here.
    if (added)
    {
        NSDictionary *voronoiCells = [self voronoiCells];
        NSDictionary *testVoronoiCells = [testTriangulation voronoiCells];
        float fractionSum = 0.0;
        NSMutableDictionary *fractions = [NSMutableDictionary dictionaryWithCapacity:[voronoiCells count]];
        for ( DelaunayPoint *point in [voronoiCells keyEnumerator] )
        {
            VoronoiCell *cell = [voronoiCells objectForKey:point];
            VoronoiCell *testCell = [testVoronoiCells objectForKey:point];
            float fractionalChange = 0.0;
            if ( [cell area] > 0.0 )
                fractionalChange = 1.0 - MAX(MIN([testCell area] / [cell area], 1.0), 0.0);
            fractionSum += fractionalChange;
            [fractions setObject:[NSNumber numberWithFloat:fractionalChange] forKey:point];
        }
        if (fractionSum > 0.0)
        {
            for ( DelaunayPoint *point in [voronoiCells keyEnumerator] )
            {
                VoronoiCell *cell = [voronoiCells objectForKey:point];
                NSNumber *fractionalChange = [fractions objectForKey:point];
                cell.site.contribution = [fractionalChange floatValue] / fractionSum;
            }
        }
    }
}

@end
