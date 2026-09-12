package;

#if desktop
import Discord.DiscordClient;
#end

import flixel.FlxSprite;
import flixel.FlxG;

import openfl.Lib;
import haxe.Json;

import sys.io.File;
import sys.FileSystem;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import flixel.input.keyboard.FlxKey;

import lime.app.Application;

using StringTools;

class InitState extends MusicBeatState
{
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
    
    public var funkinLogo:FlxSprite;
    public var funkinScale:Float = 0.75;
    public var logo:String = 'SoulZainzzLogo';

    override function create()
    {
        Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();

        FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();

        FlxG.mouse.visible = false;
        FlxG.mouse.useSystemCursor = false;

        FlxG.save.bind('soulzainzz', 'irissoulWuzzainzz');

		ClientPrefs.loadPrefs();

        Highscore.load();

        GameConfig.initJson();
        GameConfig.setExts();
        GameConfig.setWindowTitle();
        GameConfig.getPlugins();
        GameConfig.getInitialState();

        #if desktop
		if (!DiscordClient.isInitialized)
		{
			DiscordClient.initialize();
			Application.current.onExit.add (function (exitCode) {
				DiscordClient.shutdown();
			});
		}
		#end

        funkinLogo = new FlxSprite().loadGraphic(Paths.image(GameConfig.getLogoPath()));
        funkinLogo.screenCenter();

        funkinLogo.scale.set(0.25, 0.25);

        add(funkinLogo);

        FlxTween.tween(funkinLogo.scale, {x: 0.75, y: 0.75}, 1.0, {
            ease: FlxEase.quadOut,
            onComplete: function(tween:FlxTween)
            {
                FlxTween.tween(funkinLogo, {alpha: 0}, 0.75, {
                    startDelay: 0.5,
                    ease: FlxEase.quadIn,
                    onComplete: function(tween:FlxTween)
                    {
                       MusicBeatState.switchState(new HScriptedState(GameConfig.InitialState));
                    }
                });
            }
        });

        super.create();
    }

    override function update(elapsed:Float)
    {
        if (skipSplash())
        {
            MusicBeatState.switchState(new HScriptedState(GameConfig.InitialState));
            return;
        }

        super.update(elapsed);
    }

    function skipSplash(){
        return FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.ESCAPE;
    }
}