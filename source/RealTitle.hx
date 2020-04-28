package;

import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxState;

class RealTitle extends FlxState
{
    override function create() {
        bgColor = FlxColor.WHITE;
        FlxG.mouse.visible = false;

        FlxG.camera.fade(FlxColor.WHITE, 1, true);

        var text1:HoverText = new HoverText(0, 100, 200, "decryption", 24);
        text1.textDecoding = 'decryption';
        text1.hoverActive = true;
        text1.color = FlxColor.BLACK;
        text1.screenCenter(X);
        add(text1);

        var creds:HoverText = new HoverText(0, 160, 0, "by ninjamuffin99, HenryEYES and ConnorGrail", 16);
        creds.textDecoding = "by ninjamuffin99, HenryEYES and ConnorGrail";
        creds.screenCenter(X);
        creds.color = FlxColor.BLACK;
        creds.visible = false;
        add(creds);

        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            creds.visible = true;
            creds.hoverActive = true;
        });

        new FlxTimer().start(5, function(tmr:FlxTimer)
        {
            FlxG.camera.fade(FlxColor.WHITE, 5, false, function(){FlxG.switchState(new PlayState());});
        });


        
        super.create();
    }
}