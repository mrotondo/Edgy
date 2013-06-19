//
//  EDDiagnosticView.m
//  Edgy
//
//  Created by Mike Rotondo on 6/18/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "EDDiagnosticView.h"
#import "DelaunayTriangulation.h"
#import "DelaunayPoint.h"
#import "DelaunayEdge.h"
#import "DelaunayTriangle.h"
#import "VoronoiCell.h"

@implementation EDDiagnosticView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (DelaunayTriangle *triangle in self.triangulation.triangles)
    {
        if ([triangle inFrameTriangleOfTriangulation:self.triangulation])
            continue;
        
//        [triangle.color set];
        [[UIColor whiteColor] set];
        [[UIColor blackColor] setStroke];
        [triangle drawInContext:ctx];
        CGContextDrawPath(ctx, kCGPathFillStroke);
        //CGContextStrokePath(ctx);
        
    }
    
//    // Draw circumcenters & circumcircles
//    for (DelaunayTriangle *triangle in self.triangulation.triangles)
//    {
//        // Don't draw Delaunay triangles that include the frame edges
//        //        if ([triangle inFrameTriangleOfTriangulation:self.triangulation])
//        //            continue;
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
    
    //Draw the voronoi cells
    NSDictionary *voronoiCells = [self.triangulation voronoiCells];
    for (VoronoiCell *cell in [voronoiCells objectEnumerator])
    {
        [cell drawInContext:ctx];
        if (cell.site.color)
        {
            [cell.site.color set];
            CGContextDrawPath(ctx, kCGPathFill);
        }
        else
        {
            [[UIColor colorWithRed:(arc4random() / (float)0x100000000) green:(arc4random() / (float)0x100000000) blue:(arc4random() / (float)0x100000000) alpha:0.9] set];
            CGContextDrawPath(ctx, kCGPathStroke);
        }
    }
}


@end
