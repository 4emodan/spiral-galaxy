import kha.input.Mouse;
import galaxy.Orbit;
import galaxy.Star;
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
import galaxy.Galaxy;
import GameControls;

using Utils.OptionExtensions;
using Ellipse.EllipseExtensions;

typedef Viewport = {w:Int, h:Int}

class Simulation {
	var settings:Settings;
	var gameControls:GameControls;
	//
	var colBg = Color.Black;
	var colMain = Color.White;
	var galaxy:Galaxy;
	//
	var window = {w: 0.0, h: 0.0};
	var scaledWindow = {w: 0.0, h: 0.0};
	var viewport:Viewport;
	var windowScale = FastMatrix3.identity();

	public static inline var WIDTH = 320;
	public static inline var HEIGHT = 240;

	public function new() {
		settings = new Settings(1000);
		gameControls = new GameControls(Mouse.get().toOption());
		init();
	}

	function init() {
		window = {w: System.windowWidth(0), h: System.windowHeight(0)};
		scaledWindow = {w: WIDTH, h: HEIGHT};
		windowScale = FastMatrix3.scale(window.w / WIDTH, window.h / HEIGHT);
		viewport = {w: Std.int(scaledWindow.w), h: Std.int(scaledWindow.h)};

		var center = {x: scaledWindow.w / 2, y: scaledWindow.h / 2};
		galaxy = new Galaxy(center, 15, 200, 500, settings.starsCount);
	}

	public function update():Void {
		gameControls.consumeZoomEvent(function(e:ZoomEvent) {
			switch (e) {
				case ZoomIn:
					{
						viewport.w = Std.int(viewport.w * 0.75);
						viewport.h = Std.int(viewport.h * 0.75);
					}
				case ZoomOut:
					{
						viewport.w = Std.int(viewport.w * 1.25);
						viewport.h = Std.int(viewport.h * 1.25);
					}
			}
			windowScale = FastMatrix3.scale(window.w / viewport.w, window.h / viewport.h);
		});
	}

	public function render(frame:Framebuffer):Void {
		var g = frame.g2;
		g.begin();
		g.clear(colBg);
		g.pushTransformation(windowScale);

		g.color = colMain;

		// for (star in galaxy.stars) {
		// 	drawOrbit(star.orbit, g);
		// }

		for (star in galaxy.stars) {
			drawStar(star, g);
		}

		g.popTransformation();
		g.end();
	}

	function drawStar(star:Star, g:kha.graphics2.Graphics) {
		g.drawRect(star.center.x - star.radius, star.center.y - star.radius, star.radius * 2, star.radius * 2);
	}

	function drawOrbit(orbit:Orbit, g:kha.graphics2.Graphics) {
		var e = new Ellipse(orbit.center, orbit.angle, orbit.a, orbit.b, 36);
		for (s in e.segments()) {
			g.drawLine(s.p1.x, s.p1.y, s.p2.x, s.p2.y, 0.5);
		}
	}
}
