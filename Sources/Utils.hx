import Model.Point;
import kha.math.FastVector2;

class FastVector2Extensions {
	public static function asPoint(v:FastVector2):Point {
		return {x: v.x, y: v.y};
	}
}
