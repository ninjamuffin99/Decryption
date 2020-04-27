package;

import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxSprite;

class SceneActor extends FlxSprite
{
    public var glitchEffect:FlxEffectSprite;
    public function new(x:Float, y:Float, actor:String) {
        super(x, y);

        switch (actor)
        {
            case "placeholder":
                makeGraphic(32, FlxG.random.int(50, 64), FlxColor.BLACK);
        }

        alpha = 0.7;
    }

    override function kill() {
        
        glitchEffect.kill();
        
        super.kill();
    }
}