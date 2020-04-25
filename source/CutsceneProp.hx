package;

import flixel.FlxSprite;

class CutsceneProp extends FlxSprite
{
    public function new(x:Float, y:Float) {
        super(x, y);

        loadGraphic(AssetPaths.sword__png);
    }
}