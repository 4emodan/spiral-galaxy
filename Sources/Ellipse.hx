// typedef Ellipse = {
//     a : 0,
//     b : 0.0,
//     segments : 0
// }
class Ellipse {
	public var a:Float;
	public var b:Float;
	public var segments:Int;

	public function new(a:Float, b:Float, segments:Int) {
		this.a = a;
		this.b = b;
		this.segments = segments;
	}

	public function x(t:Float):Float {
		return a * Math.cos(t);
	}

	public function y(t:Float):Float {
		return b * Math.sin(t);
	}
}
