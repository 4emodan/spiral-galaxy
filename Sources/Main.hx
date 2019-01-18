package;

import kha.Color;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import Game;

class Main {
	public static function main() {
		System.start({title: "Project", width: 1024, height: 768}, function(_) {
			// Just loading everything is ok for small projects
			Assets.loadEverything(function() {
				var game = new Game();

				// Avoid passing update/render directly,
				// so replacing them via code injection works
				Scheduler.addTimeTask(function() {
					game.update();
				}, 0, 1 / 60);
				System.notifyOnFrames(function(frames) {
					game.render(frames[0]);
				});
			});
		});
	}
}
