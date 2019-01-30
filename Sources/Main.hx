package;

import kha.Assets;
import kha.Scheduler;
import kha.System;
import kha.Window;
import kha.CompilerDefines;
#if kha_html5
import js.html.CanvasElement;
import js.Browser.document;
import js.Browser.window;
#end
import simulation.Simulation;
import simulation.Settings;

class Main {
	public static function main() {
		setFullWindowCanvas();
		System.start({title: "Starfield", width: 1024, height: 768}, init);
	}

	static function init(window:Window):Void {
		// Just loading everything is ok for small projects
		Assets.loadEverything(function() {
			var settings = new Settings(1.25, 100000, 15, 200, 500, 0.075, 0.042, 0.65, 1);
			var simulation = new Simulation(settings);

			// Avoid passing update/render directly,
			// so replacing them via code injection works
			Scheduler.addTimeTask(function() {
				simulation.update();
			}, 0, 1 / 60);
			System.notifyOnFrames(function(frames) {
				simulation.render(frames[0]);
			});
		});
	}

	static function setFullWindowCanvas():Void {
		#if kha_html5
		// make html5 canvas resizable
		document.documentElement.style.padding = "0";
		document.documentElement.style.margin = "0";
		document.body.style.padding = "0";
		document.body.style.margin = "0";
		var canvas:CanvasElement = cast document.getElementById(CompilerDefines.canvas_id);
		canvas.style.display = "block";

		var resize = function() {
			canvas.width = Std.int(window.innerWidth * window.devicePixelRatio);
			canvas.height = Std.int(window.innerHeight * window.devicePixelRatio);
			canvas.style.width = document.documentElement.clientWidth + "px";
			canvas.style.height = document.documentElement.clientHeight + "px";
		}
		window.onresize = resize;
		resize();
		#end
	}
}
