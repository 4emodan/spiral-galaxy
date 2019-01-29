package core.math;

class MyMath {
	public static var E = 2.718;

	public static function clamp(f:Float, min:Float, max:Float):Float {
		return Math.max(min, Math.min(f, max));
	}

	/**
	 * @return closest power of two value
	 */
	public static function powOfTwo(x:Int):Int {
		if (x == 0) {
			return 1;
		}
		--x;
		x |= x >> 1;
		x |= x >> 2;
		x |= x >> 4;
		x |= x >> 8;
		x |= x >> 16;
		return x + 1;
	}
}
