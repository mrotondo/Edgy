//
//  DelaunayView.m
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "DelaunayView.h"
#import "DelaunayPoint.h"
#import "DelaunayEdge.h"
#import "DelaunayTriangle.h"


@implementation DelaunayView
@synthesize triangulation;
@synthesize hoverTriangle;

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
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor blackColor] set];
    
    for (DelaunayTriangle *triangle in self.triangulation.triangles)
    {
        if ([triangle inFrameTriangleOfTriangulation:self.triangulation])
            continue;
        
        [triangle.color set];
        [triangle drawInContext:ctx];
        CGContextFillPath(ctx);
    }
    
    NSMutableSet *unexploredTriangles = [self.triangulation.triangles mutableCopy];
    DelaunayTriangle *triangle;
    while ([unexploredTriangles count] > 0)
    {
        triangle = [unexploredTriangles anyObject];
        CGPoint circumcenter = [triangle circumcenter];
        for (DelaunayTriangle *neighbor in [triangle neighbors])
        {
            CGPoint neighborCircumcenter = [neighbor circumcenter];
            CGContextMoveToPoint(ctx, circumcenter.x, circumcenter.y);
            CGContextAddLineToPoint(ctx, neighborCircumcenter.x, neighborCircumcenter.y);
        }
        [unexploredTriangles removeObject:triangle];
    }
    [[UIColor whiteColor] set];
    CGContextStrokePath(ctx);
}

- (void)dealloc
{
    [super dealloc];
}

@end
