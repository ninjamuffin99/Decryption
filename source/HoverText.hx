package;

import flixel.math.FlxMath;
import haxe.crypto.Md5;
import flixel.text.FlxText;

class HoverText extends FlxText
{
    public var hoverActive:Bool = false;
    public var textDecoding:String = "";

    public var decoded:Bool = false;
    private var decodeTimer:Int = 0;
    private var decodeProgress:Int = 0;
    private var daSize:Int = 16;
    public function new(x:Float, y:Float, w:Float, text:String, size:Int)
    {
        super(x, y, w, text, size);
        daSize = size;
        alignment = FlxTextAlign.CENTER;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (hoverActive && !decoded)
        {
            visible = true;
            decodeTimer++;
            text = Md5.encode(textDecoding.substring(0, FlxMath.minInt(decodeProgress, textDecoding.length)));
            if (decodeTimer >= 2)
            {
                decodeProgress++;
                decodeTimer = 0;
            }

            if (decodeProgress > 12)
            {
                decoded = true;
                text = textDecoding;
                size = daSize;
            }
            else
            {
                size = Std.int(daSize / 2);
            }
        }

        if (!hoverActive && decoded)
        {
            decodeTimer++;
            size = Std.int(daSize / 2);

            text = Md5.encode(textDecoding.substring(0, FlxMath.minInt(decodeProgress, textDecoding.length)));
            if (decodeTimer >= 2)
            {
                decodeTimer = 0;
                decodeProgress--;
            }

            if (decodeProgress == 0)
            {
                decoded = false;
                visible = false;
            }
        }
    }
}