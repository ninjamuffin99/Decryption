package;

import flixel.addons.effects.FlxTrail;
import flixel.util.FlxColor;
import flixel.FlxState;

class PlayState extends FlxState
{

	var _player:Player;
	var _trail:FlxTrail;
	override public function create():Void
	{
		bgColor = FlxColor.WHITE;

		_player = new Player(100, 100);
		_trail = new FlxTrail(_player);
		add(_trail);
		
		add(_player);

		

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
