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
	public static var PLAYER:Player;

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
	var grpHidden:FlxTypedGroup<HiddenMessage>;
	var fragsNeeded:HoverText;

	var trailArea:FlxTrailArea;

	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.WHITE, 2, true);
		
		bgColor = FlxColor.WHITE;

		map = new FlxOgmo3Loader(AssetPaths.daMap__ogmo, AssetPaths.daLevel__json);
		walls = map.loadTilemap(AssetPaths.betterTileslol__png, "tiles");
		walls.follow();
		add(walls);

		_player = new Player(0, 0);
		PLAYER = _player;
		grpKeys = new FlxTypedGroup<Key>();
		add(grpKeys);

		grpLocks = new FlxTypedGroup<Lock>();
		add(grpLocks);

		grpProps = new FlxTypedGroup<CutsceneProp>();
		add(grpProps);

		grpFragments = new FlxTypedGroup<Fragment>();
		add(grpFragments);

		grpHidden = new FlxTypedGroup<HiddenMessage>();
		add(grpHidden);


		map.loadEntities(placeEntities, 'entities');

		grpKeys.forEach(function(k:Key)
		{
			grpLocks.forEach(function(lock:Lock){
				if (lock.unlockedBy == k.canUnlock)
				{
					k.daDoor = lock;
				}
			});
		});


		grpFragments.forEach(function(frag:Fragment)
		{
			grpProps.forEach(function(prop:CutsceneProp)
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

			grpHidden.forEach(function(message:HiddenMessage)
			{
				if (frag.fragid == message.fragid)
				{
					message.daFrag = frag;
					frag.grpMessages.add(message);
					message.daPlayer = _player;
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

		FlxG.sound.playMusic(AssetPaths.musicLoop__mp3);
		FlxG.sound.music.fadeIn(7, 0, 0.9);

		fragsNeeded = new HoverText(0, 0, 0, "", 16);
		fragsNeeded.color = FlxColor.BLACK;
		add(fragsNeeded);

		curDialogue = new CutsceneText(0, 0, 160, "", 12);
		add(curDialogue);
		curDialogue.visible = false;

		super.create();
		
	}

	function placeEntities(entity:EntityData)
	{
		var daName = entity.name;
		switch (daName)
		{
			case "secretmessage":
				var secret:HiddenMessage = new HiddenMessage(entity.x, entity.y, entity.width, "", 12);
				secret.endText = entity.values.message;
				secret.fragid = entity.values.fragid;
				grpHidden.add(secret);
			case "fragment":
				var frag:Fragment = new Fragment(entity.x, entity.y);
				frag.cutsceneNum = entity.values.scenenumber;
				frag.fragid = entity.values.fragid;
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
				prop.loadGraphic('assets/images/' + entity.values.icon + ".png");
				grpProps.add(prop);

				var glitchEffect:FlxEffectSprite;
				add(glitchEffect = new FlxEffectSprite(prop, [new FlxGlitchEffect(2, 1, 0.02)]));
				glitchEffect.setPosition(prop.x, prop.y);
				prop.glitchEffect = glitchEffect;
			case "key":
				var key:Key = new Key(entity.x, entity.y);
				key.canUnlock = entity.values.locknum;
				grpKeys.add(key);

				var glitch:FlxEffectSprite;
				add(glitch = new FlxEffectSprite(key, [new FlxGlitchEffect(5, 2, 0.01)]));
				glitch.setPosition(entity.x, entity.y);
				key.glitchEffect = glitch;

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

		if (FlxG.keys.justPressed.L)
			FlxG.sound.playMusic(AssetPaths.musicLoop__mp3, 0.9);

		if (!_player.inCutscene)
			camFollow.setPosition(_player.x, _player.y);
		else
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				advanceText(cutsceneProp.cutsceneNum);
			}
		}

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
			FlxG.sound.play(AssetPaths.pickup__mp3, 0.6);
			key.collected = true;
			key.kill();
		});

		var overlappingProp:Bool = false;

		FlxG.overlap(_player, grpProps, function(playa:Player, prop:CutsceneProp)
		{
			overlappingProp = true;

			if (prop.amountCollected == prop.grpFrags.members.length && fragsNeeded.decoded && !_player.inCutscene)
			{
				playCutscene(prop);
			}

			fragsNeeded.textDecoding = prop.amountCollected + "/" + prop.grpFrags.members.length;
			fragsNeeded.setPosition(prop.x, prop.y - 20);
		});

		fragsNeeded.hoverActive = overlappingProp;

		FlxG.overlap(_player, grpFragments, function(playa:Player, frag:Fragment)
		{
			FlxG.camera.flash(FlxColor.WHITE, 0.2);

			frag.grpMessages.forEach(function(message:HiddenMessage)
			{
				message.activated = true;
			});

			new FlxTimer().start(2.5, function(tmr:FlxTimer)
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

			FlxG.sound.play(AssetPaths.pickup__mp3);

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

	private function playCutscene(prop:CutsceneProp):Void
	{
		_player.inCutscene = true;
		_player.velocity.set();
		// _player.visible = false;
		FlxG.camera.flash(FlxColor.WHITE, 0.2);

		loadCutscene(prop.cutsceneNum, prop);
	}

	public function loadCutscene(sceneNum:Int = 0, prop:CutsceneProp):Void
	{
		var sceneMetaData:Array<Dynamic> = Cutscenes.cutscenes[sceneNum][0];
		for (i in 0...sceneMetaData[0])
		{
			trace("add character" + i);

			var actor:SceneActor = new SceneActor(prop.x + sceneMetaData[1][i][0], prop.y + sceneMetaData[1][i][1], sceneMetaData[2][i]);
			add(actor);
			grpActors.push(actor);

			var glitchEffect:FlxEffectSprite;
			add(glitchEffect = new FlxEffectSprite(actor, [new FlxGlitchEffect(FlxG.random.int(4, 7), 2, FlxG.random.float(0.05, 0.2))]));
			glitchEffect.setPosition(actor.x, actor.y);
			actor.glitchEffect = glitchEffect;
		}

		camFollow.setPosition(camFollow.x + sceneMetaData[3][0], camFollow.y + sceneMetaData[3][1]);
		FlxG.camera.zoom = sceneMetaData[3][2];

		cutsceneProp = prop;

		advanceText(sceneNum);
	}

	private var curLine:Int = 0;
	private var grpActors:Array<SceneActor> = [];
	private var curDialogue:CutsceneText;
	private var cutsceneProp:CutsceneProp;
	private function advanceText(sceneNum:Int):Void
	{
		if (Cutscenes.cutscenes[sceneNum][1][curLine] != null)
		{
			var curActor:SceneActor = grpActors[Cutscenes.cutscenes[sceneNum][1][curLine][0]];
			camFollow.setPosition(curActor.x, curActor.y);
			curDialogue.setPosition(curActor.x - 50, curActor.y - 30);
			curDialogue.endText = Cutscenes.cutscenes[sceneNum][1][curLine][1];
			curDialogue.visible = true;

			curLine += 1;
		}
		else
		{
			endCutscene();
		}
	}

	private function endCutscene():Void
	{
		FlxG.camera.zoom = 1;
		FlxG.camera.flash(FlxColor.WHITE, 0.2);
		curLine = 0;
		curDialogue.visible = false;
		for (actor in grpActors) {
			actor.kill();
		}

		grpActors = [];

		cutsceneProp.kill();

		_player.inCutscene = false;
	}
}
