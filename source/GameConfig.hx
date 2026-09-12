package;

import haxe.Json;
import openfl.Lib;
import haxe.ds.StringMap;
import sys.FileSystem;
using StringTools;

typedef GameConfigJson = {
    var StateLoaders:States;
    var WindowTitle:String;
    var WindowIcon:String;
    var LogoPath:String;
    var BotplayText:String;
    var extensions:Extensions;
}

typedef Extensions = {
    var lua:Array<String>;
    var haxe:Array<String>;
    var swift:Array<String>;
}

typedef States = {
    var InitialState:String;
    var MainMenu:String;
    var StoryMenu:String;
    var Freeplay:String;
    var Pause:String;
}

class GameConfig
{
    public static var customLuaVariables:StringMap<Dynamic> = new StringMap<Dynamic>();
    public static var customLuaFunctions:StringMap<Dynamic> = new StringMap<Dynamic>();
    public static var customHaxeVariables:StringMap<Dynamic> = new StringMap<Dynamic>();
    public static var customHaxeFunctions:StringMap<Dynamic> = new StringMap<Dynamic>();
    public static var customSwiftVariables:StringMap<Dynamic> = new StringMap<Dynamic>();
    public static var customSwiftFunctions:StringMap<Dynamic> = new StringMap<Dynamic>();

    public static var noteSkinData:Map<String, String> = [
        'Chip' => 'NOTE_assets-chip',
        'Future' => 'NOTE_assets-future',
        'Soul' => 'NOTE_assets-soul'
    ];

    public static var noteSplashData:Map<String, String> = [
        'Soul' => 'noteSplashes-soul'
    ];

    public static var luaExts = ['lua'];
    public static var hxExts = ['hx', 'hxs', 'hscript'];
    public static var swiftExts = ['swift'];
    public static var InitialState:String;
    public static var MainMenu:String;
    public static var StoryMenu:String;
    public static var Freeplay:String;
    public static var Pause:String;
    public static var botplayText = '[BOTPLAY]';

    public static var gameConfig:GameConfigJson;

    public static var pluginArray:Array<FunkinHScript> = [];

    public static function initJson(){
        gameConfig = Json.parse(sys.io.File.getContent('_config/GameConfig.json'));
        botplayText = gameConfig.BotplayText;
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

    public static function getInitialState(){
        InitialState = gameConfig.StateLoaders.InitialState;
        MainMenu = gameConfig.StateLoaders.MainMenu;
        StoryMenu = gameConfig.StateLoaders.StoryMenu;
        Freeplay = gameConfig.StateLoaders.Freeplay;
        Pause = gameConfig.StateLoaders.Pause;
    }

    public static function getPlugins(){
        var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('plugins/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('plugins/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/plugins/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					for (i in GameConfig.hxExts){
						if(file.endsWith('.$i') && !filesPushed.contains(file))
						{
                            var daScript = new FunkinHScript(folder + file);
                            daScript.set('addLuaVariable', function(Name:String, Variable:Dynamic){
                                customLuaVariables.set(Name, Variable);
                                Sys.println('Added Variable: ' + Name + ' On Lua');
                            });
                            daScript.set('addLuaFunction', function(Name:String, CallBack:Dynamic){
                                customLuaFunctions.set(Name, CallBack);
                                Sys.println('Added Function: ' + Name + ' On Lua');
                            });
                            daScript.set('addHaxeVariable', function(Name:String, Variable:Dynamic){
                                customHaxeVariables.set(Name, Variable);
                                Sys.println('Added Variable: ' + Name + ' On Haxe/HScript');
                            });
                            daScript.set('addHaxeFunction', function(Name:String, CallBack:Dynamic){
                                customHaxeFunctions.set(Name, CallBack);
                                Sys.println('Added Function: ' + Name + ' On Haxe/HScript');
                            });
                            daScript.set('addSwiftVariable', function(Name:String, Variable:Dynamic){
                                customSwiftVariables.set(Name, Variable);
                                Sys.println('Added Variable: ' + Name + ' On Swift');
                            });
                            daScript.set('addSwiftFunction', function(Name:String, CallBack:Dynamic){
                                customSwiftFunctions.set(Name, CallBack);
                                Sys.println('Added Function: ' + Name + ' On Swift');
                            });
                            daScript.call('plugin', [file, folder]);
							pluginArray.push(daScript);
							filesPushed.push(file);
                            Sys.println('Plugin Started: ' + folder + file);
						}
					}
				}
			}
		}
    }
}