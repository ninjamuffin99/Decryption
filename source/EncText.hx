package;

import flixel.FlxG;
import flixel.text.FlxText;

class EncText extends FlxText
{

    private var encodedTexts:Array<String> = ["53 54 52 49 4e 47 20 48 41 53 20 42 45 45 4e 20 45 4e 43 52 59 50 54 45 44", "49 4e 50 55 54 20 45 4e 43 52 59 50 54 49 4f 4e 20 4b 45 59", "45 4e 43 4f 44 45 44 20 53 54 52 49 4e 47 0a", "52 45 41 44 2f 57 52 49 54 45 20 44 49 53 41 42 4c 45 44 0a", "44 45 43 4f 44 45 20 57 49 54 48 20 4b 45 59 0a"];
    private var textCounter:Int = 0;

    private var encSpeed:Float = 6;
    
    public function new(x:Float, y:Float, w:Float, text:String, size:Int)
    {
        super(x, y, w, text, size);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        textCounter++;

        if (textCounter >= Math.ceil(encSpeed))
        {
            text = FlxG.random.getObject(encodedTexts);
            textCounter = 0;
        }
    }
}