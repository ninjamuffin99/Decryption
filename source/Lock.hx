package;

import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;

class Lock extends FlxSprite
{
    public var unlockedBy:Int = 0;
    public var daTexts:EncText;
    private var deCrypting:Bool = false;
    public function new(x:Float, y:Float, w:Float, h:Float)
    {
        super(x, y);

        makeGraphic(Std.int(w), Std.int(h), FlxColor.BLACK);

        immovable = true;

    }

    public function decryptLock():Void
    {
        if (!deCrypting)
        {
            deCrypting = true;

            FlxTween.tween(daTexts, {encSpeed: 1}, 3, {ease: FlxEase.quadOut, onComplete: function(twen:FlxTween)
                {
                    daTexts.finishText(); 
                    kill();
                }});

        }
    }

    override function kill() {
        super.kill();
    }
}