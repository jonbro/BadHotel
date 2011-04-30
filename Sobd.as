// slightly off base defense
// a 3 button realtime strategy tower defense brick game
// http://www.colourlovers.com/palette/694737/Thought_Provoking
package {

	import org.flixel.*; //Allows you to refer to flixel objects in your code
	[SWF(width="960", height="640", backgroundColor="#000000")] //Set the size and color of the Flash file
	[Frame(factoryClass="Preloader")]  //Tells flixel to use the default preloader

	public class Sobd extends FlxGame
	{
		public function Sobd():void
		{
			super(960,640,PlayState,1); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
			forceDebugger = true;

			//Here we are just displaying the cursor to encourage people to click the game,
			// which will give Flash the browser focus and let the keyboard work.
			//Normally we would do this in say the main menu state or something,
			// but FlxInvaders has no menu :P
			// FlxG.mouse.show();
		}
	}
}
