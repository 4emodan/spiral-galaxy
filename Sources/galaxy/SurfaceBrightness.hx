package galaxy;

class GalaxySurfaceBrightnessLaw {
	public static function get(k:Float, rd:Float, coreRadius:Float, galaxyRadius:Float):Float->Float {
		return surfaceBrightness.bind(_, 1, k, rd, coreRadius, galaxyRadius);
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
