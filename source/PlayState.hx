package;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.addons.effects.FlxTrail;
import flixel.util.FlxColor;
import flixel.FlxState;

class PlayState extends FlxState
{

	var _player:Player;
	var _trail:FlxTrail;
	private var snowShit:FlxEmitter;
	override public function create():Void
	{
		bgColor = FlxColor.WHITE;

		_player = new Player(100, 100);
		_trail = new FlxTrail(_player, null, 30, 0, 0.5, 0.05);
		add(_trail);
		
		add(_player);

		snowShit = new FlxEmitter(20, 20);
		snowShit.makeParticles(1, 4, FlxColor.BLACK, 200);
		snowShit.makeParticles(1, 7, FlxColor.BLACK, 200);
		snowShit.lifespan.set(2, 33);
		snowShit.launchMode = FlxEmitterMode.SQUARE;
		
		snowShit.velocity.set(5, 20, 20, 30, -2);

		snowShit.velocity.start.min.y = 5;
		snowShit.velocity.start.max.y = 5;
		snowShit.velocity.end.min.y = 25;
		snowShit.velocity.end.max.y = 25;

		snowShit.alpha.set(0.8, 1, 0, 0);
		

		snowShit.start(false, 0.8);
		snowShit.width = FlxG.width;
		snowShit.height = FlxG.height;
		add(snowShit);

		FlxG.camera.follow(_player);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		snowShit.setPosition(FlxG.camera.scroll.x + _player.velocity.x, FlxG.camera.scroll.y);
	}
}
