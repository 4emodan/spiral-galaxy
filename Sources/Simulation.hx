import Model.Window;
import haxe.ds.Map;
import kha.Image;
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
import render.Stars.StarRenderer;
import Model.Viewport;

using Utils.OptionExtensions;
using Ellipse.EllipseExtensions;
using Model.ViewportExtensions;

class Simulation {
	var settings:Settings;
	var gameControls:GameControls;
	//
	var colBg = Color.Black;
	var colMain = Color.White;
	var galaxy:Galaxy;
	//
	var viewport:Viewport;
	var zoomLevel = 0;

	public static inline var WIDTH = 320;
	public static inline var HEIGHT = 240;

	public function new(settings:Settings) {
		this.settings = settings;
		gameControls = new GameControls(Mouse.get().toOption());
		init();
	}

	function init() {
		var original:Window = {w: System.windowWidth(0), h: System.windowHeight(0)};
		var target:Window = {w: WIDTH, h:HEIGHT};

		viewport = ViewportExtensions.setup(original, target); 
		galaxy = new Galaxy(viewport.center(), settings.coreRadius, settings.diskRadius, settings.farRadius, settings.starsCount);
	}

	public function update():Void {
		gameControls.consumeZoomEvent(function(e:ZoomEvent) {
			switch (e) {
				case ZoomIn:
					zoomLevel++;
				case ZoomOut:
					zoomLevel--;
			}
			var zoom = if (zoomLevel == 0) {
				1;
			} else {
				Math.pow(if (zoomLevel < 0) settings.zoomInFactor else 1 / settings.zoomInFactor, Math.abs(zoomLevel));
			}
			viewport.applyZoom(zoom);
		});
		gameControls.consumeDragEvent(function(e:DragEvent) {
			switch (e) {
				case DragMove(x, y, dx, dy):
					{
						viewport.origin.x -= dx / viewport.scaleX;
						viewport.origin.y -= dy / viewport.scaleY;
					}
				default:
			}
		});
	}

	public function render(frame:Framebuffer):Void {
		var g = frame.g2;
		g.begin();
		g.clear(colBg);

		g.pushTransformation(viewport.scaleMatrix);
		g.pushTranslation(-viewport.origin.x * viewport.scaleX, -viewport.origin.y * viewport.scaleY);

		g.color = colMain;

		// for (star in galaxy.stars) {
		// 	drawOrbit(star.orbit, g);
		// }

		for (star in galaxy.stars) {
			drawStar(star, g);
		}

		// debugDraw(g);

		g.popTransformation();
		g.popTransformation();
		g.end();
	}

	var haloBank:Map<Int, Image> = [];
	var haloTemplate:Image = null;

	function drawStar(star:Star, g:kha.graphics2.Graphics) {
		var starRadius = settings.sunRadius * star.radius;
		var starColor = StarRenderer.getColor(star.temperature);
		g.color = starColor;

		var halo = haloTemplate;
		if (halo == null) {
			haloTemplate = StarRenderer.getHalo(star);
			halo = haloTemplate;
		}
		var sw = starRadius * 4;
		g.drawScaledImage(halo, star.center.x - sw / 2, star.center.y - sw / 2, sw, sw);
	}

	function drawOrbit(orbit:Orbit, g:kha.graphics2.Graphics) {
		var e = new Ellipse(orbit.center, orbit.angle, orbit.a, orbit.b, 36);
		for (s in e.segments()) {
			g.drawLine(s.p1.x, s.p1.y, s.p2.x, s.p2.y, 0.5);
		}
	}

	function debugDraw(g:kha.graphics2.Graphics) {
		var t = 60000.0;
		var x = 0.0;
		while (t >= 2000) {
			g.color = StarRenderer.getColor(t);
			g.drawRect(x, 0, 1, 1);
			if (t == 7500) {
				g.drawRect(x, -5, 1, 10);
			}
			x += 1;
			t -= 100;
		}
	}
}
