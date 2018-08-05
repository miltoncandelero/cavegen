package;

import flash.display.BitmapData;
import js.html.VisibilityState;
import lime.utils.Log;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import src.Cave;

/**
 * ...
 * @author Elemental Code
 */
class CaveViewport extends Sprite 
{
	var viewWidth:Int;
	var viewHeight:Int;
	var b:Bitmap;
	var g:Grid;
	var m:Cave;

	public function new(viewWidth:Int, viewHeight:Int) 
	{
		super();
		this.viewHeight = viewHeight;
		this.viewWidth = viewWidth;
		
				
		b = new Bitmap();
		addChild(b);
		
		g = new Grid(0, 0, 0, 0);
		addChild(g);
		
	}
	
	public function generate(w:Int= 100,h:Int = 70 ,smooth:Int = 3,?gridV:Bool)
	{
		if (gridV != null) gridVisible(gridV);
		
		m = new Cave(w, h);
		m.smooth(smooth);
		try 
		{
			m.clean();
		}
		catch (err:Dynamic)
		{
			Log.warn("Recursion stack overflow. The isolated room check went into overdrive just before killing himself.");
		}
		b.bitmapData = m.bitmapData();
		b.scaleX = b.scaleY = 1;
		b.scaleX = viewWidth / b.width;
		b.scaleY = viewHeight / b.height;
		g.redraw(viewWidth, viewHeight, b.scaleX, b.scaleY);
		if ((b.scaleX < 2 || b.scaleY < 2) && g.visible) Log.warn ("Your grid is getting too small, consider disabling it");
		//b.x = (stage.stageWidth - b.width) / 2;
		//b.y = (stage.stageHeight - b.height) / 2;
	}
	
	public function gridVisible(gridVisible:Bool = true)
	{
		g.visible = gridVisible;
	}
	
	public function getOriginalBitmapData():BitmapData //for some reason, if I don't do it this way the save gives me a black file.
	{
		var bmpData = new BitmapData(Std.int(b.bitmapData.width), Std.int(b.bitmapData.height), false, 0x0);
		bmpData.draw(b);
		return bmpData;
	}
	
	public function getMapInfo() :String
	{
		return (m.json());
	}
	
}