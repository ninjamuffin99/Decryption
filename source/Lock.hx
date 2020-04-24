package;

import flixel.FlxSprite;

class Lock extends FlxSprite
{
    public var unlockedBy:Int = 0;
    public function new(x:Float, y:Float)
    {
        super(x, y);

        immovable = true;
    }
}