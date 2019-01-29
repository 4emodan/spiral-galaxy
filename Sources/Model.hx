import kha.math.FastMatrix3;

typedef Point = {x:Float, y:Float};
typedef Segment = {p1:Point, p2:Point};
typedef IntRange = {from:Int, to:Int};
typedef FloatRange = {from:Float, to:Float};
typedef Window = {w:Float, h:Float}
typedef Viewport = {originalWindow:Window, targetWindow:Window, w:Float, h:Float, origin:Point, scaleX:Float, scaleY:Float, scaleMatrix:FastMatrix3}

class ViewportExtensions {
	public static function center(v:Viewport):Point {
		return {x: v.origin.x + v.w / 2, y: v.origin.y + v.h / 2};
	}

	public static function applyZoom(v:Viewport, zoom:Float) {
		var center = center(v);

		v.w = v.targetWindow.w * zoom;
		v.h = v.targetWindow.h * zoom;
		v.scaleX = v.originalWindow.w / v.w;
		v.scaleY = v.originalWindow.h / v.h;
		v.origin.x = center.x - v.w / 2;
		v.origin.y = center.y - v.h / 2;
		v.scaleMatrix = FastMatrix3.scale(v.scaleX, v.scaleY);
	}

	public static function setup(original:Window, target:Window):Viewport {
		var sX = original.w / target.w;
		var sY = original.h / target.h;
		return {
			originalWindow: original,
			targetWindow: target,
			w: target.w,
			h: target.h,
			origin: {x: 0, y: 0},
			scaleX: sX,
			scaleY: sY,
			scaleMatrix: FastMatrix3.scale(sX, sY)
		};
	}
}
