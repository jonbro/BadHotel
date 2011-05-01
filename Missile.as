package
{
	import flash.geom.*;
	import org.flixel.*;
	public class Missile extends FlxSprite		//Class declaration for the squid monster class
	{
		[Embed(source="assets/missile.png")] private var ImgMissile:Class
		public function Missile(X:int,Y:int, targetX:Number, targetY:Number, speed:Number)
		{
			super(X, Y);
			loadRotatedGraphic(ImgMissile);
			// move this towards the target
			var pos:Point = new Point(X,Y);
			var tar:Point = new Point(targetX, targetY);
			var vel:Point = tar.subtract(pos);
			vel.normalize(speed);
			
			velocity.x = vel.x;
			velocity.y = vel.y;
			angle = FlxU.getAngle(new FlxPoint(0,0), new FlxPoint(vel.x, vel.y))
		}
		override public function update():void
		{
			super.update();
		}
	}
}