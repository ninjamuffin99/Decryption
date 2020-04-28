package;

import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Key extends FlxSprite
{
    public var canUnlock:Int = 0;
    public var collected:Bool = false;
    public var daDoor:Lock;
    public var glitchEffect:FlxEffectSprite;
    public function new(x:Float, y:Float)
    {
        super(x, y);
        loadGraphic(AssetPaths.key__png);
    }

    override function update(elapsed:Float) {
        visible = isOnScreen();
        glitchEffect.visible = isOnScreen();
        glitchEffect.active = isOnScreen();
        
        super.update(elapsed);
    }

    override function kill() {
        
        daDoor.alpha = 0.6;
        glitchEffect.kill();
        
        super.kill();
    }
}