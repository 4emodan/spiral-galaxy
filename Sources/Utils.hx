import Model.Point;
import kha.math.FastVector2;
import haxe.ds.Option;

class FastVector2Extensions {
	public static function asPoint(v:FastVector2):Point {
		return {x: v.x, y: v.y};
	}
}

class OptionExtensions {
	public static function toOption<T>(x: T): Option<T> {
		return if(x == null) None else Some(x);
	}
}
