package
{
	import flash.geom.*;
	import org.flixel.*;
	public class Dropper extends FlxGroup		//Class declaration for the squid monster class
	{
		public var toDrop:CityBlock;
		
		private var intersectionTester:FlxSprite;
		
		// for testing the position against
		private var city:FlxGroup;
		private var hq:HQBlock;
		
		// storing the direction the slider is going in
		private var moveDir:int;
		
		// the rotation of the dropper
		private var rot:int;
		
		public function Dropper(_rot:int, _city:FlxGroup, _hq:HQBlock)
		{
			city = _city;
			hq = _hq;
			rot = _rot;
			var playState = FlxG.state as PlayState;
			switch (rot)
			{
				case 1: // if it is from the left
				case 2: // or the right
					intersectionTester = new FlxSprite(0, playState.gameArea.height-20);
					intersectionTester.width = FlxG.width;
					intersectionTester.height = 10;
					break;
				default: // if it is vertical
					intersectionTester = new FlxSprite(FlxG.width/2, 0);
					intersectionTester.width = 10;
					intersectionTester.height = playState.gameArea.height;
					break;
			}
			intersectionTester.makeGraphic(intersectionTester.width, intersectionTester.height, 0x30FFFFFF)
			add(intersectionTester);
		}
		override public function update():void
		{
			switch (rot)
			{
				case 1:
				case 2:
					vertUpdate();
					break;
				default:
					horiUpdate();
					break;
			}
			if(toDrop!=null){
				intersectionTester.makeGraphic(intersectionTester.width, intersectionTester.height, 0x30FFFFFF)
				if(rot == 0 || rot == 1){
					toDrop.x = intersectionTester.x;
				}else{
					toDrop.x = FlxG.width-toDrop.width;
				}
				toDrop.y = intersectionTester.y;
			}
			super.update();
		}
		public function vertUpdate():void
		{
			var playState = FlxG.state as PlayState;
			
			// this is for the horizontal one
			if(moveDir==0){
				intersectionTester.reset(intersectionTester.x, intersectionTester.y-1);
			}else{
				intersectionTester.reset(intersectionTester.x, intersectionTester.y+1);				
			}
			if(!FlxG.overlap(intersectionTester, city) || intersectionTester.y < 0 || intersectionTester.y + intersectionTester.height > playState.gameArea.height ){
				// move it back towards the hq
				if(intersectionTester.y < hq.y){
					moveDir = 1;
				}else{
					moveDir = 0;
				}
			}
			if(toDrop!=null){
				intersectionTester.height = toDrop.height;
			}
		}
		public function horiUpdate():void
		{
			// this is for the horizontal one
			if(moveDir==0){
				intersectionTester.reset(intersectionTester.x-1, intersectionTester.y);
			}else{
				intersectionTester.reset(intersectionTester.x+1, intersectionTester.y);				
			}
			if(!FlxG.overlap(intersectionTester, city) || intersectionTester.x < 0 || intersectionTester.x + intersectionTester.width > FlxG.width ){
				// move it back towards the hq
				if(intersectionTester.x < hq.x){
					moveDir = 1;
				}else{
					moveDir = 0;
				}
			}
			if(toDrop!=null){
				intersectionTester.width = toDrop.width;
			}
		}
		public function hasBrick():Boolean
		{
			if(toDrop==null){
				return false;
			}
			return true;
		}
	}
}