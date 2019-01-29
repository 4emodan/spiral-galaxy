package core.galaxy;

import kha.math.Random;
import core.model.Model.Point;
import core.math.Random.InvertedCdf;
import core.galaxy.Star;
import core.galaxy.Brightness.GalaxySurfaceBrightness;

using Utils.OrbitUtils;
using Utils.StarTypeUtils;

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

	public function new(settings:GalaxySettings, center:Point) {
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

class GalaxySettings implements DataClass {
	var starsCount:Int;
	var coreRadius:Float;
	var diskRadius:Float;
	var farRadius:Float;
	var sunRadius:Float;

	/**
	 * Factor to calculate an orbit's rotation with it's radius.
	 * The formula is: angle = radius * factor
	 */
	var orbitAngleFactor:Float;

	/**
	 * Excentricity of the orbit at the edge of the galaxy's core.
	 */
	var orbitExcentricityCore:Float;

	/**
	 * Excentricity of the orbit at the edge of the galaxy's disk.
	 */
	var orbitExcentricityDisk:Float;
}