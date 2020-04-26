package;

import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class HiddenMessage extends EncText
{
    public var daFrag:Fragment;
    public var fragid:String = "";
    public var activated:Bool = false;
    public var daPlayer:Player;

    public function new(x:Float, y:Float, w:Float, text:String, size:Int)
    {
        super(x, y, w, text, size);

        isFinished = true;
        encSpeed = 20;

        color = FlxColor.BLACK;
        text = endText;

        visible = false;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (activated && FlxMath.isDistanceWithin(this, daPlayer, 160))
        {
            visible = true;

            alpha = FlxMath.remapToRange(FlxMath.distanceBetween(this, daPlayer), 0, 160, 1, 0);
        }
        else
            visible = false;
    }
}