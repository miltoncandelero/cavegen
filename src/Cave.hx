package src;
import haxe.Json;
import lime.utils.Log;
import openfl.display.BitmapData;

/**
 * Genetic Cave
 * @author Elemental Code
 */
class Cave 
{
	private var _map:Array<Array<Int>>;
	public function new(w:Int, h:Int) 
	{
		_map = new Array<Array<Int>>();
		for (i in 0...w) 
		{
			_map[i] = new Array<Int>();
			for (j in 0...h) 
			{
				_map[i][j] = Math.round(Math.random()-0.05);
			}
		}
	}
	
	public function print():String
	{
		var retval:String = "";
		for (i in _map) 
		{
			retval += "\n";
			for (j in i) 
			{
				retval += j;
			}
		}
		
		return retval;
	}
	
	public function json():String
	{
		var tmpArr:Array<Int> = new Array<Int>();
		for (i in _map) 
		{
			tmpArr = tmpArr.concat(i);
		}
		return Json.stringify({
			width:_map.length,
			height: _map[0].length,
			map: tmpArr
		});
	}
	
	public function bitmapData():BitmapData
	{
		var retval:BitmapData = new BitmapData(_map.length, _map[0].length, false, 0x0);
		for (i in 0..._map.length) 
		{
			for (j in 0..._map[i].length) 
			{
				retval.setPixel(i, j, (_map[i][j] == 1?0x0:0xFFFFFF));
			}
		}
		return retval;
	}
	
	
	public function smooth(times:Int = 1)
	{
		for (i in 0...times) 
		{
			_smooth();
		}
	}
	
	
	public function clean()
	{
		_stroke();
		_eraseIsolated();
		
		if (fillRatio() > 0.55) Log.warn("Fill rate over 55%. Consider generating another map. (Fill rate = " + fillRatio() * 100 +"%)");
	}
	
	private function _stroke()
	{
		for (i in 0..._map[0].length) 
		{
			_map[0][i] = 1;
			_map[_map.length-1][i] = 1;
		}
		
		for (i in 0..._map.length) 
		{
			_map[i][0] = 1;
			_map[i][_map[i].length-1] = 1;
		}
	}
	
	//Needs improvement!
	private function _eraseIsolated()
	{
		var fillTool:Int = 2;
		var count:Array<Int> = new Array<Int>();
		
		for (i in 0..._map.length) 
		{
			for (j in 0..._map[i].length) 
			{
				if (_map[i][j] == 0) 
				{
					count[fillTool] = _fill(i, j, fillTool);
					fillTool++;
				}
			}
		}
		
		var winner:Int = 1;
		var prevMax:Int = -1;
		for (k in 2...count.length) 
		{
			if (count[k] > prevMax) 
			{
				winner = k;
				prevMax = count[k];
			}
		}
		
		for (i in 0..._map.length) 
		{
			for (j in 0..._map[i].length) 
			{
				if (_map[i][j] == winner) 
				{
					_map[i][j] = 0;
				}
				else 
				{
					_map[i][j] = 1;
				}
			}
		}
		
		
		
		
	}
	
	public function fillRatio()
	{
		var walls:Int = 0;
		for (i in _map) 
		{
			for (j in i) 
			{
				walls += j;
			}
		}
		
		return (walls / (_map.length * _map[0].length));
	}
	
	private function _smooth()
	{
		//create temp new map.
		var newCave:Array<Array<Int>>;
		newCave = new Array<Array<Int>>();
		for (x in 0..._map.length) 
		{
			newCave[x] = new Array<Int>();
		}
		

		//Check every single cell.
		for (i in 0..._map.length) 
		{
			for (j in 0..._map[i].length) 
			{				
				if (countWalls(i, j) >= 5) 
					newCave[i][j] = 1; 
				else 
					newCave[i][j] = 0; 
			}
		}
		
		_map = newCave;
		
	}
	
	private function countWalls(i:Int,j:Int):Int
	{
		var retval :Int = 0;
		
		if (i != 0) //If I can go left
		{
			retval += _map[i - 1][j]; //left center
			retval += (j != 0)?_map[i - 1][j - 1]:1; //left up
			retval += (j != _map[i].length - 1)?_map[i - 1][j + 1]:1; //left down
		}
		else 
		{
			retval += 3; //couldn't go left. make it al walls.
		}
		
		retval += _map[i][j]; //center
		retval += (j != 0)?_map[i][j - 1]:1; //center left
		retval += (j != _map[i].length - 1)?_map[i][j + 1]:1; //center right
		
		
		if (i != _map.length - 1) //If I can go right
		{
			retval += _map[i + 1][j]; //right center
			retval += (j != 0)?_map[i + 1][j - 1]:1; //right up
			retval += (j != _map[i].length - 1)?_map[i + 1][j + 1]:1; //right down
		}
		else
		{
			retval += 3; //couldn't go right, make it all walls
		}
		
		return retval;
	}
	
	private function _fill(i:Int,j:Int,fill:Int):Int
	{
		if (_map[i][j] == fill) return 0;
		if (_map[i][j] != 0) return 0;
		
		var retval:Int = 1;
		_map[i][j] = fill;

		if (i != 0) retval += _fill(i - 1, j, fill);
		if (i != _map.length - 1) retval += _fill(i + 1, j, fill);
		
		if (j != 0) retval += _fill(i, j - 1, fill);
		if (j != _map.length - 1) retval += _fill(i, j + 1, fill);	
		
		return retval;
	}
	
}