package core.model;

import kha.math.FastVector2;
import kha.math.FastMatrix3;
import core.model.Model.Point;
import core.model.Model.Segment;
import DataClass;

using core.Utils.FastVector2Extensions;

class Ellipse implements DataClass {
	var center:Point;
	var rotationAngle:Float;
	var a:Float;
	var b:Float;
}

class EllipseExtensions {
	public static function x(e:Ellipse, t:Float):Float {
		return e.a * Math.cos(t);
	}

	public static function y(e:Ellipse, t:Float):Float {
		return e.b * Math.sin(t);
	}

	public static function segments(e:Ellipse, count:Int):Array<Segment> {
		var translate = FastMatrix3.translation(e.center.x, e.center.y);
		var rotate = FastMatrix3.rotation(e.rotationAngle);
		var transform = translate.multmat(rotate);

		var paramStep = 2 * Math.PI / count;
		var segments = [];

		var t = 0.0;
		var p1:Point = {x: 0, y: 0};
		var p2:Point = {x: 0, y: 0};
		var v1 = new FastVector2();
		var v2 = new FastVector2();
		for (i in 1...count) {
			v1.x = x(e, t);
			v1.y = y(e, t);
			v1 = transform.multvec(v1);
			t += paramStep;
			v2.x = x(e, t);
			v2.y = y(e, t);
			v2 = transform.multvec(v2);
			segments.push({p1: v1.asPoint(), p2: v2.asPoint()});
		}
		segments.push({p1: v2.asPoint(), p2: segments[0].p1});

		return segments;
	}
}
