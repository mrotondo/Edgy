//
//  DelaunayPoint.h
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DelaunayPoint : NSObject <NSCopying>

@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) float contribution;
@property (nonatomic, strong) NSNumber *idNumber;
@property (nonatomic, readonly) NSMutableSet *edges;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) UIColor *color;

+ (DelaunayPoint *)pointAtX:(float)x andY:(float)y;
+ (DelaunayPoint *)pointAtX:(float)newX andY:(float)newY withID:(NSNumber *)idNumber;
- (NSArray *)counterClockwiseEdges;

- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

@end
