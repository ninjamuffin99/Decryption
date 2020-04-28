package;

import flixel.FlxG;
import flixel.effects.particles.FlxParticle;

class ParticleBit extends FlxParticle
{
    public function new()
    {
        super();
        loadGraphic(AssetPaths.particle__png, true, 4, 4);

        var randFrames:Array<Int> = [0, 0, 0, 0, 1, 1, 1, 1];
        FlxG.random.shuffle(randFrames);

        animation.add('bits', randFrames, FlxG.random.int(3, 30));
        animation.play('bits');
    }

    private var bitswapCounter:Int = 0;

    override function update(elapsed:Float) {
        visible = isOnScreen();
        
        super.update(elapsed);

    }

}