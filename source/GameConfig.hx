package;

import haxe.Json;
import openfl.Lib;

typedef GameConfigJson = {
    var WindowTitle:String;
    var WindowIcon:String;
    var LogoPath:String;
    var extensions:Extensions;
}

typedef Extensions = {
    var lua:Array<String>;
    var haxe:Array<String>;
    var swift:Array<String>;
}

class GameConfig
{
    public static var luaExts = ['lua'];
    public static var hxExts = ['hx', 'hxs', 'hscript'];
    public static var swiftExts = ['swift'];
    public static var gameConfig:GameConfigJson;

    public static function initJson(){
        gameConfig = Json.parse(sys.io.File.getContent('_config/GameConfig.json'));
    }

    public static function setExts(){
        luaExts = gameConfig.extensions.lua;
        hxExts = gameConfig.extensions.haxe;
        swiftExts = gameConfig.extensions.swift;
    }

    public static function setWindowTitle(){
        Lib.application.window.title = gameConfig.WindowTitle;
    }

    public static function setWindowIcon(){
        Paths.changeIconFromGraphic(Paths.image(gameConfig.WindowIcon));
    }

    public static function getLogoPath(){
        return gameConfig.LogoPath;
    }
}