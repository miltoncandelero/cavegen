package;

import haxe.Constraints.Function;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Elemental Code
 */
class UI extends Sprite 
{
	var txtW:TextField;
	var txtH:TextField;
	var txtS:TextField;
	var showGrid:CheckBox;

	public var generator:Function;//(Int, Int, Int, Bool);
	public var changeGridVisibility:Function;// (Bool);
	public var saveOriginal:Function;
	public var saveCanvas:Function;
	public var saveJson:Function;
	
	public function new() 
	{
		super();
		
		graphics.lineStyle(2, 0xFFFFFF);
		graphics.beginFill(0x0, 0);
		graphics.drawRect(5, 5, 126, 360 - 10);
		
		var txtDungen:TextField = new TextField();
		txtDungen.type = TextFieldType.DYNAMIC;
		txtDungen.text = "CAVEGEN";
		txtDungen.defaultTextFormat = new TextFormat("Consolas", 22, 0xFFFFFF, true, false, false, null, null, TextFormatAlign.CENTER);
		txtDungen.x = 5;
		txtDungen.width = 126;
		txtDungen.selectable = false;
		addChild(txtDungen);
		
		var txtBy:TextField = new TextField();
		txtBy.type = TextFieldType.DYNAMIC;
		txtBy.text = "by Elemental Code";
		txtBy.defaultTextFormat = new TextFormat("Consolas", 10, 0xFFFFFF, false, true, false, null, null, TextFormatAlign.CENTER);
		txtBy.x = 5;
		txtBy.y = 20;
		txtBy.width = 126;
		txtBy.selectable = false;
		addChild(txtBy);
		
		var txtWInfo:TextField = new TextField();
		txtWInfo.type = TextFieldType.DYNAMIC;
		txtWInfo.text = "Width";
		txtWInfo.defaultTextFormat = new TextFormat("Consolas", 12, 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
		txtWInfo.x = 5;
		txtWInfo.y = 35;
		txtWInfo.width = 126;
		txtWInfo.selectable = false;
		addChild(txtWInfo);
		
		var txtHInfo:TextField = new TextField();
		txtHInfo.type = TextFieldType.DYNAMIC;
		txtHInfo.text = "Height";
		txtHInfo.defaultTextFormat = new TextFormat("Consolas", 12, 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
		txtHInfo.x = 5;
		txtHInfo.y = 80;
		txtHInfo.width = 126;
		txtHInfo.selectable = false;
		addChild(txtHInfo);
		
		var txtSInfo:TextField = new TextField();
		txtSInfo.type = TextFieldType.DYNAMIC;
		txtSInfo.text = "Smoothness";
		txtSInfo.defaultTextFormat = new TextFormat("Consolas", 12, 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
		txtSInfo.x = 5;
		txtSInfo.y = 125;
		txtSInfo.width = 126;
		txtSInfo.selectable = false;
		addChild(txtSInfo);
		
		var txtGInfo:TextField = new TextField();
		txtGInfo.type = TextFieldType.DYNAMIC;
		txtGInfo.text = "Show grid";
		txtGInfo.defaultTextFormat = new TextFormat("Consolas", 12, 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
		txtGInfo.x = 5;
		txtGInfo.y = 168;
		txtGInfo.width = 126;
		txtGInfo.selectable = false;
		addChild(txtGInfo);
		
		var txtSaveInfo:TextField = new TextField();
		txtSaveInfo.type = TextFieldType.DYNAMIC;
		txtSaveInfo.text = "Save";
		txtSaveInfo.defaultTextFormat = new TextFormat("Consolas", 16, 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
		txtSaveInfo.x = 5;
		txtSaveInfo.y = 260;
		txtSaveInfo.width = 126;
		txtSaveInfo.selectable = false;
		addChild(txtSaveInfo);
		
		txtW = new TextField();
		txtW.type = TextFieldType.INPUT;
		txtW.border = true;
		txtW.borderColor = 0xFFFFFF;
		txtW.maxChars = 4;
		txtW.restrict = "0-9";
		txtW.defaultTextFormat = new TextFormat("Consolas", 16, 0xFFFFFF,false,false,false,null,null, TextFormatAlign.CENTER);
		txtW.width = 50;
		txtW.height = 22;
		txtW.x = (126 - 50) / 2 + 5;
		txtW.y = 50;
		txtW.text = "100";
		addChild(txtW);
		
		txtH = new TextField();
		txtH.type = TextFieldType.INPUT;
		txtH.border = true;
		txtH.borderColor = 0xFFFFFF;
		txtH.maxChars = 4;
		txtH.restrict = "0-9";
		txtH.defaultTextFormat = new TextFormat("Consolas", 16, 0xFFFFFF,false,false,false,null,null, TextFormatAlign.CENTER);
		txtH.width = 50;
		txtH.height = 22;
		txtH.x = (126 - 50) / 2 + 5;
		txtH.y = 95;
		txtH.text = "70";
		addChild(txtH);
		
		txtS = new TextField();
		txtS.type = TextFieldType.INPUT;
		txtS.border = true;
		txtS.borderColor = 0xFFFFFF;
		txtS.maxChars = 4;
		txtS.restrict = "0-9";
		txtS.defaultTextFormat = new TextFormat("Consolas", 16, 0xFFFFFF,false,false,false,null,null, TextFormatAlign.CENTER);
		txtS.width = 50;
		txtS.height = 22;
		txtS.x = (126 - 50) / 2 + 5;
		txtS.y = 140;
		txtS.text = "3";
		addChild(txtS);
		
		showGrid = new CheckBox(checkboxCallback);
		showGrid.x = (126 - 20) / 2 + 5;
		showGrid.y = 185;
		showGrid.value = true;
		addChild(showGrid);
		
		var btnGenerate:TextField = new TextField();
		btnGenerate.border = true;
		btnGenerate.borderColor = 0xFFFFFF;
		btnGenerate.type = TextFieldType.DYNAMIC;
		btnGenerate.text = "GENERATE";
		btnGenerate.defaultTextFormat = new TextFormat("Consolas", 16, 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
		btnGenerate.x = 10;
		btnGenerate.y = 220;
		btnGenerate.width = 116;
		btnGenerate.height = 22;
		btnGenerate.selectable = false;
		btnGenerate.addEventListener(MouseEvent.CLICK, generate);
		addChild(btnGenerate);
		
		var btnSaveCanvas:TextField = new TextField();
		btnSaveCanvas.border = true;
		btnSaveCanvas.borderColor = 0xFFFFFF;
		btnSaveCanvas.type = TextFieldType.DYNAMIC;
		btnSaveCanvas.text = "PNG preview";
		btnSaveCanvas.defaultTextFormat = new TextFormat("Consolas", 12, 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
		btnSaveCanvas.x = 10;
		btnSaveCanvas.y = 280;
		btnSaveCanvas.width = 116;
		btnSaveCanvas.height = 18;
		btnSaveCanvas.selectable = false;
		btnSaveCanvas.addEventListener(MouseEvent.CLICK, _saveCanvas);
		addChild(btnSaveCanvas);
		
		var btnSaveOriginal:TextField = new TextField();
		btnSaveOriginal.border = true;
		btnSaveOriginal.borderColor = 0xFFFFFF;
		btnSaveOriginal.type = TextFieldType.DYNAMIC;
		btnSaveOriginal.text = "PNG original";
		btnSaveOriginal.defaultTextFormat = new TextFormat("Consolas", 12, 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
		btnSaveOriginal.x = 10;
		btnSaveOriginal.y = 300;
		btnSaveOriginal.width = 116;
		btnSaveOriginal.height = 18;
		btnSaveOriginal.selectable = false;
		btnSaveOriginal.addEventListener(MouseEvent.CLICK, _saveOriginal);
		addChild(btnSaveOriginal);
		
		var btnSaveJSON:TextField = new TextField();
		btnSaveJSON.border = true;
		btnSaveJSON.borderColor = 0xFFFFFF;
		btnSaveJSON.type = TextFieldType.DYNAMIC;
		btnSaveJSON.text = "JSON data";
		btnSaveJSON.defaultTextFormat = new TextFormat("Consolas", 12, 0xFFFFFF, false, false, false, null, null, TextFormatAlign.CENTER);
		btnSaveJSON.x = 10;
		btnSaveJSON.y = 320;
		btnSaveJSON.width = 116;
		btnSaveJSON.height = 18;
		btnSaveJSON.selectable = false;
		btnSaveJSON.addEventListener(MouseEvent.CLICK, _saveJSON);
		addChild(btnSaveJSON);
		
	}
	
	function _saveJSON(e:MouseEvent):Void 
	{
		saveJson();
	}
	
	function _saveOriginal(e:MouseEvent):Void 
	{
		saveOriginal();
	}
	
	function _saveCanvas(e:MouseEvent):Void 
	{
		saveCanvas();
	}
	
	function generate(e:MouseEvent):Void 
	{
		generator(Std.parseInt(txtW.text), Std.parseInt(txtH.text), Std.parseInt(txtS.text), showGrid.value);
	}
	function checkboxCallback(b:Bool)
	{
		changeGridVisibility(b);
	}
	
}