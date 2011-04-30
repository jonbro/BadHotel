package
{
	import flash.geom.*;
	import org.flixel.*;
	public class HQBlock extends FlxSprite		//Class declaration for the squid monster class
	{
		[Embed(source="assets/hq.png")] private var ImgHq:Class;	//The graphic of the squid monster
		public function HQBlock(X:int, Y:int)
		{
			super(X, Y);
			loadGraphic(ImgHq);	//Load this animated graphic file
		}
	}
}