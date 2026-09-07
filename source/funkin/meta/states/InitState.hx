package funkin.meta.states;

import flixel.FlxSprite;
import flixel.FlxG;

import openfl.Lib;
import haxe.Json;

import sys.io.File;
import sys.FileSystem;

typedef InitMeta = {
    var windowTitle:String;
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

class InitState extends MusicBeatState
{
    public var funkinLogo:FlxSprite;
    public var funkinScale:Float = 0.75;
    private var timer:Float = 0;

    public var InitJson:InitMeta;

    override function create()
    {
        FlxG.mouse.visible = false;

        InitJson = Json.parse(File.getContent(Paths.modFolders('Init.json')));

        Lib.application.window.title = InitJson.windowTitle;

        Redirects.TitleState = InitJson.redirects.TitleState;
        Redirects.MainMenuState = InitJson.redirects.MainMenuState;
        Redirects.StoryMenuState = InitJson.redirects.StoryMenuState;
        Redirects.FreeplayState = InitJson.redirects.FreeplayState;
        Redirects.CreditsState = InitJson.redirects.CreditsState;
        Redirects.OptionsState = InitJson.redirects.OptionsState;
        
        funkinLogo = new FlxSprite().loadGraphic(Paths.image('SoulZainzzLogo'));
        funkinLogo.screenCenter();
        funkinLogo.scale.x = funkinScale;
        funkinLogo.scale.y = funkinScale;
        add(funkinLogo);

        super.create();
    }

    override function update(elapsed:Float)
    {
        timer += elapsed;

        if (timer >= 4.5 || skipSplash())
        {
            MusicBeatState.switchState(new TitleState());
        }

        super.update(elapsed);
    }

    function skipSplash(){
        return FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.ESCAPE;
    }
}