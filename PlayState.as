package
{
	import org.flixel.*; //Get access to all the wonders flixel has to offer
	import flash.geom.*;

	public class PlayState extends FlxState		//The class declaration for the main game state
	{
		
		public var missiles:FlxGroup;
		public var city:FlxGroup;
		public var gridSize:Number;
		
		public var missilePeriod:Number;
		override public function create():void
		{
			gridSize = 16;
			missilePeriod = 3;
			missiles = new FlxGroup();
			city = new FlxGroup();
			// add the hq right in the center of the screen
			hq_center = Math.floor(FlxG.width/2)/gridSize)*gridSize;
			hq = new HQBlock(hq_center, FlxG.height-256)
			// add some missiles
			var missile:Missile = new Missile(Math.random()*FlxG.width, -30, Math.random()*FlxG.width, FlxG.height, 20);
			missiles.add(missile);
			add(city);
			add(missiles);
		}
		override public function update():void
		{
			if(FlxG.keys.justPressed("SPACE"))
			{
				// add new city block at this position
				var block = new CityBlock(Math.floor((Math.random()*FlxG.width)/gridSize)*gridSize, 0); // the 8 here needs to be calculated to the hight of a city block
				FlxG.log(block.width)
				// going to do this with a sort of DLA
				var stuck:Boolean = false;
				var lastPos = new Point(block.x, block.y);
				do{
					lastPos = new Point(block.x, block.y);
					var dir = Math.floor(Math.random()*3);
					switch (dir)
					{
						case 0:
							block.x += gridSize;
							break;
						case 1:
							block.x -= gridSize;
							break;
						default:
							block.y += gridSize;
							break;
					}
					block.reset(block.x, block.y);
					// keep the block on the screen
					block.x = Math.max(0, Math.min(FlxG.width, block.x))
					if(FlxG.overlap(block, city) || block.y+block.height>=FlxG.height){
						stuck = true;
					}
				}while(!stuck);
				block.x = lastPos.x; block.y = lastPos.y;
				city.add(block);
			}
			missilePeriod -= FlxG.elapsed;
			if(missilePeriod < 0){
				var missile = new Missile(Math.random()*FlxG.width, -30, Math.random()*FlxG.width, FlxG.height, 20);
				missiles.add(missile);				
				missilePeriod = 3;
			}
			super.update();
		}
	}
}