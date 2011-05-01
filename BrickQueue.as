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
		private var _txtNext:FlxText;
		[Embed(source="assets/automat.ttf", fontFamily="automat", embedAsCFF="false")] 	public	var	FontAutomat:String;
		protected var _explosion:FlxEmitter;
		public function BrickQueue(Explosion:FlxEmitter)
		{
			super();
			_explosion = Explosion;
			pos = new Point(740, 488)
			numUpcoming = 3;
			upcomingBricks = new FlxGroup();
			this.add(upcomingBricks);
			var bg = this.add(new FlxSprite(0, 582)) as FlxSprite;
			bg.makeGraphic(FlxG.width, FlxG.height - pos.y, 0x54000000);
			
			buildTimeRemaining = new Array();
			buildTimeRemainingBars = new Array();
			_txtNext = new FlxText(18,600,70, "NEXT:"); //x position, y position, width, string
			_txtNext.setFormat("automat", 16, 0xff000000, "left"); //font-family, font-size, color, alignment
			_txtNext.scrollFactor.x = _txtNext.scrollFactor.y = 0; //keeps the font in the same place as the screen scrolls
			this.add(_txtNext); //add text to FlxGroup
			
			for (var i:int = 0; i < numUpcoming; i++)
			{
				var x_pos = _txtNext.width+_txtNext.x+i*26;
				if(buildTimeRemaining[i-1]!=null){
					x_pos+=buildTimeRemaining[i-1].x+buildTimeRemaining[i-1].width+130;
				}
				buildTimeRemaining[i] = new CityBlock(x_pos, pos.y, _explosion, Math.floor(Math.random()*3));
				buildTimeRemaining[i].y = _txtNext.height/2-buildTimeRemaining[i].height/2+_txtNext.y;
				buildTimeRemaining[i].health = 0;
				add(buildTimeRemaining[i]);
				
				buildTimeRemainingBars[i] = new FlxHealthBar(buildTimeRemaining[i], 130, 22, 0, 3);
				buildTimeRemainingBars[i].createFilledBar(0xffd85b43, 0xffebcf78, true, 0xffFFFFFF);
				buildTimeRemainingBars[i].trackParent(buildTimeRemaining[i].width+5, buildTimeRemaining[i].height/2-buildTimeRemainingBars[i].height/2);
				add(buildTimeRemainingBars[i]);
				
			}
		}
		override public function update():void
		{
			for (var i:int = 0; i < numUpcoming; i++){
				buildTimeRemaining[i].health = Math.min(buildTimeRemaining[i].health+FlxG.elapsed, 3);
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
				if(buildTimeRemaining[i].health >= 3 && waiting != null && waiting.toDrop == null){
					
					waiting.toDrop = buildTimeRemaining[i];
					remove(waiting.toDrop);
					remove(buildTimeRemainingBars[i]);
					
					buildTimeRemaining[i] = new CityBlock(0,0, _explosion, Math.floor(Math.random()*3));
					
					add(buildTimeRemaining[i]);
					waiting.add(waiting.toDrop);
					waiting = null;
					// restart the count down
					buildTimeRemaining[i].health = 0;

					buildTimeRemainingBars[i] = new FlxHealthBar(buildTimeRemaining[i], 130, 22, 0, 3);
					buildTimeRemainingBars[i].createFilledBar(0xffd85b43, 0xffebcf78, true, 0xffFFFFFF);
					buildTimeRemainingBars[i].trackParent(buildTimeRemaining[i].width+5, buildTimeRemaining[i].height/2-buildTimeRemainingBars[i].height/2);
					add(buildTimeRemainingBars[i]);
					
					// place at the end of the array (this is the point where it should be loaded with the upcoming brick)
					var theOneWeUsed = buildTimeRemaining.splice(i, 1);
					buildTimeRemaining.splice(2, 0, theOneWeUsed[0]);
					
					theOneWeUsed = buildTimeRemainingBars.splice(i, 1);
					buildTimeRemainingBars.splice(2, 0, theOneWeUsed[0]);
					
					orderCountDowns();
					break;
				}
			}
		}
		public function orderCountDowns(){
			for (var i:int = 0; i < numUpcoming; i++)
			{
				var x_pos = _txtNext.width+_txtNext.x+i*26;
				if(buildTimeRemaining[i-1]!=null){
					x_pos+=buildTimeRemaining[i-1].x+buildTimeRemaining[i-1].width+130;
				}
				var y_pos = _txtNext.height/2-buildTimeRemaining[i].height/2+_txtNext.y;
				buildTimeRemaining[i].reset(x_pos, y_pos);
			}
		}
	}
}