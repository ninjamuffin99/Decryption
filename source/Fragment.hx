package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Fragment extends FlxSprite
{
    public var cutsceneNum:Int = 0;
    public var collected:Bool = false;
    public function new(x:Float, y:Float) {
        super(x, y);
        makeGraphic(32, 32, FlxColor.GREEN);
    }
}