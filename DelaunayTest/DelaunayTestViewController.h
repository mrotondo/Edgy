//
//  DelaunayTestViewController.h
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelaunayTriangulation.h"

@interface DelaunayTestViewController : UIViewController {
    DelaunayTriangulation *triangulation;
}

@property (nonatomic, retain) DelaunayTriangulation *triangulation;
@property (nonatomic, retain) IBOutlet UISwitch *interpaderpSwitch;
@property BOOL interpolating;

- (void) reset;
- (IBAction)toggleInterpolation:(UISwitch *)sender;

@end
