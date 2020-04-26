package;

import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class CutsceneProp extends FlxSprite
{
    public var cutsceneNum:Int = 0;
    public var grpFrags:FlxTypedGroup<Fragment>;

    public var glitchEffect:FlxEffectSprite;
    public var amountCollected:Int = 0;

    public function new(x:Float, y:Float) {
        super(x, y);

        loadGraphic(AssetPaths.sword__png);

        grpFrags = new FlxTypedGroup<Fragment>();
    }
}