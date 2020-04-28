package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Fragment extends FlxSprite
{
    public var cutsceneNum:Int = 0;
    public var collected:Bool = false;
    public var glitchSprite:FlxEffectSprite;

    public var daProp:CutsceneProp;
    public var fragText:String = "";
    public var fragid:String = "";
    public var grpMessages:FlxTypedGroup<HiddenMessage>;

    public function new(x:Float, y:Float) {
        super(x, y);
        makeGraphic(32, 32, FlxColor.GREEN);

        grpMessages = new FlxTypedGroup<HiddenMessage>();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        glitchSprite.visible = isOnScreen();
    }

    override function kill() {
        glitchSprite.kill();

        super.kill();
    }
}