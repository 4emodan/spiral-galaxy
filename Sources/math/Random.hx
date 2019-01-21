package math;

import haxe.ds.Vector;

private typedef CumulativeDistributionFunction = Vector<Float>;

class InvertedCumulativeDistributionFunction {
	public static function forLaw(law:Float->Float, intervals:Int, min:Float, max:Float):Float->Float {
		var dx = (max - min) / intervals;
		var halfDx = dx / 2;

		var sum = 0.0;
		var cdf = new Vector(intervals + 1);
		for (i in 0...intervals) {
			var x = min + dx * i + halfDx;
			sum += law(x) * dx;
			cdf[i + 1] = sum;
		}
		for (i in 0...cdf.length) {
			cdf[i] /= sum;
		}
		cdf[0] = 0;
		cdf[cdf.length - 1] = 1;

		return function(probability:Float):Float {
			var i = searchCdf(probability, cdf);
			var dxPart = if (i == cdf.length - 1) {
				0;
			} else {
				(probability - cdf[i]) * dx / (cdf[i + 1] - cdf[i]);
			};

			return min + i * dx + dxPart;
		}
	}

	static function searchCdf(value:Float, cdf:CumulativeDistributionFunction):Int {
		if (value <= 0)
			return 0;
		if (value >= 1)
			return cdf.length - 1;

		var intervalFound = function(i:Int):Bool {
			return (cdf[i] <= value) && ((i == cdf.length - 1) || (cdf[i + 1] > value));
		}

		var find = function(from:Int, increment:Int):Int {
			var i = from;
			while (!intervalFound(i) && i > 0 && (i < cdf.length - 1)) {
				i += increment;
			}
			return i;
		}

		var guessInterval = Std.int(value * cdf.length);
		return find(guessInterval, if (value < cdf[guessInterval]) -1 else 1);
	}
}
