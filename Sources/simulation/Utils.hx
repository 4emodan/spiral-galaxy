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
		v.scale = calculateScale(v.originalWindow, {w: v.w, h: v.h});

		v.origin.x = center.x - v.w / 2;
		v.origin.y = center.y - v.h / 2;
		v.scaleMatrix = FastMatrix3.scale(v.scale, v.scale);

		return v;
	}

	public static function setup(original:Window, target:Window):Viewport {
		var scale = calculateScale(original, target);
		return {
			originalWindow: original,
			targetWindow: target,
			w: target.w,
			h: target.h,
			origin: {x: 0, y: 0},
			margin: {x: (original.w - target.w * scale) / 2, y: (original.h - target.h * scale) / 2},
			scale: scale,
			scaleMatrix: FastMatrix3.scale(scale, scale)
		};
	}

	static function calculateScale(from:Window, to:Window):Float {
		return if (from.w <= from.h) {
			from.w / to.w;
		} else {
			from.h / to.h;
		}
	}
}
