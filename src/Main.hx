package;


import lime.ui.FileDialog;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.display.Sprite;
import openfl.utils.ByteArray;


/**
 * Quick genetic cave generation example
 * @author Elemental Code
 */
class Main extends Sprite 
{
	var cave:CaveViewport;
	
	public function new() 
	{
		super();
		
		graphics.lineStyle(2, 0xFFFFFF);
		graphics.beginFill(0x0, 0);
		graphics.drawRect(135, 5, 500, 360 - 10);
		
		cave = new CaveViewport(500, 350);
		cave.x = 135;
		cave.y = 5;
		addChild(cave);
				
		var ui:UI = new UI();
		addChild(ui);
		ui.changeGridVisibility = cave.gridVisible;
		ui.generator = cave.generate;
		ui.saveCanvas = saveCanvas;
		ui.saveOriginal = saveOriginal;
		ui.saveJson = saveData;
		
		ui.generator();
	}
	
	function saveOriginal() 
	{
		saveImage(cave.getOriginalBitmapData());
	}
	
	function saveCanvas() 
	{
		var b:BitmapData = new BitmapData(500, 350, true, 0x0);
		b.draw(cave);
		saveImage(b);
	}
	
	function saveData()
	{
		new FileDialog().save(cave.getMapInfo(), "json", "cave.json");
	}
	
	public static function saveImage(bitmapData:BitmapData)
	{
		var b:ByteArray = new ByteArray();
		b = bitmapData.encode(bitmapData.rect, new PNGEncoderOptions(true), b);
		new FileDialog().save(b, "png", "cave.png");
	}
}
