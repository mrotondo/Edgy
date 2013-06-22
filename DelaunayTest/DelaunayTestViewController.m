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
    self.triangulation = [DelaunayTriangulation triangulationWithRect:self.view.bounds];
    
    for (int i = 0; i < 20; i++)
    {
        CGPoint loc = CGPointMake(self.view.bounds.size.width * (arc4random() / (float)0x100000000),
                                  self.view.bounds.size.height * (arc4random() / (float)0x100000000));
        DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
        [self.triangulation addPoint:newPoint withColor:nil];
    }
    
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
        [self.triangulation addPoint:newPoint withColor:nil];
        
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
}

- (IBAction)toggleInterpolation:(UISwitch *)sender
{
    self.interpolating = sender.on;
}

@end
