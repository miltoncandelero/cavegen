package;

import haxe.Constraints.Function;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Elemental Code
 */
class CheckBox extends Sprite 
{
	var size:Int;
	var color:Int;
	var stroke:Int;
	var clickExtraCallback:Function;//(Bool)->null;
	public var value(default, set):Bool = false;

	public function new(size:Int = 20, color:Int = 0xFFFFFFFF, stroke:Int = 2, clickExtraCallback:Function = null) 
	{
		super();
		this.clickExtraCallback = clickExtraCallback;
		this.stroke = stroke;
		this.color = color;
		this.size = size;
		graphics.lineStyle(stroke, color);
		graphics.beginFill(0x0, 0);
		graphics.drawRect(0, 0, size, size);
		
		addEventListener(MouseEvent.CLICK, click, false, 0, true);	
	}
	
	function click(e:MouseEvent):Void 
	{
		value = !value;
		if (clickExtraCallback != null) clickExtraCallback(value);
	}
	
	function set_value(val:Bool):Bool 
	{
		value = val;
		draw();
		return val;
	}
	
	function draw()
	{
		graphics.clear();
		graphics.lineStyle(stroke, color);
		graphics.beginFill(0x0, 0);
		graphics.drawRect(0, 0, size, size);
		if (value) 
		{
			graphics.moveTo(0, 0);
			graphics.lineTo(size, size);
			graphics.moveTo(size, 0);
			graphics.lineTo(0, size);
		}
	}
	
}