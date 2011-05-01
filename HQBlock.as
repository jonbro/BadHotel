package
{
	import flash.geom.*;
	import org.flixel.*;
	public class HQBlock extends CityBlock		//Class declaration for the squid monster class
	{
		[Embed(source="assets/hq.png")] private var ImgHq:Class;	//The graphic of the squid monster
		public function HQBlock(X:int, Y:int, Explosion:FlxEmitter)
		{
			super(X, Y, Explosion, 0);
			loadGraphic(ImgHq);	//Load this animated graphic file
		}
	}
}