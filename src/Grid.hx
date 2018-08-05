package;

import openfl.display.Sprite;

/**
 * ...
 * @author Elemental Code
 */
class Grid extends Sprite 
{

	public function new(w:Int, h:Int, boxW:Float, boxH:Float) 
	{
		super();
		
		redraw(w, h, boxW, boxH);
	}
	
	public function redraw(w:Int, h:Int, boxW:Float, boxH:Float) 
	{
		graphics.clear();
		graphics.beginFill(0x333333);
		
		for (i in 0...Math.floor(w/boxW)) 
		{
			graphics.drawRect(i*boxW - 0.5, 0,1 , h);
		}
		
		for (j in 0...Math.floor(h/boxH) )
		{
			graphics.drawRect(0, j*boxH - 0.5, w, 1);
		}
		
		graphics.endFill();
	}
	
}