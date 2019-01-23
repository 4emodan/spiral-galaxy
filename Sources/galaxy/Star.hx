package galaxy;

import Model.Point;
import Model.IntRange;
import Model.FloatRange;

typedef SolarUnit = Float;
typedef Kelvin = Float;
typedef SolarRadius = Float;

enum StarType {
	O;
	B;
	A;
	F;
	G;
	K;
	M;
}

class StarTypeExtensions {
	/**
	 * return a star class temperature range in Kelvins.
	 */
	public static function temperature(t:StarType):IntRange {
		return switch (t) {
			case O:
				{from: 30000, to: 60000};
			case B:
				{from: 10000, to: 30000};
			case A:
				{from: 7500, to: 10000};
			case F:
				{from: 6000, to: 7500};
			case G:
				{from: 5000, to: 6000};
			case K:
				{from: 3500, to: 5000};
			case M:
				{from: 2000, to: 3000};
		}
	}

	/**
	 * return a star class luminosity range in solar units.
	 */
	public static function luminosity(t:StarType):FloatRange {
		return switch (t) {
			case O:
				{from: 100000, to: 1000000};
			case B:
				{from: 100, to: 100000};
			case A:
				{from: 10, to: 100};
			case F:
				{from: 1.5, to: 10};
			case G:
				{from: 1, to: 1.5};
			case K:
				{from: 0.1, to: 1};
			case M:
				{from: 0.001, to: 0.1};
		}
	}

	/**
	 * return a star class radius range relevant to the Sun.
	 */
	public static function radius(t:StarType):FloatRange {
		return switch (t) {
			case O:
				{from: 10, to: 100};
			case B:
				{from: 5, to: 10};
			case A:
				{from: 1.25, to: 5};
			case F:
				{from: 1, to: 1.25};
			case G:
				{from: 0.9, to: 1};
			case K:
				{from: 0.75, to: 0.9};
			case M:
				{from: 0.1, to: 0.75};
		}
	}
}

class Star implements DataClass {
	var center:Point;
	var orbit:Orbit;
	var type:StarType;
	var temperature:Kelvin;
	var radius:SolarRadius;
	var luminosity:SolarUnit;
}
