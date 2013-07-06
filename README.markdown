## Edgy does 3 things:

### Delaunay Triangulations

<pre>
#import "DelaunayTriangulation.h"
DelaunayTriangulation *triangulation = [DelaunayTriangulation triangulationWithSize:CGSizeMake(1000, 1000)];

UITouch *touch = (UITouch *)[touches anyObject];
CGPoint loc = [touch locationInView:self.view];
DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
[self.triangulation addPoint:newPoint];
</pre>

### Voronoi Diagrams

<pre>
NSDictionary *voronoiCells = [self.triangulation voronoiCells];
</pre>

### Natural Neighbor Interpolation

<pre>
UITouch *touch = (UITouch *)[touches anyObject];
CGPoint loc = [touch locationInView:self.view];
DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
[self.triangulation interpolateWeightsWithPoint:newPoint];
</pre>

After interpolateWeightsWithPoint is called, each DelaunayPoint in the DelaunayTriangulation object's points set will have a contribution property that is between [0, 1] and represents the weight of that point's contribution to the output at the interpolated point.


License
-------
Code is under the [Creative Commons Attribution 3.0 Unported license][license].

[license]:http://creativecommons.org/licenses/by/3.0/
