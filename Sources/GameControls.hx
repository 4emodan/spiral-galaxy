import kha.input.Mouse;
import haxe.ds.Option;

class GameControls {
	var zoomEvent:Option<ZoomEvent> = None;

	public function new(mouse:Option<Mouse>) {
		switch (mouse) {
			case Some(v):
				v.notify(onMouseDown, onMouseUp, null, onMouseWheel);
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

	function onMouseDown(button:Int, x:Int, y:Int) {}

	function onMouseUp(button:Int, x:Int, y:Int) {}

	function onMouseWheel(direction:Int) {
		zoomEvent = if (direction < 0) Some(ZoomIn) else Some(ZoomOut);
	}
}

enum ZoomEvent {
	ZoomIn;
	ZoomOut;
}
