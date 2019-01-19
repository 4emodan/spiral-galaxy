import Model.Star;
import kha.Scheduler;
import kha.math.FastVector2;
import kha.math.Random;
import kha.Framebuffer;
import kha.Color;
import kha.math.FastMatrix3;
import kha.System;
import Ellipse;
import Model.Point;
import Settings;
import Galaxy;

using Ellipse.EllipseExtensions;

class Simulation {
	var settings:Settings;
	//
	var colBg = Color.Black;
	var colMain = Color.White;
	var galaxy:Galaxy;
	//
	var window = {w: 0.0, h: 0.0};
	var scaledWindow = {w: 0.0, h: 0.0};
	var windowScale = FastMatrix3.identity();
	//
	var random = new Random(100500);

	public static inline var WIDTH = 320;
	public static inline var HEIGHT = 240;

	public function new() {
		settings = new Settings(100);
		init();
	}

	public function update():Void {
		// rotation += 0.0001;
	}

	public function render(frame:Framebuffer):Void {
		var g = frame.g2;
		g.begin();
		g.clear(colBg);
		g.pushTransformation(windowScale);

		g.color = colMain;

		// for (orbit in galaxy.orbits) {
		// 	drawOrbit(orbit, g);
		// }

		for (star in galaxy.stars) {
			drawStar(star, g);
		}

		g.popTransformation();
		g.end();
	}

	function init() {
		window = {w: System.windowWidth(0), h: System.windowHeight(0)};
		scaledWindow = {w: WIDTH, h: HEIGHT};
		windowScale = FastMatrix3.scale(window.w / WIDTH, window.h / HEIGHT);

		var center = {x: scaledWindow.w / 2, y: scaledWindow.h / 2};
		galaxy = new Galaxy(center, settings.orbitsCount);
	}

	function drawStar(star:Star, g:kha.graphics2.Graphics) {
		g.drawRect(star.center.x - star.radius, star.center.y - star.radius, star.radius * 2, star.radius * 2);
	}

	function drawOrbit(orbit:Ellipse, g:kha.graphics2.Graphics) {
		for (s in orbit.segments()) {
			g.drawLine(s.p1.x, s.p1.y, s.p2.x, s.p2.y, 0.5);
		}
	}
}
