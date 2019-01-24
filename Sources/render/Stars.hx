package render;

import galaxy.Star.StarType;
import kha.Color;
import galaxy.Star.Kelvin;
import math.Math.MyMath;

using galaxy.Star.StarTypeExtensions;

class StarRenderer {
	public static function getColor(temp:Kelvin):Color {
		var white = 7500.0;
		var min = StarType.M.temperature().from;
		var max = StarType.O.temperature().to;

		var t = MyMath.clamp(temp, min, max);
		if (t >= white) {
			var wt = (t - white) / (max - white);
			var r = expDecrease(30 * wt);
			var g = expDecrease(7 * wt);
			var b = 1;
			return Color.fromFloats(r, g, b);
		} else {
			var wt = (white - t) / (white - min);
			var b = expDecrease(10 * wt);
			var g = expDecrease(5 * wt);
			var r = 1;
			return Color.fromFloats(r, g, b);
		}
	}

	/**
	 * Exponential decrease from 1 at x = 0.
	 */
	static inline function expDecrease(x:Float):Float {
		return 1 / Math.log(x + MyMath.E);
	}
}
