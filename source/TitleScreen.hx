package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class TitleScreen extends FlxState
{
    override function create() {
        var bg:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.menufakeasss__png);
        bg.setGraphicSize(FlxG.width);
        bg.updateHitbox();
        add(bg);

        FlxG.sound.playMusic(AssetPaths.title__mp3, 0.7);
        FlxG.sound.music.fadeIn(1, 0, 0.7);
        FlxG.camera.fade(FlxColor.BLACK, 2, true);
        FlxG.mouse.visible = false;

        #if (!debug)
		    var ng:NGio = new NGio(API.apiID, API.encKey);
		#end
        
        super.create();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
        {
            FlxG.switchState(new FakeLoadingScreen());
        }
    }

}