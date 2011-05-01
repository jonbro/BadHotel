package
{
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	
	import org.flixel.*;
	import org.flixel.plugin.DebugPathDisplay;

	public class HelpState extends FlxState
	{
		//Some graphics and sounds
		[Embed(source="assets/help_screen.png")] protected var ImgHelp:Class;
		public var fading:Boolean;
		
		override public function create():void
		{
			add(new FlxSprite(0,0,ImgHelp));
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
				FlxG.switchState(new PlayState());
		}
		
	}
}