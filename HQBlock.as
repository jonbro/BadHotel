package
{
	import flash.geom.*;
	import org.flixel.*;
	public class CityBlock extends FlxSprite		//Class declaration for the squid monster class
	{
		[Embed(source="assets/hq.png")] private var ImgDefenseBlock:Class;	//The graphic of the squid monster
		public function CityBlock(X:int, Y:int)
		{
			super(X, Y);
			loadGraphic(hq,true);	//Load this animated graphic file
		}
	}
}