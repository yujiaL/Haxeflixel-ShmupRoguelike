package objects.items;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;
import flixel.effects.FlxFlicker;
import flixel.math.FlxVelocity;


class Item extends FlxSprite
{
	// Maybe each item has its own drop % modifier, so that it will make some items more rare, and not only based on enemy types that can drop them.
	private var _appeared:Bool = false;
	private var lifespan:Int;

	public function new(x:Float, y:Float) 
	{
		super(x, y);
		loadGraphic(AssetPaths.items__png, false, 8, 8);
		width = 8;
		height = 8;
	}
	
	override public function update(elapsed:Float)
	{
        basicChecks();
		collisions();
		super.update(elapsed);
	}
	
	private function collisions()
	{
		   if (FlxG.overlap(Reg.PS.player, this))
		   {
			interact(Reg.PS.player);   
		   }
	}
	
	private function basicChecks()
	{
		if (!inWorldBounds())
			exists = false;
		
					
        if (isOnScreen()) {
        if (!_appeared) 
             _appeared = true;
                          }
         else {
           if (_appeared)
            kill();
		 }
			
		if (_appeared)
		{
		new FlxTimer().start(lifespan, function(_)
		{
			FlxSpriteUtil.flicker(this,1, 0.05, true, false, onTimedOut);
		}, 1);
		}	
	}
	
	private function onTimedOut(t:FlxFlicker):Void
	{
		kill();
	}
	
	override public function kill()
	{
		Reg.PS.items.remove(this,true);
		super.kill();
	}
	
	public function interact(player:Player)
	{
		kill();
		Reg.score += 50;
	}
	
}