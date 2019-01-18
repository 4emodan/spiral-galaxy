import kha.Scheduler;
import kha.math.FastVector2;
import kha.math.Random;
import kha.Framebuffer;
import kha.Color;
import kha.math.FastMatrix3;
import kha.System;
import Ellipse;

typedef Point = {x:Float, y:Float}

class Game {
	var rotation = 0.01;
	var orbits:Array<Ellipse>;
	var random = new Random(100500);

	public static inline var WIDTH = 320;
	public static inline var HEIGHT = 240;

	public function new() {
		orbits = [for (i in 1...100) new Ellipse(i * 5, i * 3, 12 + i)];
	}

	public function update():Void {
		// rotation += 0.0001;
	}

	public function render(frame:Framebuffer):Void {
		var colBg = Color.Black;
		var colPlane = Color.White;

		var window = {w: System.windowWidth(0), h: System.windowHeight(0)}
		var transform = FastMatrix3.scale(window.w / WIDTH, window.h / HEIGHT);

		var g = frame.g2;
		g.begin();
		g.clear(colBg);
		g.pushTransformation(transform);

		g.color = colPlane;

		var center = {x: window.w / 2, y: window.h / 2};
		for (i in 0...(orbits.length - 1))
			// for (i in 10...25)
		{
			// var i = 24;
			// drawEllipse(orbits[i], center, rotation + i * 0.04, g);
			drawStars(orbits[i], (100 - i) * 10, center, rotation + i * 0.04, g);
		}

		g.popTransformation();
		g.end();
	}

	function drawStars(e:Ellipse, count:Int, center:Point, rotationAngle:Float, g:kha.graphics2.Graphics) {
		var segParam = Math.PI * 2.0 / e.segments;
		var segCount = Std.int(count / e.segments);
		var distribution = 5;

		g.pushTranslation(center.x, center.y);
		g.pushRotation(rotationAngle, center.x, center.y);

		var p1:Point = {x: 0, y: 0};
		var p2:Point = {x: 0, y: 0};

		var t = 0.0;
		var x2 = 0.0, x1 = e.x(t);
		var y2 = 0.0, y1 = e.y(t);
		for (i in 1...e.segments) {
			t += segParam;
			x2 = e.x(t);
			y2 = e.y(t);
			p1 = {x: x1, y: y1};
			p2 = {x: x2, y: y2};
			drawRandomPointsAlongLine(p1, p2, segCount, distribution, g);
			x1 = x2;
			y1 = y2;
		}
		p1 = {x: x2, y: y2};
		p2 = {x: e.x(0), y: e.y(0)};
		drawRandomPointsAlongLine(p1, p2, segCount, distribution, g);

		g.popTransformation();
		g.popTransformation();
	}

	function drawRandomPointsAlongLine(p1:Point, p2:Point, count:Int, distribution:Float, g:kha.graphics2.Graphics) {
		var h = p2.y - p1.y;
		var w = p2.x - p1.x;
		var tan = h / w;
		var angle = Math.atan(tan);
		var d = h / Math.sin(angle);

		var vec1 = new FastVector2();
		var vec2 = new FastVector2();

		var transform = FastMatrix3.rotation(angle);

		for (i in 1...count) {
			vec1.x = random.GetFloatIn(0, d);
			vec1.y = random.GetFloatIn(0 - distribution, distribution);

			vec2 = transform.multvec(vec1);

			g.fillRect(p1.x + vec2.x, p1.y + vec2.y, 1, 1);
		}
	}

	function drawEllipse(e:Ellipse, center:Point, rotationAngle:Float, g:kha.graphics2.Graphics) {
		var segParam = Math.PI * 2.0 / e.segments;

		g.pushTranslation(center.x, center.y);
		g.pushRotation(rotationAngle, center.x, center.y);

		var t = 0.0;
		var x2 = 0.0, x1 = e.x(t);
		var y2 = 0.0, y1 = e.y(t);
		for (i in 1...e.segments) {
			t += segParam;
			x2 = e.x(t);
			y2 = e.y(t);
			g.drawLine(x1, y1, x2, y2, 0.5);
			x1 = x2;
			y1 = y2;
		}
		g.drawLine(x2, y2, e.x(0), e.y(0));

		g.popTransformation();
		g.popTransformation();
	}
}
