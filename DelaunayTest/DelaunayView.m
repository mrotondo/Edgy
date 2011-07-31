//
//  DelaunayView.m
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "DelaunayView.h"
#import "DelaunayTriangulation.h"
#import "DelaunayPoint.h"
#import "DelaunayEdge.h"
#import "DelaunayTriangle.h"
#import "VoronoiCell.h"

@implementation DelaunayView
@synthesize triangulation;
@synthesize hoverTriangle;
@synthesize pointOfInterest;
@synthesize edgeOfInterest;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    self.hoverTriangle = nil;
    self.pointOfInterest = nil;
    self.edgeOfInterest = nil;
    
    edgeOfInterestIndex = 0;
}

- (void)setPointOfInterest:(DelaunayPoint*)point
{
    if ( point != pointOfInterest )
    {
        [pointOfInterest autorelease];
        pointOfInterest = [point retain];
    }
    edgeOfInterestIndex = 0;
    self.edgeOfInterest = [[point counterClockwiseEdges] objectAtIndex:edgeOfInterestIndex];
}

- (void)incrementEdgeOfInterest
{
    if ( self.pointOfInterest != nil )
    {
        edgeOfInterestIndex = (edgeOfInterestIndex + 1) % [[self.pointOfInterest edges] count];
        self.edgeOfInterest = [[self.pointOfInterest counterClockwiseEdges] objectAtIndex:edgeOfInterestIndex];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (DelaunayTriangle *triangle in self.triangulation.triangles)
    {
        if ([triangle inFrameTriangleOfTriangulation:self.triangulation])
            continue;
        
        //[triangle.color set];
        [[UIColor whiteColor] set];
        [[UIColor blackColor] setStroke];
        [triangle drawInContext:ctx];
        CGContextDrawPath(ctx, kCGPathFillStroke);
        //CGContextStrokePath(ctx);
        
    }
    
    // Draw circumcenters & circumcircles
//    for (DelaunayTriangle *triangle in self.triangulation.triangles)
//    {
//        // Don't draw Delaunay triangles that include the frame edges
////        if ([triangle inFrameTriangleOfTriangulation:self.triangulation])
////            continue;
//
//        [[UIColor redColor] set];
//        CGPoint circumcenter = [triangle circumcenter];
//        CGContextMoveToPoint(ctx, circumcenter.x + 10, circumcenter.y);
//        CGContextAddArc(ctx, circumcenter.x, circumcenter.y, 10, 0, 2 * M_PI, 0);
//        CGContextFillPath(ctx);
//        
//        DelaunayPoint *p = [triangle startPoint];
//        float bigradius = sqrtf(powf(p.x - circumcenter.x, 2) + powf(p.y - circumcenter.y, 2));
//        CGContextMoveToPoint(ctx, circumcenter.x + bigradius, circumcenter.y);
//        CGContextAddArc(ctx, circumcenter.x, circumcenter.y, bigradius, 0, 2 * M_PI, 0);
//        CGContextStrokePath(ctx);
//    }

    // Draw the most recently added point's edges in blue
//    if ( self.pointOfInterest != nil )
//    {
//        for ( DelaunayEdge *edge in [self.pointOfInterest counterClockwiseEdges] )
//        {
//            [[UIColor blueColor] set];
//            DelaunayPoint *p1 = [edge.points objectAtIndex:0];
//            DelaunayPoint *p2 = [edge.points objectAtIndex:1];
//            
//            CGContextMoveToPoint(ctx, p1.x, p1.y);
//            CGContextAddLineToPoint(ctx, p2.x, p2.y);
//            CGContextStrokePath(ctx);
//        }
//    }
    
    // Draw the two edges that share the currently selected edge.
//    if ( self.edgeOfInterest != nil )
//    {
//        int i = 0;
//        for ( DelaunayTriangle *triangle in [self.edgeOfInterest triangles] )
//        {
//            if ( i == 0)
//                [[UIColor cyanColor] set];
//            else
//                [[UIColor yellowColor] set];
//            [triangle drawInContext:ctx];
//            CGContextFillPath(ctx);
//            i++;
//        }
//        
//    }
    
    // Draw the voronoi cells
    NSDictionary *voronoiCells = [self.triangulation voronoiCells];    
    for (VoronoiCell *cell in [voronoiCells objectEnumerator])
    {
        [[UIColor colorWithWhite:cell.site.contribution alpha:1.0] set];
        [cell drawInContext:ctx];
        CGContextFillPath(ctx);
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
