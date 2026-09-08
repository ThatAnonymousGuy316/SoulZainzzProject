package funkin.meta.states;

import flixel.FlxSprite;
import flixel.FlxG;

import openfl.Lib;
import haxe.Json;

import sys.io.File;
import sys.FileSystem;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

typedef InitMeta = {
    var windowTitle:String;
    var startupLogo:String;
    var extensions:ScriptExtMeta;
    var redirects:RedirectMeta;
}

typedef RedirectMeta = {
    var TitleState:String;
    var MainMenuState:String;
    var StoryMenuState:String;
    var FreeplayState:String;
    var CreditsState:String;
    var OptionsState:String;
}

typedef ScriptExtMeta = {
    var lua:Array<String>;
    var hscript:Array<String>;
}

class InitState extends MusicBeatState
{
    public var funkinLogo:FlxSprite;
    public var funkinScale:Float = 0.75;
    public var logo:String = 'SoulZainzzLogo';
    public var InitJson:InitMeta;

    override function create()
    {
        FlxG.mouse.visible = false;

        var path = Paths.getPreloadPath('Init.json');

        if (sys.FileSystem.exists(Paths.modFolders('Init.json')))
            path = Paths.modFolders('Init.json');

        if (sys.FileSystem.exists(path))
        {
            InitJson = Json.parse(File.getContent(path));

            Lib.application.window.title = InitJson.windowTitle;

            Redirects.TitleState = InitJson.redirects.TitleState;
            Redirects.MainMenuState = InitJson.redirects.MainMenuState;
            Redirects.StoryMenuState = InitJson.redirects.StoryMenuState;
            Redirects.FreeplayState = InitJson.redirects.FreeplayState;
            Redirects.CreditsState = InitJson.redirects.CreditsState;
            Redirects.OptionsState = InitJson.redirects.OptionsState;

            ScriptExts.Lua = InitJson.extensions.lua;
            ScriptExts.HScript = InitJson.extensions.hscript;
            
            logo = InitJson.startupLogo;
        }

        funkinLogo = new FlxSprite().loadGraphic(Paths.image(logo));
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
                        MusicBeatState.switchState(new TitleState());
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
            MusicBeatState.switchState(new TitleState());
            return;
        }

        super.update(elapsed);
    }

    function skipSplash(){
        return FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.ESCAPE;
    }
}