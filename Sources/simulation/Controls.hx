package simulation;

import haxe.ds.Option;
import kha.input.Mouse;
import core.model.Model.Point;

using core.Utils.OptionExtensions;

class Controls {
	var zoomEvent:Option<ZoomEvent> = None;
	var dragEvent:Option<DragEvent> = None;
	var mouseDown = false;

	public function new(mouse:Option<Mouse>) {
		switch (mouse) {
			case Some(v):
				v.notify(onMouseDown, onMouseUp, onMouseMove, onMouseWheel);
			case None:
		}
	}

	public function consumeZoomEvent(action:ZoomEvent->Void) {
		switch (zoomEvent) {
			case Some(v):
				action(v);
			case None:
		}
		zoomEvent = None;
	}

	public function consumeDragEvent(action:DragEvent->Void) {
		switch (dragEvent) {
			case Some(v):
				action(v);
			case None:
		}
		dragEvent = None;
	}

	function onMouseDown(button:Int, x:Int, y:Int) {
		mouseDown = true;
		dragEvent = DragEvent.DragStart(x, y).toOption();
        trace('Click at $x, $y');
	}

	function onMouseUp(button:Int, x:Int, y:Int) {
		mouseDown = false;
		dragEvent = DragEvent.DragEnd(x, y).toOption();
	}

	function onMouseMove(x:Int, y:Int, moveX:Int, moveY:Int) {
		if (mouseDown) {
			dragEvent = DragEvent.DragMove(x, y, moveX, moveY).toOption();
		}
	}

	function onMouseWheel(direction:Int) {
		zoomEvent = if (direction < 0) Some(ZoomIn) else Some(ZoomOut);
	}
}

enum ZoomEvent {
	ZoomIn;
	ZoomOut;
}

enum DragEvent {
	DragStart(x:Int, y:Int);
	DragMove(x:Int, y:Int, dx:Int, dy:Int);
	DragEnd(x:Int, y:Int);
}
