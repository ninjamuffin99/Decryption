package;

import flixel.util.FlxColor;

class CutsceneText extends EncText
{
    public function new(x:Float, y:Float, w:Float, text:String, size:Int)
    {
        super(x, y, w, text, size);

        isFinished = true;
        encSpeed = 15;

        color = FlxColor.BLACK;
        text = endText;

        visible = true;
    }
}