package objects.hazards;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxBasic;
import flixel.FlxObject;


class Hazard extends FlxSprite
{

	private var _appeared:Bool = false;
	
	public function new(x:Float,y:Float) 
	{
		super(x, y);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (FlxG.overlap(this, Reg.PS.player))
	    {
			interact(Reg.PS.player);
		}
		
		if (!inWorldBounds())
			exists = false;
			
		if (isOnScreen() && !_appeared) 
			_appeared = true;	
		
		super.update(elapsed);		
	}
	
		private function interact(player:Player)
	{
			player.damage();
	}
}