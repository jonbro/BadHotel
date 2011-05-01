package
{
	import org.flixel.*; //Get access to all the wonders flixel has to offer
	import flash.geom.*;

	public class PlayState extends FlxState		//The class declaration for the main game state
	{
		[Embed(source="assets/background_mountins.png")] private var ImgBkg:Class; //The background image.
		[Embed(source="assets/explosion.png")] private var ImgExplosion:Class;
		[Embed(source="assets/bad_hotel.mp3")] 	public var MusicMain:Class;
		public var missiles:FlxGroup;
		
		public var city:FlxGroup;
		public var hq:HQBlock;
		public var gridSize:Number;
		
		public var missilePeriod:Number;
		public var blockPeriod:Number;

		private var vertDrop:Dropper;
		private var leftDrop:Dropper;
		private var rightDrop:Dropper;
		
		public var queue:BrickQueue;
		public var gameArea:FlxRect; // to store the playable area
		
		protected var Explosion:FlxEmitter;	
		protected var _fading:Boolean;
		protected var _score:Number;
		override public function create():void
		{
			gameArea = new FlxRect(0, 0, FlxG.width, 565);
			
			FlxG.bgColor = 0xff96bcc7;
			
			var bgSprite = new FlxSprite(0, 0, ImgBkg);
			this.add(bgSprite);
			gridSize = 16;
			missilePeriod = 1;
			blockPeriod = 10;

			Explosion = new FlxEmitter();
			Explosion.setXSpeed(-150,150);
			Explosion.setYSpeed(-200,0);
			Explosion.setRotation(-720,-720);
			Explosion.gravity = 350;
			Explosion.bounce = 0.5;
			Explosion.makeParticles(ImgExplosion,100,10,true,0);
			
			add(Explosion);
			
			missiles = new FlxGroup();
			city = new FlxGroup();
			// add the hq right in the center of the screen
			var hq_center = FlxG.width/2-24;
			hq = new HQBlock(hq_center, gameArea.height-156, Explosion)
			city.add(hq);
			
			add(city);
			add(missiles);

			
			queue = new BrickQueue(Explosion);
			add(queue);
			
			vertDrop = new Dropper(0, city, hq);
			add(vertDrop);
			leftDrop = new Dropper(1, city, hq);
			add(leftDrop);
			rightDrop = new Dropper(2, city, hq);
			add(rightDrop);
			FlxG.playMusic(MusicMain);
			_score = 0;
			FlxG.watch(FlxG, "score")			
		}
		override public function update():void
		{
			// left top right
			if(FlxG.keys.justPressed("Z")){
				dropPressed(leftDrop, 0)
			}
			if(FlxG.keys.justPressed("X")){
				dropPressed(vertDrop, 3)
			}
			if(FlxG.keys.justPressed("C")){
				dropPressed(rightDrop, 1)
			}
			FlxG.overlap(city, missiles, function(cityBlock, missile){
				missile.kill();
				cityBlock.kill();
			});
			missilePeriod -= FlxG.elapsed;
			_score += FlxG.elapsed;
			if(missilePeriod < 0){
				// shoot all of the missiles at the hq
				var missile = new Missile(Math.random()*FlxG.width, -30, FlxG.width/2, gameArea.height, Math.random()*30+50);
				missiles.add(missile);				
				missilePeriod = 3;
			}
			if(hq.dying){
				//Fade out to victory screen stuffs
				_fading = true;
				FlxG.score = _score;
				FlxG.fade(0xff542437,3,onDeath);
			}
			super.update();
		}
		public function onDeath()
		{
			FlxG.music.stop();
			FlxG.switchState(new DeathState());
		}
		public function dropPressed(dropper, dir)
		{
			if(!dropper.hasBrick()){
				queue.getBrick(dropper);					
			}else{
				addBlock(dropper.toDrop.x, dropper.toDrop.y, dir, dropper.toDrop);
				dropper.remove(dropper.toDrop);
				dropper.toDrop = null;
			}			
		}
		public function addBlock(_x, _y, OverrideDir = false, defaultType = null):void
		{
			var block;
			if(defaultType == null){
				var blockType = Math.floor(Math.random()*2);				
				block = new CityBlock(_x, _y, blockType);
			}else{
				block = defaultType;
			}
			// add new city block at this positionm
			// going to do this with a sort of DLA
			var stuck:Boolean = false;
			var lastPos = new Point(block.x, block.y);
			do{
				lastPos = new Point(block.x, block.y);
				if(OverrideDir === false){
					var dir = Math.floor(Math.random()*3);
				}else{
					var dir = OverrideDir;
				}
				switch (dir)
				{
					case 0:
						block.x += 1;
						break;
					case 1:
						block.x -= 1;
						break;
					default:
						block.y += 1;
						break;
				}
				block.reset(block.x, block.y);
				// keep the block on the screen
				if(FlxG.overlap(block, city, function(newBlock, cityBlock){
					// we need to store the existing city block on the new block so that if it is destroyed, the new block falls
					newBlock.cityParent = cityBlock;
				})){
					stuck = true;
				}
			}while(!stuck && block.y + block.height < gameArea.height && block.x < gameArea.width && block.x > 0);
			if(stuck){
				block.x = lastPos.x; block.y = lastPos.y;
				city.add(block);
			}
		}
	}
}