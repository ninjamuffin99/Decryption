package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
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

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var grpKeys:FlxTypedGroup<Key>;
	var grpLocks:FlxTypedGroup<Lock>;
	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.WHITE, 2, true);
		
		bgColor = FlxColor.WHITE;

		map = new FlxOgmo3Loader(AssetPaths.daMap__ogmo, AssetPaths.daLevel__json);
		walls = map.loadTilemap(AssetPaths.tileset__png, "tiles");
		walls.follow();
		add(walls);

		_player = new Player(0, 0);
		grpKeys = new FlxTypedGroup<Key>();
		add(grpKeys);

		grpLocks = new FlxTypedGroup<Lock>();
		add(grpLocks);

		map.loadEntities(placeEntities, 'entities');


		_trail = new FlxTrail(_player, null, 10, 24, 0.3, 0.069);
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

		FlxG.camera.follow(_player, null, 0.02);
		FlxG.camera.focusOn(_player.getPosition());
		FlxG.worldBounds.set(0, 0, walls.width, walls.height);

		FlxG.sound.playMusic(AssetPaths.float__mp3);

		super.create();
	}

	function placeEntities(entity:EntityData)
	{
		var daName = entity.name;
		switch (daName)
		{
			case "key":
				var key:Key = new Key(entity.x, entity.y);
				key.canUnlock = entity.values.locknum;
				grpKeys.add(key);
			case 'locked':
				var lock:Lock = new Lock(entity.x, entity.y, entity.width, entity.height);
				lock.unlockedBy = entity.values.locknum;
				grpLocks.add(lock);

				lock.daTexts = new EncText(entity.x + 2, entity.y, entity.width - 4, "", 10);
				add(lock.daTexts);
			case "player":
				_player.setPosition(entity.x, entity.y);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		FlxG.collide(_player, walls);
		FlxG.collide(_player, grpLocks, function(playa:Player, lock:Lock)
		{
			for (i in 0...playa.keysCollected.length)
			{
				if (i == lock.unlockedBy)
				{
					lock.decryptLock();
				}
			}
		});

		FlxG.overlap(_player, grpKeys, function(playa:Player, key:Key)
		{
			playa.keysCollected.push(key.canUnlock);
			key.kill();
		});

		snowShit.setPosition(FlxG.camera.scroll.x + _player.velocity.x, FlxG.camera.scroll.y);
	}
}
