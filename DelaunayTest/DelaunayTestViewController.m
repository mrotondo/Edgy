//
//  DelaunayTestViewController.m
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "DelaunayTestViewController.h"
#import "DelaunayView.h"
#import "DelaunayPoint.h"
#import "VoronoiCell.h"

@implementation DelaunayTestViewController
@synthesize triangulation;
@synthesize interpaderpSwitch;
@synthesize interpolating;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reset];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self reset];
}

- (void)reset
{
    self.triangulation = [DelaunayTriangulation triangulationWithSize:self.view.bounds.size];
    ((DelaunayView *)self.view).triangulation = triangulation;
    self.interpaderpSwitch.on = NO;
    self.interpolating = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (interpolating)
    {
        UITouch *touch = (UITouch *)[touches anyObject];
        CGPoint loc = [touch locationInView:self.view];
        DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
        [self.triangulation interpolateWeightsWithPoint:newPoint];
        [self.view setNeedsDisplay];
    }
    else
    {
        UITouch *touch = (UITouch *)[touches anyObject];
        CGPoint loc = [touch locationInView:self.view];
        DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
        BOOL added = [self.triangulation addPoint:newPoint];
        if (added)
            ((DelaunayView *)self.view).pointOfInterest = newPoint;
        else
            [(DelaunayView *)self.view incrementEdgeOfInterest];
        [self.view setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (interpolating)
    {
        UITouch *touch = (UITouch *)[touches anyObject];
        CGPoint loc = [touch locationInView:self.view];
        DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
        [self.triangulation interpolateWeightsWithPoint:newPoint];
        [self.view setNeedsDisplay];
    }
    else
    {
        UITouch *touch = (UITouch *)[touches anyObject];
        CGPoint loc = [touch locationInView:self.view];
        DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
        ((DelaunayView *)self.view).hoverTriangle = [self.triangulation triangleContainingPoint:newPoint];
        [self.view setNeedsDisplay];
    }
}

- (IBAction)toggleInterpolation:(UISwitch *)sender
{
    self.interpolating = sender.on;
}

@end
