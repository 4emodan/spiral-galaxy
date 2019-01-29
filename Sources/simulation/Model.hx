package simulation;

import kha.math.FastMatrix3;
import core.model.Model.Point;

typedef Window = {w:Float, h:Float}
typedef Viewport = {originalWindow:Window, targetWindow:Window, w:Float, h:Float, origin:Point, scaleX:Float, scaleY:Float, scaleMatrix:FastMatrix3}

class ViewportExtensions {
	public static function center(v:Viewport):Point {
		return {x: v.origin.x + v.w / 2, y: v.origin.y + v.h / 2};
	}
}