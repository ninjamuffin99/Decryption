package;

import haxe.io.Bytes;
import haxe.crypto.Base64;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;

class EncText extends FlxText
{

    private var texts:Array<String> = ["R/W ERROR, CHECK DEBUG LOG", "UH OH, ENCODED TEXT!", "PLEASE DECODE", "ENCODED STRING", "UNABLE TO READ/WRITE ENCODED STRING", "ERROR READING ENCODED STRING", "STRING READ/WRITE ERROR, STRING IS ENCODED"];
    private var encodedTexts:Array<String> = [];
    private var textCounter:Int = 0;

    private var encSpeed:Float = 6;
    public var endText:String = "";
    
    public function new(x:Float, y:Float, w:Float, text:String, size:Int)
    {
        super(x, y, w, text, size);

        for (i in 0...texts.length)
        {
            encodedTexts.push(Base64.encode(Bytes.ofString(texts[i])));
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        textCounter++;

        if (textCounter >= Math.ceil(encSpeed))
        {
            if (isFinished)
            {
                if (FlxG.random.bool(20))
                {
                    text = Base64.encode(Bytes.ofString(endText));
                    textCounter = Std.int(encSpeed - FlxG.random.int(3, 10));
                }
                else
                {
                    text = endText;
                    textCounter = FlxG.random.int(-10, 20);
                }
            }
            else
            {
                text = FlxG.random.getObject(encodedTexts);
                textCounter = 0;
            }
            
        }
    }

    var isFinished:Bool = false;

    public function finishText():Void
    {
        isFinished = true;
        encSpeed = 30;

        color = FlxColor.BLACK;
        text = endText;

        FlxTween.tween(this, {alpha: 0}, 4, {onComplete: function(tween:FlxTween){kill();}});
    }
}