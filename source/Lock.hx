package;

import io.newgrounds.NG;
import flixel.system.FlxSound;
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
    public var loader:LoadingBar;
    private var deCrypting:Bool = false;

    private var daDoor:FlxSound;
    private var sndDecrypt:FlxSound;


    public function new(x:Float, y:Float, w:Float, h:Float)
    {
        super(x, y);

        makeGraphic(Std.int(w), Std.int(h), FlxColor.BLACK);

        immovable = true;

        daDoor = new FlxSound();
        daDoor.loadEmbedded(AssetPaths.doorLoop__mp3, true);
        FlxG.sound.list.add(daDoor);
        daDoor.proximity(getMidpoint().x, getMidpoint().y, PlayState.PLAYER, 200, true);
        daDoor.play();

        sndDecrypt = new FlxSound();
        sndDecrypt.loadEmbedded(AssetPaths.encLoop__mp3, false);
        sndDecrypt.volume = 0.8;
        FlxG.sound.list.add(sndDecrypt);

    }

    override function update(elapsed:Float) {
        visible = isOnScreen();
        daTexts.visible = visible;
        daTexts.active = visible;
        sndDecrypt.active = visible;

        super.update(elapsed);
    }

    public function decryptLock():Void
    {
        if (!deCrypting)
        {



            deCrypting = true;


            sndDecrypt.play();
            sndDecrypt.fadeIn(3, 0.1, 0.6);

            FlxTween.tween(this, {alpha: 0}, 3);
            FlxTween.tween(loader.scale, {x: 1}, 3);
            FlxTween.tween(daTexts, {encSpeed: 1}, 3, {ease: FlxEase.quadOut, onComplete: function(twen:FlxTween)
                {

                    if (NGio.isLoggedIn)
                    {
                        var hornyMedal = NG.core.medals.get(59381);
                        if (!hornyMedal.unlocked)
                            hornyMedal.sendUnlock();
                    }

                    FlxG.sound.play(AssetPaths.finish__mp3, 0.3);
                    daTexts.finishText(); 
                    kill();
                    loader.kill();
                }});

        }
    }

    override function kill() {
        daDoor.kill();
        sndDecrypt.kill();
        super.kill();
    }
}