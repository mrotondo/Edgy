//
//  DelaunayView.h
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelaunayTriangulation.h"

@interface DelaunayView : UIView {
    
}

@property (nonatomic, retain) DelaunayTriangulation* triangulation;
@property (nonatomic, retain) DelaunayTriangle *hoverTriangle;

@end
