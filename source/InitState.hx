package;

import flixel.FlxSprite;
import flixel.FlxG;

import openfl.Lib;
import haxe.Json;

import sys.io.File;
import sys.FileSystem;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

using StringTools;

class InitState extends MusicBeatState
{
    public var funkinLogo:FlxSprite;
    public var funkinScale:Float = 0.75;
    public var logo:String = 'SoulZainzzLogo';

    override function create()
    {
        FlxG.mouse.visible = false;
        FlxG.mouse.useSystemCursor = true;

        GameConfig.initJson();
        GameConfig.setExts();
        GameConfig.setWindowTitle();

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