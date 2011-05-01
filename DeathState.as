package
{
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	
	import org.flixel.*;
	import org.flixel.plugin.DebugPathDisplay;

	public class DeathState extends FlxState
	{
		//Some graphics and sounds
		public var fading:Boolean;
		
		private var _txtNext:FlxText;
		[Embed(source="assets/automat.ttf", fontFamily="automat", embedAsCFF="false")] 	public	var	FontAutomat:String;
		
		override public function create():void
		{
			add(new FlxSprite(0,0).makeGraphic(FlxG.width, FlxG.height, 0xFFd95c40));
			_txtNext = new FlxText(18,200,300, "GAME OVER. YOU LASTED: "+Math.floor(FlxG.score)+" SECONDS. \n PRESS X TO CONTINUE."); //x position, y position, width, string
			_txtNext.setFormat("automat", 16, 0xffFFFFFF, "left"); //font-family, font-size, color, alignment
			_txtNext.scrollFactor.x = _txtNext.scrollFactor.y = 0; //keeps the font in the same place as the screen scrolls
			this.add(_txtNext); //add text to FlxGroup
			
		}
		
		override public function update():void
		{
			if(!fading && (FlxG.keys.X)) 
			{
				fading = true;
				FlxG.flash(0xffffffff,0.5);
				FlxG.fade(0xff542437,1,onFade);
			}
		}
		
		//This function is passed to FlxG.fade() when we are ready to go to the next game state.
		//When FlxG.fade() finishes, it will call this, which in turn will either load
		//up a game demo/replay, or let the player start playing, depending on user input.
		protected function onFade():void
		{
				FlxG.switchState(new HelpState());
		}
	}
}