//
//  DelaunayPoint.h
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DelaunayPoint : NSObject <NSCopying> {

    CFMutableSetRef nonretainingEdges;
    float contribution;
}

@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic, retain) NSString *UUIDString;
@property (nonatomic, assign) NSMutableSet *edges;
@property float contribution;
@property (nonatomic, retain) id value;

+ (DelaunayPoint *) pointAtX:(float)x andY:(float)y;
+ (DelaunayPoint *)pointAtX:(float)newX andY:(float)newY withUUID:(NSString *)uuid;
- (NSArray *)counterClockwiseEdges;

- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

@end
