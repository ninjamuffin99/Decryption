package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class TitleScreen extends FlxState
{
    override function create() {
        var title:FlxText = new FlxText(0, 100, 0, "Fantasy Wars: ONLINE", 24);
        title.screenCenter(X);
        add(title);

        FlxG.sound.playMusic(AssetPaths.title__mp3, 0.7);
        
        super.create();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.switchState(new FakeLoadingScreen());
        }
    }

}