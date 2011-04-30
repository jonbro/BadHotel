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
		
		public function Dropper(rot:int, _city:FlxGroup, _hq:HQBlock)
		{
			city = _city;
			hq = _hq;
			switch (rot)
			{
				default: // if it is vertical
					intersectionTester = new FlxSprite(FlxG.width/2, 0);
					intersectionTester.width = 10;
					intersectionTester.height = FlxG.height;
					break;
			}
			intersectionTester.makeGraphic(intersectionTester.width, intersectionTester.height, 0x30FFFFFF)
			add(intersectionTester);
		}
		override public function update():void
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
				intersectionTester.makeGraphic(intersectionTester.width, intersectionTester.height, 0x30FFFFFF)
				toDrop.x = intersectionTester.x;
				toDrop.y = intersectionTester.y;
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