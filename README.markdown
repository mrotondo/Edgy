# Edgy Does 3 Things:

## Delaunay Triangulations

<pre>
#import "DelaunayTriangulation.h"
DelaunayTriangulation *triangulation = [DelaunayTriangulation triangulationWithSize:CGSizeMake(1000, 1000)];
DelaunayPoint *newPoint = [DelaunayPoint pointAtX:100 andY:100];
[self.triangulation addPoint:newPoint];
newPoint = [DelaunayPoint pointAtX:200 andY:200];
[self.triangulation addPoint:newPoint];
newPoint = [DelaunayPoint pointAtX:100 andY:300];
[self.triangulation addPoint:newPoint];
</pre>

## Voronoi Diagrams

Not yet.

## Natural Neighbor Interpolation

Not yet.