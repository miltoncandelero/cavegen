package src;
import haxe.Json;
import lime.utils.Log;
import openfl.display.BitmapData;
import lime.math.Rectangle;


/**
 * Genetic Cave
 * @author Elemental Code
 */
class Cave 
{
	private var _map:Array<Array<Int>>;
	public var roomAttempts:Int = 500;

	public function new(w:Int, h:Int, rooms:Bool = false) 
	{
		if (rooms)
		{
			makeRooms(w,h);
		}
		else 
		{
			makeRandom(w,h);
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
	
	private function makeRandom(w:Int, h:Int)
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

	private function makeRooms(w:Int, h:Int) {

		var minRoomWidth:Int = 5;
		var minRoomHeight:Int = 5;
		var maxRoomWidth:Int = Std.int(w / 4);
		var maxRoomHeight:Int = Std.int(h / 4);

		_map = new Array<Array<Int>>();
		for (i in 0...w) {
			_map[i] = new Array<Int>();
			for (j in 0...h) {
				_map[i][j] = 1; // all walls to begin with
				// _map[i][j] = Math.round(Math.random()-0.05);
			}
		}

		// while (!makeRoom(1+Std.int(Math.random()*w/2),1+Std.int(Math.random()*h/2),2+Std.int(Math.random()*w/2),2+Std.int(Math.random()*h/2))){} //good ol' empty while

		var rooms = new Array<Rectangle>();

		for (i in 0...roomAttempts) {
			var rX:Int = Std.int(Math.random() * w);
			var rY:Int = Std.int(Math.random() * h);
			var rW:Int = minRoomWidth + Std.int(Math.random() * Math.min(w - rX,maxRoomWidth - minRoomWidth)); //I have to check here or otherwise I highly unbalance the rooms that get the max size.
			var rH:Int = minRoomHeight + Std.int(Math.random() * Math.min(h - rY,maxRoomHeight - minRoomHeight));
			//Lets see = The minimun + from zero to almost 1 * The lesser value from "The amounts of cell left" vs the biggest room possible minus the smallest.
			//I substract the smallest room from the biggest because we always add the biggest room possible at the beginning.


			if (makeRoom(rX, rY, rW, rH)) {
				rooms.push(new Rectangle(rX,rY,rW,rH));
			}
		}

		for (i in 0...rooms.length-1) 
		{
			var toIntersect = rooms[i+1];
			var actual = rooms[i];

			//code stolen from Rectangle.intersection.
			var x0 = actual.x < toIntersect.x ? toIntersect.x : actual.x;
			var w0 = actual.x < toIntersect.x ? toIntersect.width : actual.width;
			var x1 = actual.right > toIntersect.right ? toIntersect.right : actual.right;
			var w1 = actual.right > toIntersect.right ? toIntersect.width : actual.width;
			var y0 = actual.y < toIntersect.y ? toIntersect.y : actual.y;
			var h0 = actual.y < toIntersect.y ? toIntersect.height : actual.height;
			var y1 = actual.bottom > toIntersect.bottom ? toIntersect.bottom : actual.bottom;
			var h1 = actual.bottom > toIntersect.bottom ? toIntersect.height : actual.height;

			if (x1 > x0) {
				
				var tX = Std.int(x0 + Math.random() * (x1 - x0-1));
				var tY = Std.int(y1);
				var tW = 2;
				var tH = Std.int(y0 - y1);
				makeRoom(tX,tY,tW,tH,true);
				//aligned vertically
				continue;

			}

			if (y1 > y0) {

				var tX = Std.int(x1);
				var tY = Std.int(y0 + Math.random() * (y1 - y0-1));
				var tW = Std.int(x0 - x1);
				var tH = 2;
				makeRoom(tX,tY,tW,tH,true);
				//aligned horizontally.
				continue;
			}

			//Couldn't figure out how to make elbows.
			//Any unconnected room shall be destroyed by the "clean" method.

		}
	}

	private function makeRoom(x:Int, y:Int, w:Int, h:Int,force:Bool = false):Bool {
		for (i in x - 1...x + w + 1) {
			if (_map[i] == null)
				return false;
			for (j in y - 1...y + h + 1) {
				if (_map[i][j] == null || (_map[i][j] == 0 && !force))
					return false;
			}
		}
		// if we get to here, we can add the room.
		for (i in x...x + w) {
			for (j in y...y + h) {
				_map[i][j] = 0;
			}
		}
		return true;
	}


}