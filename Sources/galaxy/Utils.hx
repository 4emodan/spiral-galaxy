package galaxy;

import haxe.rtti.CType.Typedef;
import galaxy.Star.SolarUnit;
import galaxy.Star.Kelvin;
import galaxy.Star.StarType;
import kha.math.FastMatrix3;
import kha.math.FastVector2;
import kha.math.Random;
import Model.Point;
import galaxy.Orbit;

using Utils.FastVector2Extensions;
using galaxy.Star.StarTypeExtensions;
using Utils.IntRangeUtils;
using Utils.FloatRangeUtils;
using Utils.FloatUtils;

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

	public static function randomizer(e:Enum<StarType>, r:Random, distribution:StarType->Float):Void->StarType {
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

		return function():StarType {
			var u = r.GetFloat();
			var sum = 0.0;
			for (to in typeOccurences) {
				if (u <= sum + to.occurence) {
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
