import Model.FloatRange;
import kha.math.Random;
import Model.IntRange;
import Model.Point;
import kha.math.FastVector2;
import haxe.ds.Option;

class FastVector2Extensions {
	public static function asPoint(v:FastVector2):Point {
		return {x: v.x, y: v.y};
	}
}

class OptionExtensions {
	public static function toOption<T>(x:T):Option<T> {
		return if (x == null) None else Some(x);
	}
}

class IntRangeUtils {
	public static function random(i:IntRange, r:Random) {
		return r.GetIn(i.from, i.to);
	}
}

class FloatRangeUtils {
	public static function random(f:FloatRange, r:Random) {
		return r.GetFloatIn(f.from, f.to);
	}
}

class FloatUtils {
	public static function compare(f1:Float, f2:Float):Int {
		return if (f1 == f2) {
			0;
		} else if (f1 < f2) {
			-1;
		} else {
			1;
		}
	}
}
