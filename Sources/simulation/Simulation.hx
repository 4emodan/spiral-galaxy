package simulation;

import kha.Image;
import kha.input.Mouse;
import kha.Framebuffer;
import kha.Color;
import kha.System;
import core.galaxy.Galaxy;
import core.galaxy.Orbit;
import core.galaxy.Star;
import core.model.Ellipse;
import simulation.render.Stars.StarRenderer;
import simulation.Settings;
import simulation.Controls;
import simulation.Model.Viewport;
import simulation.Model.Window;

using core.Utils.OptionExtensions;
using core.model.Ellipse.EllipseExtensions;
using simulation.Settings.SettingsExtensions;
using simulation.Model.ViewportExtensions;
using simulation.Utils.ViewportUtils;

class Simulation {
	var settings:Settings;
	var gameControls:Controls;
	//
	var deepSpaceColor = Color.Black;
	var galaxy:Galaxy;
	//
	var viewport:Viewport;
	var zoomLevel = 0;

	public static inline var WIDTH = 320;
	public static inline var HEIGHT = 240;

	public function new(settings:Settings) {
		this.settings = settings;
		gameControls = new Controls(Mouse.get().toOption());
		init();
	}

	function init() {
		var original:Window = {w: System.windowWidth(0), h: System.windowHeight(0)};
		var target:Window = {w: WIDTH, h: HEIGHT};

		viewport = ViewportUtils.setup(original, target);
		galaxy = new Galaxy(settings.galaxySettings(), viewport.center());
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
						viewport.origin.x -= dx / viewport.scale;
						viewport.origin.y -= dy / viewport.scale;
					}
				default:
			}
		});
	}

	public function render(frame:Framebuffer):Void {
		var g = frame.g2;
		g.begin();
		g.clear(deepSpaceColor);

		g.pushTransformation(viewport.scaleMatrix);
		g.pushTranslation(viewport.margin.x - viewport.origin.x * viewport.scale, viewport.margin.y - viewport.origin.y * viewport.scale);

		g.color = Color.White;

		for (star in galaxy.stars) {
			drawStar(star, g);
		}

		// debugDraw(g);

		g.popTransformation();
		g.popTransformation();
		g.end();
	}

	private var haloTemplate:Image = null;

	function drawStar(star:Star, g:kha.graphics2.Graphics) {
		var starRadius = settings.sunRadius * star.radius;
		var starColor = StarRenderer.getColor(star.temperature);

		g.color = starColor; // Tint halo with star color

		var halo = haloTemplate;
		if (halo == null) {
			haloTemplate = StarRenderer.generateHaloTemplate(256);
			halo = haloTemplate;
		}
		var haloSize = starRadius * 4; // TODO: Depends on luminosity and star size
		g.drawScaledImage(halo, star.center.x - haloSize / 2, star.center.y - haloSize / 2, haloSize, haloSize);
	}

	function debugDraw(g:kha.graphics2.Graphics) {
		// Draw orbits 
		// function drawEllipse(e:Ellipse) {
		// 	for (s in e.segments(36)) {
		// 		g.drawLine(s.p1.x, s.p1.y, s.p2.x, s.p2.y, 0.5);
		// 	}
		// }
		// function drawOrbit(orbit:Orbit, g:kha.graphics2.Graphics) {
		// 	var e = new Ellipse(orbit.center, orbit.angle, orbit.a, orbit.b);
		// 	drawEllipse(e);
		// }

		// var count = 100;
		// var width = Std.int(galaxy.stars.length / count);
		// for (i in 0...count) {
		// 	drawOrbit(galaxy.stars[i * width].orbit, g);
		// }

		// g.color = Color.Yellow;
		// var circle = new Ellipse(galaxy.center, 0, settings.coreRadius, settings.coreRadius);
		// drawEllipse(circle);

		// g.color = Color.Yellow;
		// circle = new Ellipse(galaxy.center, 0, settings.diskRadius, settings.diskRadius);
		// drawEllipse(circle);

		// Draw viewport
		// g.color = Color.Yellow;
		// g.drawRect(viewport.origin.x, viewport.origin.y, viewport.w, viewport.h);
	}
}
