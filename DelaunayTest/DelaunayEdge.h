//
//  DelaunayEdge.h
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/20/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DelaunayTriangle;
@class DelaunayPoint;

@interface DelaunayEdge : NSObject {
    
    CFMutableSetRef nonretainingTriangles;
    CFArrayRef nonretainingPoints;
}

@property (nonatomic, assign) NSMutableSet *triangles;
@property (nonatomic, assign) NSArray *points;

+ (DelaunayEdge *)edgeWithPoints:(NSArray *)points;
- (DelaunayTriangle *)neighborOf:(DelaunayTriangle *)triangle;
- (DelaunayPoint *)otherPoint:(DelaunayPoint *)point;
- (BOOL)pointOnLeft:(DelaunayPoint*)point withStartPoint:(DelaunayPoint *)startPoint;
- (DelaunayTriangle *)sharedTriangleWithEdge:(DelaunayEdge *)otherEdge;
- (float)length;
- (void)remove;

- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

- (void)print;

@end
