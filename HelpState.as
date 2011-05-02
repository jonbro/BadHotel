package
{
	import org.flixel.*;

	import flash.ui.*;
	import mochi.as3.*;

	public class HelpState extends FlxState
	{
		//Some graphics and sounds
		[Embed(source="assets/help_screen.png")] protected var ImgHelp:Class;
		[Embed(source="assets/Startup.mp3")] public var SndStartup:Class;
		[Embed(source="assets/Wind.mp3")] public var SndWind:Class;
		public var fading:Boolean;
		
		override public function create():void
		{
			add(new FlxSprite(0,0,ImgHelp));
			FlxG.playMusic(SndWind);
		}
		
		override public function update():void
		{
			if(!fading && (FlxG.keys.X)) 
			{
				fading = true;
				FlxG.flash(0xffffffff,0.5);
				FlxG.fade(0xff542437,1,onFade);
				FlxG.play(SndStartup);
				FlxG.music.fadeOut(.6);
			}
			if(!fading && FlxG.keys.H)
			{
				var o:Object = { n: [15, 4, 6, 6, 4, 7, 2, 0, 14, 1, 11, 13, 11, 3, 11, 3], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
				var boardID:String = o.f(0,"");
				flash.ui.Mouse.show();
				MochiScores.showLeaderboard({boardID: boardID, onClose: function(){
					flash.ui.Mouse.hide();
				}});
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