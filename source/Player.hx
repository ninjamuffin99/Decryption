package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Player extends FlxSprite
{
    public function new(x:Float, y:Float) {
        super(x, y);

        makeGraphic(32, 64, FlxColor.BLACK);

        maxVelocity.set(50, 50);
        drag.set(17, 17);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        movement();
    }

    var speed:Float = 40;

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
            if (left || right)
            {
                if (left)
                {
                    acceleration.x = -speed;
                }
                if (right)
                {
                    acceleration.x = speed;
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
            acceleration.x = acceleration.y = 0;
        }
    }
}