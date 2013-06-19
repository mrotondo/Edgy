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
    NSTimeInterval _touchTimeThreshold;
    NSDate *_lastTouchTime;
    UIColor *_currentColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reset];
    _touchTimeThreshold = 0.05;
    _lastTouchTime = [NSDate distantPast];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)reset
{
    CGRect triangulationRect = CGRectInset(self.view.bounds, 0, 0);
    _triangulation = [DelaunayTriangulation triangulationWithRect:triangulationRect];
    _diagnosticView.triangulation = _triangulation;
    
    for (int i = 0; i < 100; i++)
    {
        CGPoint loc = CGPointMake(self.view.bounds.size.width * (arc4random() / (float)0x100000000),
                                  self.view.bounds.size.height * (arc4random() / (float)0x100000000));
        DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
        [_triangulation addPoint:newPoint withColor:nil];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
    [_triangulation addPoint:newPoint withColor:nil];
    _currentColor = [UIColor colorWithRed:(arc4random() / (float)0x100000000)
                                    green:(arc4random() / (float)0x100000000)
                                     blue:(arc4random() / (float)0x100000000)
                                    alpha:1.0];
    newPoint.color = _currentColor;
    _lastTouchTime = [NSDate date];

    [_diagnosticView setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[NSDate date] timeIntervalSinceDate:_lastTouchTime] < _touchTimeThreshold)
    {
        return;
    }
    else
    {
        _lastTouchTime = [NSDate date];
    }
    
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
    newPoint.color = _currentColor;
    [_triangulation addPoint:newPoint withColor:nil];
    [_diagnosticView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
