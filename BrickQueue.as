package
{
	import org.flixel.*; //Get access to all the wonders flixel has to offer
	import org.flixel.plugin.photonstorm.*; //Get access to all the wonders flixel has to offer
	import flash.geom.*;
	// a holder for the upcoming bricks!
	// will also handle handing out bricks when the different droppers request them
	public class BrickQueue extends FlxGroup
	{
		private var buildTimeRemaining:Array;
		private var buildTimeRemainingBars:Array;
		private var upcomingBricks:FlxGroup;
		private var numUpcoming:int;
		private var waiting:Dropper;
		private var pos:Point;
		public function BrickQueue()
		{
			super();
			pos = new Point(740, 488)
			numUpcoming = 3;
			upcomingBricks = new FlxGroup();
			this.add(upcomingBricks);
			var bg = this.add(new FlxSprite(pos.x, pos.y)) as FlxSprite;
			bg.makeGraphic(FlxG.width - pos.x, FlxG.height - pos.y, 0xFF53777a);
			
			buildTimeRemaining = new Array();
			for (var i:int = 0; i < numUpcoming; i++)
			{
				buildTimeRemaining[i] = new FlxSprite(pos.x+5, pos.y+5+i*32);
				buildTimeRemaining[i].health = 3;
				add(buildTimeRemaining[i]);
				var bar = add(new FlxHealthBar(buildTimeRemaining[i], 130, 20, 0, 3)) as FlxHealthBar;
				bar.createGradientBar([0x800000, 0xFF0000], [0x00FF00, 0xFFFFFF], 1, 0, true, 0xff000000);
				bar.trackParent(20, 0);
			}
		}
		override public function update():void
		{
			for (var i:int = 0; i < numUpcoming; i++){
				buildTimeRemaining[i].health = Math.max(buildTimeRemaining[i].health-FlxG.elapsed, 0);
				checkForBrick();
			}
			super.update();
		}
		
		// store the dropper that is waiting for a brick in the queue so that we can hand off a brick when one is ready
		public function getBrick(_needsBrick:Dropper):void
		{
			waiting = _needsBrick;
			checkForBrick();
		}
		public function checkForBrick(){
			for (var i:int = 0; i < numUpcoming; i++){
				if(buildTimeRemaining[i].health <= 0 && waiting != null && waiting.toDrop == null){
					waiting.toDrop = new CityBlock(0, 0, Math.floor(Math.random()*2));
					waiting.add(waiting.toDrop);
					waiting = null;
					// restart the count down
					buildTimeRemaining[i].health = 3;
					// place at the end of the array (this is the point where it should be loaded with the upcoming brick)
					var theOneWeUsed = buildTimeRemaining.splice(i, 1);
					buildTimeRemaining.splice(2, 0, theOneWeUsed);
					orderCountDowns();
					FlxG.log(buildTimeRemaining);
					break;
				}
			}
		}
		public function orderCountDowns(){
			for (var i:int = 0; i < numUpcoming; i++)
			{
				buildTimeRemaining[i].y = pos.y+5+i*32;
			}
		}
	}
}