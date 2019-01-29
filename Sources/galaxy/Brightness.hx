package galaxy;

/**
 * Surface brightness according to de Vaucouleurs' law and Freeman formula for the galaxy's disk.
 */
class GalaxySurfaceBrightness {
	/**
	 * @param halfBrihtnessRadius radius at which the brightness decreases by 50%
	 */
	public static function setupLaw(halfBrihtnessRadius:Float, coreRadius:Float, galaxyRadius:Float):Float->Float {
		var k = Math.pow(coreRadius, 0.75) / halfBrihtnessRadius;
		trace('K=$k');
		return surfaceBrightness.bind(_, 1, k, halfBrihtnessRadius, coreRadius, galaxyRadius);
	}

	static function surfaceBrightness(r:Float, i0:Float, k:Float, rd:Float, coreRadius:Float, galaxyRadius:Float):Float {
		if (r <= coreRadius) {
			return coreBrightness(r, i0, k);
		} else if (r <= galaxyRadius) {
			return outerBrightness(r, i0, rd);
		} else {
			return 0;
		}
	}

	inline static function coreBrightness(r:Float, i0:Float, k:Float):Float {
		return i0 * Math.exp(-k * Math.pow(r, 0.25));
	}

	inline static function outerBrightness(r:Float, i0:Float, rd:Float):Float {
		return i0 * Math.exp(-r / rd);
	}
}
