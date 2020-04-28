package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ninjaMuffin
 */
class FakeLoadingScreen extends FlxState 
{
	private var printing:FlxText;
	private var timer:Float = 4;
	
	private var bootTexts:Array<String> = ["Injecting SQL", "Bruteforce...", "Starting the Metasploit Framework Console...", "Loading FlixOS...", "Abstracting Low Level APIs","Linking graphics processor", "Compiling hard drive", "Defragging hard drive", "starting hashcat", "decrypting DATABASE", "ERROR DECRYPTING", "Initializing Compatibility Mode", "Loading OS", "FlixOS 1.8.30 \n(c) 1997-2004 Newgrounds inc. \n\"Everything, by Everyone!\" All Rights Reserved \nSource code: github.com/ninjamuffin99/NG-Jam2020\n(Source code out of date)", "Initializing RAM", "Initializing GUI"];

	override public function create():Void 
	{

        bgColor = FlxColor.WHITE;
		
		FlxG.sound.play("assets/sounds/pcAmbience.mp3");

        FlxG.sound.music.fadeOut(12, 0);
        
		
		printing = new FlxText(2, 2, 0, "Loading... Server-USA-WEST" + FlxG.random.int(0, 200) + "\nLogged in as user guest-" + FlxG.random.int(0, 10000), 8);
        printing.color = FlxColor.BLACK;
		add(printing);
		
		#if (!debug)
		    var ng:NGio = new NGio(API.apiID, API.encKey);
		#end
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (timer > 0)
		{
			timer -= FlxG.elapsed;
		}
		else
		{
            timer += FlxG.random.float(0, 1);
            if (!booting)
			    addText();
		}
		
		#if debug
		if (FlxG.keys.justPressed.ANY)
		{
			FlxG.switchState(new PlayState());
		}
		#end
		
    }
    var booting:Bool = false;
	
	private function addText():Void
	{
		if (bootTexts.length == 0)
		{
            FlxG.camera.fade(FlxColor.WHITE, 3, false, function(){FlxG.switchState(new RealTitle());});
            booting = true;
		}
		
		printing.text += " -- Complete\n";
		printing.text += bootTexts[0];
		bootTexts.remove(bootTexts[0]);
		
	}
}