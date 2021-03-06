package core.galaxy;

import haxe.rtti.CType.Typedef;
import kha.math.FastMatrix3;
import kha.math.FastVector2;
import kha.math.Random;
import core.model.Model.Point;
import core.galaxy.Star.SolarUnit;
import core.galaxy.Star.Kelvin;
import core.galaxy.Star.StarType;
import core.galaxy.Orbit;

using core.Utils.FastVector2Extensions;
using core.Utils.IntRangeUtils;
using core.Utils.FloatRangeUtils;
using core.Utils.FloatUtils;
using Star.StarTypeExtensions;

class OrbitUtils {
	public static function randomPoint(o:Orbit, r:Random):Point {
		return angularPoint(o, r.GetFloatIn(0, 2 * Math.PI));
	}

	public static function angularPoint(o:Orbit, angle:Float):Point {
		var translate = FastMatrix3.translation(o.center.x, o.center.y);
		var rotate = FastMatrix3.rotation(o.angle);
		var transform = translate.multmat(rotate);
		var v = new FastVector2(o.a * Math.cos(angle), o.b * Math.sin(angle));
		return transform.multvec(v).asPoint();
	}
}

class StarTypeUtils {
	public static function random(e:Enum<StarType>, r:Random):StarType {
		var i = r.GetIn(0, e.getConstructors().length - 1);
		return e.createByIndex(i);
	}

	/**
	 * Creates a function that will return a random star type each time with regard to
	 * occurence values of star types.
	 */
	public static function randomizer(e:Enum<StarType>, r:Random):Void->StarType {
		var typeOccurences = [
			for (i in 0...e.getConstructors().length) {
				var t = e.createByIndex(i);
				var o = t.occurence();
				{type: t, occurence: o}
			}
		];
		typeOccurences.sort(function(a:{type:StarType, occurence:Float}, b:{type:StarType, occurence:Float}):Int {
			return a.occurence.compare(b.occurence);
		});

		// Basically occurence values build up a CDF, so we use uniform distribution to transform it
		// into the real star type distribution.
		return function():StarType {
			var uniform = r.GetFloat();
			var sum = 0.0;
			for (to in typeOccurences) {
				if (uniform <= sum + to.occurence) {
					return to.type;
				}
				sum += to.occurence;
			}
			return typeOccurences[typeOccurences.length - 1].type;
		};
	}

	public static function randomTemperature(t:StarType, r:Random):Kelvin {
		return t.temperature().random(r);
	}

	public static function randomLuminosity(t:StarType, r:Random):SolarUnit {
		return t.luminosity().random(r);
	}

	public static function randomRadius(t:StarType, r:Random):Kelvin {
		return t.radius().random(r);
	}
}
