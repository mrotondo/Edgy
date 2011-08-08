//
//  DelaunayPoint.m
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "DelaunayPoint.h"
#import "DelaunayEdge.h"
#import "DelaunayTriangle.h"

@implementation DelaunayPoint
@synthesize x, y;
@synthesize UUIDString;
@synthesize contribution;
@synthesize value;

+ (DelaunayPoint *)pointAtX:(float)newX andY:(float)newY
{
    CFUUIDRef UUIDRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, UUIDRef);
    NSString *UUIDString = [(NSString *)stringRef autorelease];
    CFRelease(UUIDRef);
    DelaunayPoint *point = [DelaunayPoint pointAtX:newX andY:newY withUUID:UUIDString];
    return point;
}

+ (DelaunayPoint *)pointAtX:(float)newX andY:(float)newY withUUID:(NSString *)UUIDString
{
    DelaunayPoint *point = [[[self alloc] init] autorelease];
    point.x = newX;
    point.y = newY;
    point.UUIDString = UUIDString;
    point.edges = [NSMutableSet set];
    point.contribution = 0.0;
    return point;
}

- (void)dealloc
{
    [UUIDString release];
    CFRelease(nonretainingEdges);
    [value release];
    
    [super dealloc];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]])
    {
        return [self.UUIDString isEqualToString:((DelaunayPoint *)object).UUIDString];
    }
    return NO;
}
- (NSUInteger)hash
{
    return [self.UUIDString hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    DelaunayPoint *copy = [[DelaunayPoint pointAtX:self.x andY:self.y withUUID:self.UUIDString] retain];
    copy.contribution = self.contribution;
    copy.value = self.value;
    return copy;
}

- (NSMutableSet *)edges
{
    return (NSMutableSet *)nonretainingEdges;
}

- (void)setEdges:(NSMutableSet *)edges
{
    nonretainingEdges = CFSetCreateMutableCopy(NULL, [edges count], (CFMutableSetRef)edges);
}

- (NSArray *)counterClockwiseEdges
{
    return [[self.edges allObjects] sortedArrayUsingComparator:^(id obj1, id obj2) {
        DelaunayEdge *e1 = obj1;
        DelaunayEdge *e2 = obj2;
        
        DelaunayPoint *p1 = [e1 otherPoint:self];
        DelaunayPoint *p2 = [e2 otherPoint:self];
        
        float angle1 = atan2(p1.y - self.y, p1.x - self.x);
        float angle2 = atan2(p2.y - self.y, p2.x - self.x);
        if ( angle1 > angle2 )
            return NSOrderedAscending;
        else if ( angle1 < angle2 )
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
}

@end
