package;

import flixel.system.FlxSound;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Player extends FlxSprite
{

    public var inCutscene:Bool = false;
    private var floatinSound:FlxSound;
    public function new(x:Float, y:Float) {
        super(x, y);

        // makeGraphic(32, 64, FlxColor.BLACK);

        loadGraphic(AssetPaths.player__png);

        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);

        maxVelocity.set(60, 60);
        drag.set(17, 17);

        floatinSound = new FlxSound();
        floatinSound.loadEmbedded(AssetPaths.movingLoop__mp3, true, false);
        floatinSound.volume = 0.4;
        FlxG.sound.list.add(floatinSound);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (!inCutscene)
            movement();
    }

    var speed:Float = 160;

    function movement() {
        var up:Bool = FlxG.keys.anyPressed(['W', 'UP']);
        var down:Bool = FlxG.keys.anyPressed(['S', "DOWN"]);
        var left:Bool = FlxG.keys.anyPressed(['A', "LEFT"]);
        var right:Bool = FlxG.keys.anyPressed(['D', "RIGHT"]);

        if (up && down)
            up = down = false;
        if (left && right)
            left = right = false;

        if (left || right || up || down)
        {

            floatinSound.play();

            if (left || right)
            {
                if (left)
                {
                    acceleration.x = -speed;
                    facing = FlxObject.LEFT;
                }
                if (right)
                {
                    acceleration.x = speed;
                    facing = FlxObject.RIGHT;
                }
            }
            else
                acceleration.x = 0;

            if (up || down)
            {
                if (up)
                {
                    acceleration.y = -speed;
                }
                if (down)
                {
                    acceleration.y = speed;
                }
            }
            else
                acceleration.y = 0;
        }
        else
        {
            floatinSound.pause();
            acceleration.x = acceleration.y = 0;
        }
    }
}