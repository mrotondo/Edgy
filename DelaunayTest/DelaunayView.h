//
//  DelaunayView.h
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DelaunayTriangulation;

@interface DelaunayView : UIView {

}

@property (nonatomic, strong) DelaunayTriangulation* triangulation;

@end
