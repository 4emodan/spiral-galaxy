import kha.math.FastVector2;
import kha.math.FastMatrix3;
import Ellipse;
import Model.Point;
import Model.Star;
import kha.math.Random;

using Ellipse.EllipseExtensions;
using Utils.FastVector2Extensions;

class Galaxy {
	public var center(default, null):Point;
	public var orbits(default, null):Array<Ellipse>;
	public var stars(default, null):Array<Star>;

	var randomSeed:Int;

	public function new(center:Point, orbitsCount:Int) {
		this.center = center;

		orbits = generateOrbits(center, orbitsCount);
		stars = generateStars(orbits, randomSeed);
	}

	static function generateOrbits(center:Point, count:Int):Array<Ellipse> {
		var orbits = [];
		for (i in 1...count) {
			orbits.push(new Ellipse(center, i * 0.04, i * 5, i * 3, 12 + i));
		}
		return orbits;
	}

	static function generateStars(orbits:Array<Ellipse>, randomSeed:Int):Array<Star> {
		var count = 1000;
		var starRadius = 0.01;

		var stars:Array<Star> = [];
		for (o in orbits) {
			var random = new Random(randomSeed + Std.int(o.a * 10000) + Std.int(o.b * 1000));
			var segCount = Std.int(count / o.segmentCount);
			for (s in o.segments()) {
				var orbitStars = randomPointsAlongLine(s.p1, s.p2, segCount, 5, random).map(function(f) return new Star(f, starRadius));
				stars = stars.concat(orbitStars);
			}
		}
		return stars;
	}

	static function randomPointsAlongLine(p1:Point, p2:Point, count:Int, distribution:Float, random:Random):Array<Point> {
		var h = p2.y - p1.y;
		var w = p2.x - p1.x;
		var tan = h / w;
		var angle = Math.atan(tan);
		var d = h / Math.sin(angle);

		var v1 = new FastVector2();
		var v2 = new FastVector2();

		var transform = FastMatrix3.rotation(angle);

		var points:Array<Point> = [];
		for (i in 1...count) {
			v1.x = random.GetFloatIn(0, d);
			v1.y = random.GetFloatIn(0 - distribution, distribution);

			v2 = transform.multvec(v1);
			points.push({x: p1.x + v2.x, y: p1.y + v2.y});
		}
		return points;
	}
}
