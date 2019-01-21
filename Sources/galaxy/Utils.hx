package galaxy;

import kha.math.FastMatrix3;
import kha.math.FastVector2;
import kha.math.Random;
import Model.Point;
import galaxy.Orbit;

using Utils.FastVector2Extensions;

class OrbitExtensions {
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
