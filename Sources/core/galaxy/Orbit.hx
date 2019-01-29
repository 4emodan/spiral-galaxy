package core.galaxy;

import core.model.Model.Point;

class Orbit implements DataClass {
	var center:Point;
	var a:Float;
	var b:Float;
    var angle:Float;

	public function excentricity():Float {
		return b / a;
	}
}
