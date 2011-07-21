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

@implementation DelaunayTestViewController
@synthesize triangulation;

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
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
    [self.triangulation addPoint:newPoint];
    [self.view setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
    ((DelaunayView *)self.view).hoverTriangle = [self.triangulation triangleContainingPoint:newPoint];
    [self.view setNeedsDisplay];
}

@end
