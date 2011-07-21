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
    
    NSMutableSet *triangles;
    NSArray *points;
    
}

@property (nonatomic, retain) NSMutableSet *triangles;
@property (nonatomic, retain) NSArray *points;

+ (DelaunayEdge *)edgeWithPoints:(NSArray *)points;
- (DelaunayTriangle *)neighborOf:(DelaunayTriangle *)triangle;
- (DelaunayPoint *)otherPoint:(DelaunayPoint *)point;
- (BOOL)pointOnLeft:(DelaunayPoint*)point withStartPoint:(DelaunayPoint *)startPoint;

@end
