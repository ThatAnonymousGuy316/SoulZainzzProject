package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class NoteSplash extends FlxSprite
{
	public var colorSwap:ColorSwap = null;
	private var idleAnim:String;
	private var textureLoaded:String = null;

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;

		loadAnims(skin);
		
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;

		setupNoteSplash(x, y, note);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function setupNoteSplash(x:Float, y:Float, note:Int = 0, texture:String = null, hueColor:Float = 0, satColor:Float = 0, brtColor:Float = 0) {
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		alpha = 0.6;

		if(texture == null) {
			texture = 'noteSplashes';
			if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) texture = PlayState.SONG.splashSkin;
		}

		if(textureLoaded != texture) {
			loadAnims(texture);
		}
		colorSwap.hue = hueColor;
		colorSwap.saturation = satColor;
		colorSwap.brightness = brtColor;
		offset.set(-30, -5);

		var animNum:Int = FlxG.random.int(1, 2);
		animation.play('note' + note + '-' + animNum, true);
		if(animation.curAnim != null)animation.curAnim.frameRate = 30;
	}

	function loadAnims(skin:String) {
		if (!PlayState.isPixelStage)
		{
			switch (ClientPrefs.splashSkin)
			{
				default:
					if (GameConfig.noteSplashData.exists(ClientPrefs.splashSkin))
					{
						frames = Paths.getSparrowAtlas(GameConfig.noteSplashData.get(ClientPrefs.splashSkin));
					}
					else
					{
						frames = Paths.getSparrowAtlas(skin);
					}
					animation.addByPrefix("note1-1", "note splash blue 1", 30, false);
					animation.addByPrefix("note2-1", "note splash green 1", 30, false);
					animation.addByPrefix("note0-1", "note splash purple 1", 30, false);
					animation.addByPrefix("note3-1", "note splash red 1", 30, false);
					animation.addByPrefix("note1-2", "note splash blue 1", 30, false);
					animation.addByPrefix("note2-2", "note splash green 1", 30, false);
					animation.addByPrefix("note0-2", "note splash purple 1", 30, false);
					animation.addByPrefix("note3-2", "note splash red 1", 30, false);
			}
		}
		else
		{
			frames = Paths.getSparrowAtlas(skin);
			animation.addByPrefix("note1-1", "note splash blue 1", 30, false);
			animation.addByPrefix("note2-1", "note splash green 1", 30, false);
			animation.addByPrefix("note0-1", "note splash purple 1", 30, false);
			animation.addByPrefix("note3-1", "note splash red 1", 30, false);
			animation.addByPrefix("note1-2", "note splash blue 1", 30, false);
			animation.addByPrefix("note2-2", "note splash green 1", 30, false);
			animation.addByPrefix("note0-2", "note splash purple 1", 30, false);
			animation.addByPrefix("note3-2", "note splash red 1", 30, false);
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim != null)if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}