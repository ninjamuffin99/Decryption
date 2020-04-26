package;

import flixel.util.FlxTimer;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.effects.particles.FlxParticle;
import flixel.addons.effects.FlxTrailArea;
import flixel.text.FlxText;
import flixel.FlxObject;
import haxe.io.Bytes;
import haxe.crypto.Base64;
import haxe.crypto.Md5;
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
	var camFollow:FlxObject;
	var _trail:FlxTrail;
	private var snowShit:FlxEmitter;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var grpKeys:FlxTypedGroup<Key>;
	var grpLocks:FlxTypedGroup<Lock>;
	var grpFragments:FlxTypedGroup<Fragment>;
	var grpProps:FlxTypedGroup<CutsceneProp>;
	var fragsNeeded:HoverText;

	var trailArea:FlxTrailArea;

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

		grpProps = new FlxTypedGroup<CutsceneProp>();
		add(grpProps);

		grpFragments = new FlxTypedGroup<Fragment>();
		add(grpFragments);


		map.loadEntities(placeEntities, 'entities');

		grpProps.forEach(function(prop:CutsceneProp)
		{
			grpFragments.forEach(function(frag:Fragment)
			{
				if (frag.cutsceneNum == prop.cutsceneNum)
				{
					trace("fragment added");
					prop.grpFrags.add(frag);
					frag.loadGraphicFromSprite(prop);
					frag.alpha = 0.5;
					frag.daProp = prop;
				}
			});
		});

		_trail = new FlxTrail(_player, null, 10, 24, 0.3, 0.069);
		add(_trail);
		
		add(_player);

		trailArea = new FlxTrailArea(0, 0, FlxG.width, FlxG.height);
		trailArea.delay = 15;
		trailArea.alphaMultiplier = 0.3;
		trailArea.simpleRender = true;
		add(trailArea);

		snowShit = new FlxEmitter(20, 20);
		var particleAmounts:Int = 100;
		var partic:ParticleBit;
		var slimPartic:FlxParticle;
		for (i in 0...particleAmounts)
		{
			partic = new ParticleBit();
			snowShit.add(partic);
			if (FlxG.random.bool(70))
				trailArea.add(partic);

			slimPartic = new FlxParticle();
			slimPartic.makeGraphic(1, 4, FlxColor.BLACK);
			snowShit.add(slimPartic);

		}
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

		camFollow = new FlxObject(_player.x, _player.y, 1, 1);
		add(camFollow);

		walls.follow(FlxG.camera);

		FlxG.camera.follow(camFollow, null, 0.02);
		FlxG.camera.focusOn(_player.getPosition());
		FlxG.worldBounds.set(0, 0, walls.width, walls.height);

		FlxG.sound.playMusic(AssetPaths.float__mp3);

		fragsNeeded = new HoverText(0, 0, 0, "", 16);
		fragsNeeded.color = FlxColor.BLACK;
		add(fragsNeeded);

		super.create();
		
	}

	function placeEntities(entity:EntityData)
	{
		var daName = entity.name;
		switch (daName)
		{
			case "fragment":
				var frag:Fragment = new Fragment(entity.x, entity.y);
				frag.cutsceneNum = entity.values.scenenumber;
				grpFragments.add(frag);

				var glitchEffect:FlxEffectSprite;
				add(glitchEffect = new FlxEffectSprite(frag, [new FlxGlitchEffect(5, 2, 0.01)]));
				glitchEffect.setPosition(entity.x, entity.y);
				frag.glitchSprite = glitchEffect;
				frag.fragText = entity.values.fragmessage;

				FlxG.camera.follow(frag);

			case "cutsceneprop":
				var prop:CutsceneProp = new CutsceneProp(entity.x, entity.y);
				prop.cutsceneNum = entity.values.scenenum;
				grpProps.add(prop);

				var glitchEffect:FlxEffectSprite;
				add(glitchEffect = new FlxEffectSprite(prop, [new FlxGlitchEffect(2, 1, 0.02)]));
				glitchEffect.setPosition(prop.x, prop.y);
				prop.glitchEffect = glitchEffect;
			case "key":
				var key:Key = new Key(entity.x, entity.y);
				key.canUnlock = entity.values.locknum;
				grpKeys.add(key);
			case 'locked':
				var lock:Lock = new Lock(entity.x, entity.y, entity.width, entity.height);
				lock.unlockedBy = entity.values.locknum;
				grpLocks.add(lock);
				lock.daTexts = new EncText(entity.x + 2, entity.y, entity.width - 4, "", 16);
				lock.daTexts.endText = entity.values.locktext;
				add(lock.daTexts);

				var loader:LoadingBar = new LoadingBar(entity.x + 2, entity.y - 10);
				loader.makeGraphic(entity.width - 4, 8, FlxColor.BLACK);
				lock.loader = loader;
				loader.scale.x = 0;
				add(loader);

			case "player":
				_player.setPosition(entity.x, entity.y);
		}
	}

	var activeTimer:Int = 0;

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		camFollow.setPosition(_player.x, _player.y);

		FlxG.collide(_player, walls);
		FlxG.collide(_player, grpLocks, function(playa:Player, lock:Lock)
		{
			grpKeys.forEachDead(function(k:Key)
			{
				if (k.collected && k.canUnlock == lock.unlockedBy)
				{
					lock.decryptLock();
				}
			});
		});

		FlxG.overlap(_player, grpKeys, function(playa:Player, key:Key)
		{
			key.collected = true;
			key.kill();
		});

		var overlappingProp:Bool = false;

		FlxG.overlap(_player, grpProps, function(playa:Player, prop:CutsceneProp)
		{
			overlappingProp = true;

			fragsNeeded.textDecoding = prop.amountCollected + "/" + prop.grpFrags.members.length;
			fragsNeeded.setPosition(prop.x, prop.y - 20);
		});

		fragsNeeded.hoverActive = overlappingProp;

		FlxG.overlap(_player, grpFragments, function(playa:Player, frag:Fragment)
		{
			FlxG.camera.flash(FlxColor.WHITE, 0.2);
			new FlxTimer().start(3, function(tmr:FlxTimer)
				{
					activeTimer = 120;
				});
			
			
			frag.daProp.amountCollected += 1;
			frag.collected = true;

			fragsNeeded.textDecoding = frag.daProp.amountCollected + "/" + frag.daProp.grpFrags.members.length;
			fragsNeeded.setPosition(frag.x, frag.y);

			var message:EncText = new EncText(frag.x, frag.y + 12, 0, "", 12);
			message.endText = frag.fragText;
			add(message);
			message.finishText();

			frag.kill();
		});

		if (activeTimer > 0)
		{
			activeTimer--;

			fragsNeeded.hoverActive = true;
		}

		snowShit.setPosition(FlxG.camera.scroll.x + _player.velocity.x, FlxG.camera.scroll.y);
		trailArea.setPosition(FlxG.camera.scroll.x, snowShit.y);
	}
}
