package simulation;

import core.galaxy.Galaxy.GalaxySettings;

class Settings implements DataClass {
	var zoomInFactor:Float;
	// Galaxy
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

class SettingsExtensions {
	public static function galaxySettings(s:Settings):GalaxySettings {
		return new GalaxySettings(s.starsCount, s.coreRadius, s.diskRadius, s.farRadius, s.sunRadius, s.orbitAngleFactor, s.orbitExcentricityCore, s.orbitExcentricityDisk);
	}
}
