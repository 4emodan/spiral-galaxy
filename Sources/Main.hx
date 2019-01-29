package;

import kha.Color;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import Simulation;

class Main {
	public static function main() {
		System.start({title: "Starfield", width: 1024, height: 768}, function(_) {
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
		});
	}
}
