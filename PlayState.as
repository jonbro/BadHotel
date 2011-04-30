package
{
	import org.flixel.*; //Get access to all the wonders flixel has to offer
	import flash.geom.*;

	public class PlayState extends FlxState		//The class declaration for the main game state
	{
		
		public var missiles:FlxGroup;
		
		public var unattachedBlock:CityBlock;
		public var unattachedBlockDir:Number;
		public var city:FlxGroup;
		public var gridSize:Number;
		
		public var missilePeriod:Number;
		public var blockPeriod:Number;
		
		override public function create():void
		{
			FlxG.bgColor = 0xff96bcc7;
			
			gridSize = 16;
			missilePeriod = 3;
			blockPeriod = 10;
			
			missiles = new FlxGroup();
			city = new FlxGroup();
			// add the hq right in the center of the screen
			var hq_center = Math.floor((FlxG.width/2)/gridSize)*gridSize;
			var hq = new HQBlock(hq_center, FlxG.height-156)
			city.add(hq);
			// add some missiles
			var missile:Missile = new Missile(Math.random()*FlxG.width, -30, Math.random()*FlxG.width, FlxG.height, 20);
			missiles.add(missile);
			
			add(city);
			add(missiles);
			
			unattachedBlock = new CityBlock(Math.floor((FlxG.width/2)/gridSize)*gridSize, 0, Math.floor(Math.random()*2)); //
			
			add(unattachedBlock);
			unattachedBlockDir = 0;
		}
		override public function update():void
		{
			if(FlxG.keys.justPressed("SPACE"))
			{
				addBlock(Math.floor((FlxG.width/2)/gridSize)*gridSize, 0);
				unattachedBlock = new CityBlock(Math.floor((FlxG.width/2)/gridSize)*gridSize, 0, Math.floor(Math.random()*2)); //
			}
			// drop the block from the top
			if(FlxG.keys.justPressed("Z")){
				addBlock(unattachedBlock.x, unattachedBlock.y, 3, unattachedBlock.blockType);
			}
			// move the unattached blocks back and forth
			if(unattachedBlockDir==0){
				unattachedBlock.reset(unattachedBlock.x-1, unattachedBlock.y);
			}else{
				unattachedBlock.reset(unattachedBlock.x+1, unattachedBlock.y);				
			}
			if(unattachedBlock.x + unattachedBlock.width > FlxG.width || unattachedBlock.x < 0){
				unattachedBlockDir = (unattachedBlockDir+1)%2
			}
			FlxG.overlap(city, missiles, function(cityBlock, missile){
				missile.kill();
				cityBlock.kill();
			});
			missilePeriod -= FlxG.elapsed;
			if(missilePeriod < 0){
				var missile = new Missile(Math.random()*FlxG.width, -30, Math.random()*FlxG.width, FlxG.height, 20);
				missiles.add(missile);				
				missilePeriod = 3;
			}
			super.update();
		}
		public function addBlock(_x, _y, OverrideDir = false, defaultType = null):void
		{
			if(defaultType == null){
				var blockType = Math.floor(Math.random()*2);				
			}else{
				var blockType = defaultType;
			}
			FlxG.log(defaultType);
			// add new city block at this positionm
			var block = new CityBlock(_x, _y, blockType);
			// going to do this with a sort of DLA
			var stuck:Boolean = false;
			var lastPos = new Point(block.x, block.y);
			do{
				lastPos = new Point(block.x, block.y);
				if(!OverrideDir){
					var dir = Math.floor(Math.random()*3);
				}else{
					var dir = OverrideDir;
				}
				switch (dir)
				{
					case 0:
						block.x += 1;
						break;
					case 1:
						block.x -= 1;
						break;
					default:
						block.y += 1;
						break;
				}
				block.reset(block.x, block.y);
				// keep the block on the screen
				block.x = Math.max(0, Math.min(FlxG.width, block.x))
				block.y = Math.max(0, Math.min(FlxG.height-block.height, block.y))
				if(FlxG.overlap(block, city, function(newBlock, cityBlock){
					// we need to store the existing city block on the new block so that if it is destroyed, the new block falls
					newBlock.cityParent = cityBlock;
				})){
					stuck = true;
				}
			}while(!stuck && block.y + block.height < FlxG.height);
			if(stuck){
				block.x = lastPos.x; block.y = lastPos.y;
				city.add(block);
			}
		}
	}
}