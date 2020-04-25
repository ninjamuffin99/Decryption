package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Key extends FlxSprite
{
    public var canUnlock:Int = 0;
    public var collected:Bool = false;
    public function new(x:Float, y:Float)
    {
        super(x, y);
        makeGraphic(32, 32, FlxColor.YELLOW);
    }
}