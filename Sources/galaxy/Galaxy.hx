package galaxy;

import haxe.EnumTools;
import kha.Scheduler;
import kha.math.FastVector2;
import kha.math.FastMatrix3;
import kha.math.Random;
import Ellipse;
import Model.Point;
import galaxy.Star;
import galaxy.Brightness.GalaxySurfaceBrightness;
import math.Random.InvertedCdf;

using Utils.OrbitUtils;
using Utils.StarTypeUtils;
using Star.StarTypeExtensions;

class Galaxy {
	public var center(default, null):Point;
	public var coreRadius(default, null):Float;
	public var diskRadius(default, null):Float;
	public var farRadius(default, null):Float;
	public var orbitAngleFactor(default, null):Float;
	public var orbitExcentricityCore(default, null):Float;
	public var orbitExcentricityDisk(default, null):Float;
	//
	public var stars(default, null):Array<Star>;

	var randomSeed:Int;

	public function new(settings:Settings, center:Point) {
		this.center = center;
		this.coreRadius = settings.coreRadius;
		this.diskRadius = settings.diskRadius;
		this.farRadius = settings.farRadius;
		this.orbitAngleFactor = settings.orbitAngleFactor;
		this.orbitExcentricityCore = settings.orbitExcentricityCore;
		this.orbitExcentricityDisk = settings.orbitExcentricityDisk;

		stars = generateStars(settings.starsCount);
	}

	function generateStars(count:Int):Array<Star> {
		var random = new Random(randomSeed);

		// Distribute stars with the surface brightness law
		var brightnessLaw = GalaxySurfaceBrightness.setupLaw(farRadius / 3, coreRadius, farRadius);
		var randomOrbitRadius = InvertedCdf.forLaw(brightnessLaw, 48, 0, farRadius);

		var randomStarType = StarType.randomizer(random); 

		return [
			for (i in 1...count) {
				var type = randomStarType();

				// var radius = i * farRadius / count;
				var orbitRadius = randomOrbitRadius(random.GetFloat());
				var orbit = new Orbit(center, orbitRadius, orbitRadius * getOrbitExcentricity(orbitRadius), orbitRadius * orbitAngleFactor);

				new Star(orbit.randomPoint(random), orbit, type, type.randomTemperature(random), type.randomRadius(random), type.randomLuminosity(random));
			}
		];
	}

	function getOrbitExcentricity(radius:Float):Float {
		if (radius < coreRadius) {
			// Core region of the galaxy. Innermost part is round
			// excentricity increasing linear to the border of the core.
			return 1 + (radius / coreRadius) * (orbitExcentricityCore - 1);
		} else if (radius > coreRadius && radius <= diskRadius) {
			return orbitExcentricityCore + (radius - coreRadius) / (diskRadius - coreRadius) * (orbitExcentricityDisk - orbitExcentricityCore);
		} else if (radius > diskRadius && radius < farRadius) {
			// excentricity is slowly reduced to 1.
			return orbitExcentricityDisk + (radius - diskRadius) / (farRadius - diskRadius) * (1 - orbitExcentricityDisk);
		} else
			return 1;
	}
}
