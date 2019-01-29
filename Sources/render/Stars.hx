package render;

import kha.graphics4.Usage;
import kha.graphics4.TextureFormat;
import kha.math.Random;
import haxe.io.BytesData;
import haxe.io.Bytes;
import galaxy.Star;
import kha.Image;
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

	public static function getHalo(star:Star):Image {
		var w = powOfTwo(Std.int(star.radius * 4 * 0.075));
		if (w < 256)
			w = 256;
		var r = w / 2.0;

		// We need to switch red and blue for some reason
		var color = getColor(star.temperature);
		var texColor = Color.White;
		// var texColor = Color.fromFloats(color.B, color.G, color.R);

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
			// bytes.setInt32(i * 4, 0x800000FF);
		}
		return Image.fromBytes(bytes, w, w, TextureFormat.RGBA32, Usage.StaticUsage);
	}
}
