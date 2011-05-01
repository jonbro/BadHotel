package
{
	import flash.geom.*;
	import org.flixel.*;
	public class CityBlock extends FlxSprite		//Class declaration for the squid monster class
	{
		[Embed(source="assets/defense_block.png")] private var ImgDefenseBlock:Class;	
		[Embed(source="assets/defense_block_tall.png")] private var ImgTallBlock:Class;	
		[Embed(source="assets/wide_block.png")] private var ImgWideBlock:Class;	
		
		public var cityParent;
		public var blockType:int;
		public var deathTime:Number;
		public var dying:Boolean;
		
		protected var _explosion:FlxEmitter;	
		
		public function CityBlock(X:int, Y:int, Explosion:FlxEmitter, bType:int = 0)
		{
			super(X, Y);
			blockType = bType;
			if(bType == 0){
				loadGraphic(ImgDefenseBlock);	//Load this animated graphic file				
			}else if(bType==1){
				loadGraphic(ImgWideBlock);	//Load this animated graphic file				
			}else{
				loadGraphic(ImgTallBlock);	//Load this animated graphic file								
			}
			dying = false;
			_explosion = Explosion;
		}
		override public function update():void
		{
			if(cityParent != null && cityParent.dying && !dying){
				solid = false;
				deathTime = cityParent.deathTime+0.3;
				dying = true;
				// start a death timer
				// fire out a bunch of smoke an flame		
			}
			if(dying){
				acceleration.y = 200;
				deathTime -= FlxG.elapsed;
				if(deathTime < 0){
					_explosion.at(this);
					_explosion.start(true,3,0,20);
					super.kill();
				}
			}
			super.update();
		}
		override public function kill():void
		{
			dying = true;
			deathTime = .3;
		}
	}
}