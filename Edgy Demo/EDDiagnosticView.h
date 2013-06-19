//
//  EDDiagnosticView.h
//  Edgy
//
//  Created by Mike Rotondo on 6/18/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DelaunayTriangulation;

@interface EDDiagnosticView : UIView

@property (nonatomic, strong) DelaunayTriangulation *triangulation;

@end
