package simulation;

import kha.math.FastMatrix3;
import simulation.Model.Window;
import simulation.Model.Viewport;

using simulation.Model.ViewportExtensions;

class ViewportUtils {
	public static function applyZoom(v:Viewport, zoom:Float):Viewport {
		var center = v.center();

		v.w = v.targetWindow.w * zoom;
		v.h = v.targetWindow.h * zoom;
		v.scaleX = v.originalWindow.w / v.w;
		v.scaleY = v.originalWindow.h / v.h;
		v.origin.x = center.x - v.w / 2;
		v.origin.y = center.y - v.h / 2;
		v.scaleMatrix = FastMatrix3.scale(v.scaleX, v.scaleY);

        return v;
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
