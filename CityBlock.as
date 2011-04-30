package
{
	import flash.geom.*;
	import org.flixel.*;
	public class CityBlock extends FlxSprite		//Class declaration for the squid monster class
	{
		[Embed(source="assets/defense_block.png")] private var ImgDefenseBlock:Class;	
		[Embed(source="assets/wide_block.png")] private var ImgWideBlock:Class;	
		
		public var cityParent;
		public var blockType:int;

		public function CityBlock(X:int, Y:int, bType:int = 0)
		{
			super(X, Y);
			blockType = bType;
			FlxG.log(blockType);
			if(bType == 0){
				loadGraphic(ImgDefenseBlock);	//Load this animated graphic file				
			}else{
				loadGraphic(ImgWideBlock);	//Load this animated graphic file				
			}
		}
		override public function update():void
		{
			if(cityParent != null && !cityParent.alive){
				acceleration.y = 200;
				solid = false;
				// start a death timer
				// fire out a bunch of smoke an flame		
			}
			super.update();
		}
	}
}