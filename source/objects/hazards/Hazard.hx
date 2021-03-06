package objects.hazards;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxBasic;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;


class Hazard extends FlxSprite
{
	private var _appeared:Bool = false;
	private var createdDamageText:Bool;
	private var damageText:FlxText;
	
	private var desiredParticles:Int =  4;
		
	public function new(x:Float,y:Float) 
	{
		super(x, y);
	}
	
	override public function update(elapsed:Float)
	{
        basicChecks();
		collisions();
	
		if(!Reg.pause && Reg.hatched)
		    super.update(elapsed);		
	}

	private function collisions()
	{
		if (FlxG.overlap(Reg.PS.player, this))
		{
		  Reg.PS.player.damage();
		  FlxObject.separate(this, Reg.PS.player);
		}
		
		if (isOnScreen())
		FlxG.overlap(Reg.PS.PBullets, this, NoDamage);
	}   
	
	private function NoDamage(_bullet:FlxSprite, _enemy:FlxSprite)
	{
		damageText = new FlxText(_bullet.x,_bullet.y,0,"-0",8);
        damageText.setFormat(AssetPaths.smallfont__ttf, 8, FlxColor.RED, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		_bullet.kill();

		damageText.set_antialiasing(false);
	    damageText.moves = true;
		damageText.velocity.y = -10;
		Reg.PS.add(damageText);

		textTimer();
		createdDamageText = true;
		
	}
	private function textTimer()
	{
		new FlxTimer().start(0.01, function(_) { 
			FlxSpriteUtil.fadeOut(damageText, 0.5, function(_) { 
			damageText.destroy;
			}); 
		} , 1);
	}

	
	private function basicChecks()
	{
		if (!inWorldBounds())
			exists = false;
			
		if (isOnScreen(FlxG.camera))
		{
			if (!_appeared) 
			{
			_appeared = true;	
			}
		}
		
		if (_appeared && x <= FlxG.camera.scroll.x - 16)
	   	 {
				kill();
		 }
	}
	
	private function interact(player:Player)
	{
		player.damage();
	}
	
	override public function kill()
	{
		Reg.PS.hazards.remove(this, true);
		super.kill();
	}
	
}
