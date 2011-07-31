//
//  DelaunayView.h
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DelaunayTriangulation;
@class DelaunayPoint;
@class DelaunayEdge;
@class DelaunayTriangle;

@interface DelaunayView : UIView {

    int edgeOfInterestIndex;
    
}

@property (nonatomic, retain) DelaunayTriangulation* triangulation;
@property (nonatomic, retain) DelaunayTriangle *hoverTriangle;
@property (nonatomic, retain) DelaunayPoint *pointOfInterest;
@property (nonatomic, retain) DelaunayEdge *edgeOfInterest;

- (void)setPointOfInterest:(DelaunayPoint*)point;
- (void)incrementEdgeOfInterest;

@end
