package math;

class MyMath {
    public static var E = 2.718;

	public static function clamp(f:Float, min:Float, max:Float):Float {
        return Math.max(min, Math.min(f, max));
    }
}
