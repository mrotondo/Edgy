//
//  EDViewController.m
//  Edgy Demo
//
//  Created by Mike Rotondo on 6/18/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "EDViewController.h"
#import "DelaunayTriangulation.h"
#import "DelaunayPoint.h"
#import "EDDiagnosticView.h"

@interface EDViewController ()

@end

@implementation EDViewController
{
    IBOutlet EDDiagnosticView *_diagnosticView;
    DelaunayTriangulation *_triangulation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reset];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)reset
{
    CGRect triangulationRect = CGRectInset(self.view.bounds, 40, 40);
    _triangulation = [DelaunayTriangulation triangulationWithRect:triangulationRect];
    _diagnosticView.triangulation = _triangulation;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
    [_triangulation addPoint:newPoint withColor:nil];
    
    [_diagnosticView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
