package galaxy;

import kha.Scheduler;
import kha.math.FastVector2;
import kha.math.FastMatrix3;
import kha.math.Random;
import Ellipse;
import Model.Point;
import galaxy.Star;
import galaxy.SurfaceBrightness.GalaxySurfaceBrightnessLaw;
import math.Random.InvertedCumulativeDistributionFunction;

using Utils.OrbitExtensions;

class Galaxy {
	public var center(default, null):Point;
	public var coreRadius(default, null):Float;
	public var outerRadius(default, null):Float;
	public var farRadius(default, null):Float;
	//
	public var orbits(default, null):Array<Ellipse>;
	public var stars(default, null):Array<Star>;

	var randomSeed:Int;

	public function new(center:Point, coreRadius:Float, outerRadius:Float, farRadius:Float, starsCount:Int) {
		this.center = center;
		this.coreRadius = coreRadius;
		this.outerRadius = outerRadius;
		this.farRadius = farRadius;

		stars = generateStars(starsCount);
	}

	function generateStars(count:Int):Array<Star> {
		var random = new Random(randomSeed);

		var starRadius = 0.1;
		var angleCoef = 0.042;

		var brightnessLaw = GalaxySurfaceBrightnessLaw.get(0.01, farRadius / 3, coreRadius, farRadius);
		var invertedCdf = InvertedCumulativeDistributionFunction.forLaw(brightnessLaw, 48, 0, farRadius);

		return [
			for (i in 1...count) {
				// var radius = i * farRadius / count;
				var radius = invertedCdf(random.GetFloat());

				var orbit = new Orbit(center, radius, radius * getExcentricity(radius), radius * angleCoef);
				new Star(orbit.randomPoint(random), starRadius, orbit);
			}
		];
	}

	function getExcentricity(radius:Float):Float {
		var e1 = 0.65;
		var e2 = 1;

		if (radius < coreRadius) {
			// Core region of the galaxy. Innermost part is round
			// excentricity increasing linear to the border of the core.
			return 1 + (radius / coreRadius) * (e1 - 1);
		} else if (radius > coreRadius && radius <= outerRadius) {
			return e1 + (radius - coreRadius) / (outerRadius - coreRadius) * (e2 - e1);
		} else if (radius > outerRadius && radius < farRadius) {
			// excentricity is slowly reduced to 1.
			return e2 + (radius - outerRadius) / (farRadius - outerRadius) * (1 - e2);
		} else
			return 1;
	}
}
