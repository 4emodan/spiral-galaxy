package simulation.render;

import haxe.io.Bytes;
import kha.graphics4.Usage;
import kha.graphics4.TextureFormat;
import kha.Image;
import kha.Color;
import core.galaxy.Star.StarType;
import core.galaxy.Star.Kelvin;
import core.math.Math.MyMath;

using core.galaxy.Star.StarTypeExtensions;

class StarRenderer {
	/**
	 * Color according to spectral classification.
	 * @see https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/Hertzsprung-Russel_StarData.png/440px-Hertzsprung-Russel_StarData.png
	 */
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

	public static function generateHaloTemplate(size:Int):Image {
		var w = MyMath.powOfTwo(size);
		var r = w / 2.0;

		// We need to switch red and blue for some reason
		var texColor = Color.White;

		var bytes = Bytes.alloc(w * w * 4);
		var pixelCount = w * w;

		var x = 0;
		var y = 0;
		var d = 0.0;
		for (i in 0...pixelCount) {
			x = i % w - Std.int(r);
			y = Math.floor(i / w) - Std.int(r);
			d = Math.sqrt(x * x + y * y);
			texColor.A = MyMath.clamp(1.0 - Math.abs(d / r), 0, 1);
			bytes.setInt32(i * 4, texColor.value);
		}
		return Image.fromBytes(bytes, w, w, TextureFormat.RGBA32, Usage.StaticUsage);
	}
}
