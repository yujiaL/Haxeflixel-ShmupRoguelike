package objects.enemies;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxObject;
import objects.enemies.EnemyBullet;
import flixel.math.FlxPoint;
import flixel.tile.FlxBaseTilemap;
import flixel.math.FlxVelocity;
import objects.enemies.Enemy;
import objects.items.BirdAttackItem;
import objects.items.CoinItem;
import objects.items.DamageUpItem;
import objects.items.HealthItem;
import objects.items.HealthMaxItem;
import objects.items.RangeItem;
import objects.items.SpeedDownItem;
import objects.items.SpreadItem;
import objects.items.Item;
import objects.Player;
import objects.items.SpeedItem;
import objects.items.MagnetItem;
import objects.items.WeaponBackItem;

class EnemyTurretA extends Enemy
{

    private static inline var SCORE_AMOUNT:Int = 100;
	private static inline var SHOOT_SPEED = 50;
	
	private var bullet:EnemyBullet;
	private var justShot:Bool;
	private var shootDelay:Float = 2;
	private var tx:Int;
	private var ty:Int;
	private var typeRoll:Int;
	private var type:Int;
	private var adjusted:Bool = false;
	
	public function new(x:Float, y:Float, _flipped:Bool) 
	{
		super(x, y); 
		HP = 3;
		typeRoll = Reg.CURRENT_SEED.int(0, 100);
		
        tx = Std.int(x / 8); 
        ty = Std.int(y / 8);
		
		flipY = _flipped;
		
		loadGraphic(AssetPaths.enemies__png, true, 8, 8);
		chooseType();		
		immovable = true;
		solid = true;


	}

	override public function update(elapsed:Float)
	{
		animateToShoot();	

		if (!adjusted)
		{
		adjustPlacement();
		adjusted = true;
		}
		super.update(elapsed);
	}
	
	override function collisions() 
	{	
		super.collisions();
	}
	
	
    private function animateToShoot()
	{
		if (!justShot && isOnScreen(FlxG.camera))
			{
				animation.play("shoot");
				justShot = true;
			}

		if (animation.curAnim.name == "shoot" && animation.curAnim.curFrame == 6)
			{
				Reg.PS.EBullets.add(shoot());
				animation.play("idle");
			}	
	}
	
	private function shoot():EnemyBullet
	{
		
		var eb = Reg.PS.EBullets.recycle(EnemyBullet);
	    if (eb == null) eb = new EnemyBullet(x, y);
	
		eb.scale.set(1, 1);
        
		if (!flipY)
		{	
			eb.reset(x , y - 1 );
			eb.velocity.y = -SHOOT_SPEED;
			eb.set_angle(0);
		}
		else
		{
			eb.reset(x, y + 1 );
			eb.set_angle(180);
			eb.velocity.y = SHOOT_SPEED;			
		}

			Reg.PS.EBullets.add(eb);
		
		new FlxTimer().start(shootDelay, function(_)
		{
	    justShot = false;
		}, 1);	
		
		if (type == 1)
		{
		var aim = new FlxPoint(Reg.PS.player.x, Reg.PS.player.y);
		FlxVelocity.moveTowardsPoint(eb, aim, SHOOT_SPEED, 0);
		
		}
		
		return eb;
	}
	
	override public function kill():Void
	{
	    drops = [new HealthItem(x, y), new SpreadItem(x, y),new BirdAttackItem(x,y)];// , new HealthMaxItem(x, y), new HealthMaxItem(x, y)];
		dropRate = [0.2,0.1,0.1];
		dropItem(drops,dropRate);
		super.kill();
	}
	
      private function adjustPlacement()
	{
		// There has to be a better way to do this. Hacky and ugly.
			y -=height;
	}
		
	private function chooseType()	
	{
		if (typeRoll <= 10)
		{
			type = 1;
			HP = 5;
		    animation.add("idle", [24,25,26], 6, true);
		    animation.add("shoot", [24, 25, 26, 27, 28, 29, 30, 31, 31, 31, 32, 32], 8,false);
		    animation.play("idle");	
		}
			
		else
		{
        animation.add("idle", [0,1], 6, true);
		animation.add("shoot", [0, 1, 2, 3, 4, 5, 6, 7, 7, 7, 8, 8], 8,false);
		animation.play("idle");
		
		}
	}
}