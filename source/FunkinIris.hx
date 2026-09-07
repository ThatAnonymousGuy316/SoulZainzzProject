package;

import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;

import flixel.util.FlxColor;
import openfl.display.BitmapData;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;

import openfl.Lib;

class FunkinIris
{
    public var script:Iris;
    public var ScriptPath:String;
    
    public function new(ScriptPath:String)
    {
        this.ScriptPath = ScriptPath;
        if (sys.FileSystem.exists(ScriptPath)){
            final rules:RawIrisConfig = {name: haxe.io.Path.withoutDirectory(haxe.io.Path.withoutExtension(ScriptPath)), autoRun: false, autoPreset: true};
            final getText:String->String = #if sys sys.io.File.getContent #elseif openfl openfl.utils.Assets.getText #end;
            script = new Iris(getText(ScriptPath), rules);

            new IrisPreset(this);

            script.execute();

            callAlias(['onCreate', 'onLoad', 'new']);
        }
    }

    public function destroy()
    {
        if (script != null){
            script.destroy();
        }
    }

    public function set(AValue:String, BValue:Dynamic){
        if (script != null){
            script.set(AValue, BValue);
        }
    }

    public function call(AValue:String, ?BValue:Array<Dynamic>){
        if (script != null){
            if (script.exists(AValue)){
                script.call(AValue, BValue);
            }
        }
    }

    public function setAlias(AValues:Array<String>, BValue:Dynamic){
        for (AValue in AValues){
            set(AValue, BValue);
        }
    }

    public function callAlias(AValues:Array<String>, ?BValue:Array<Dynamic>){
        for (AValue in AValues){
            call(AValue, BValue);
        }
    }
}

class IrisPreset
{
    public function presetValues():Map<String, Dynamic>
    {
        return [
            'FlxG' => flixel.FlxG,
            'mouse' => flixel.FlxG.mouse,
            'subState' => flixel.FlxG.state.subState,
            'save' => flixel.FlxG.save,
            'saveData' => flixel.FlxG.save.data,
            'FlxBasic' => flixel.FlxBasic,
            'FlxCamera' => flixel.FlxCamera,
            'FlxState' => flixel.FlxState,
            'FlxSubState' => flixel.FlxSubState,
            'FlxObject' => flixel.FlxObject,
            'FlxSprite' => flixel.FlxSprite,
            'FlxStrip' => flixel.FlxStrip,
            'FlxColor' => CustomFlxColor,
            'FlxMath' => flixel.math.FlxMath,
            'FlxSound' => flixel.sound.FlxSound,
            'FlxSoundGroup' => flixel.sound.FlxSoundGroup,
            'FlxEase' => flixel.tweens.FlxEase,
            'FlxPath' => flixel.path.FlxPath,
            'FlxGraphic' => flixel.graphics.FlxGraphic,
            'FlxAtlasFrames' => flixel.graphics.frames.FlxAtlasFrames,
            'FlxText' => flixel.text.FlxText,
            'FlxInputText' => flixel.text.FlxInputText,
            'FlxInputTextManager' => flixel.text.FlxInputTextManager,
            'FlxBitmapText' => flixel.text.FlxBitmapText,
            'FlxAnimate' => flxanimate.FlxAnimate,
            'FlxSave' => flixel.util.FlxSave,
            'FlxSpriteUtil' => flixel.util.FlxSpriteUtil,
            'FlxStringUtil' => flixel.util.FlxStringUtil,
            'FlxDestroyUtil' => flixel.util.FlxDestroyUtil,
            'FlxAsepriteUtil' => flixel.graphics.FlxAsepriteUtil,
            'FlxSort' => flixel.util.FlxSort,
            'FlxGradient' => flixel.util.FlxGradient,
            'FlxTimer' => flixel.util.FlxTimer,
            'FlxAnimation' => flixel.animation.FlxAnimation,
            'FlxAnimationController' => flixel.animation.FlxAnimationController,
            'FlxPrerotatedAnimation' => flixel.animation.FlxPrerotatedAnimation,
            'FlxBar' => flixel.ui.FlxBar,
            'FlxButton' => flixel.ui.FlxButton,
            'FlxSpriteButton' => flixel.ui.FlxSpriteButton,
            'FlxBitmapTextButton' => flixel.ui.FlxBitmapTextButton,
            'FlxAnalog' => flixel.ui.FlxAnalog,
            'FlxVirtualPad' => flixel.ui.FlxVirtualPad,
            'FlxVirtualStick' => flixel.ui.FlxVirtualStick,
            'FlxGroup' => flixel.group.FlxGroup,
            'FlxSpriteGroup' => flixel.group.FlxSpriteGroup,
            


            'FlxUISlider' => flixel.addons.ui.FlxUISlider,
            'FlxUICursor' => flixel.addons.ui.FlxUICursor,
            'FlxUIButton' => flixel.addons.ui.FlxUIButton,
            'FlxInputTextAddon' => flixel.addons.ui.FlxInputText,
            'FlxUISpriteButton' => flixel.addons.ui.FlxUISpriteButton,
            'FlxUIMouse' => flixel.addons.ui.FlxUIMouse,
            'FlxUIBar' => flixel.addons.ui.FlxUIBar,
            'FlxUICheckBox' => flixel.addons.ui.FlxUICheckBox,
            'FlxUITabMenu' => flixel.addons.ui.FlxUITabMenu,
            'FlxUIText' => flixel.addons.ui.FlxUIText,
            'FlxUITypedButton' => flixel.addons.ui.FlxUITypedButton,
            'FlxUIState' => flixel.addons.ui.FlxUIState,
            'FlxUISubState' => flixel.addons.ui.FlxUISubState,
            'FlxUITooltip' => flixel.addons.ui.FlxUITooltip,
            'FlxUITooltipManager' => flixel.addons.ui.FlxUITooltipManager,
            'FlxUIInputText' => flixel.addons.ui.FlxUIInputText,
            'FlxUIPopup' => flixel.addons.ui.FlxUIPopup,
            'FlxUIDropDownMenu' => FlxUIDropDownMenuCustom,



            'BitmapData' => openfl.display.BitmapData,



            'Iris' => Iris,
            'IrisConfig' => IrisConfig,
            'IrisInterp' => crowplexus.hscript.Interp,
            'IrisParser' => crowplexus.hscript.Parser,



            'FunkinIris' => FunkinIris,
            'FunkinLua' => FunkinLua,



            'Path' => haxe.io.Path,



            'SpriteFromSheet' => SpriteFromSheet,
            'BGSprite' => BGSprite,
            'FlxBackdrop' => flixel.addons.display.FlxBackdrop,



            'PlayState' => PlayState,
            'Note' => Note,
            'NoteSplash' => NoteSplash,
            'StrumNote' => StrumNote,
            'MusicBeatState' => MusicBeatState,
            'MusicBeatSubstate' => MusicBeatSubstate,
            'HealthIcon' => HealthIcon,
            'Character' => Character,
            'Alphabet' => Alphabet,
            'AttachedSprite' => AttachedSprite,
            'AttachedText' => AttachedText,
            'Boyfriend' => Boyfriend,
            'Highscore' => Highscore,
            'ClientPrefs' => ClientPrefs,
            'ColorSwap' => ColorSwap,
            'Song' => Song,
            'Section' => Section,
            'StageData' => StageData,
            'BackgroundDancer' => BackgroundDancer,
            'BackgroundGirls' => BackgroundGirls,
            'CheckboxThingie' => CheckboxThingie
        ];
    }

    public function presetValuesAlias():Map<Array<String>, Dynamic>
    {
        return [
            ['state', 'game', 'instance'] => flixel.FlxG.state,
            ['Controls', 'keys'] => flixel.FlxG.keys,
            ['Paths', 'FilePaths'] => Paths,
            ['DialogueBox', 'DialogueBoxPsych'] => DialogueBoxPsych
         ];
    }
    
    public function new(instance:FunkinIris)
    {
        for (name => value in presetValues()){
            instance.set(name, value);
        }

        for (names => value in presetValuesAlias()){
            instance.setAlias(names, value);
        }

        /*instance.set('FlxVideo', hxvlc.flixel.FlxVideo);
        instance.set('FlxVideoSprite', hxvlc.flixel.FlxVideoSprite);
        instance.set('FlxInternalVideo', hxvlc.flixel.FlxInternalVideo);*/

        instance.set('Std', Std);
        instance.set('StringTools', StringTools);
        instance.set('Dynamic', Dynamic);
        instance.set('Array', Array);
        instance.set('Xml', Xml);
        instance.set('Date', Date);
        instance.set('Math', Math);
        instance.set('Reflect', Reflect);
        instance.set('Type', Type);
        instance.set('Json', haxe.Json);
        instance.set('StringMap', haxe.ds.StringMap);
        instance.set('IntMap', haxe.ds.IntMap);
        instance.set('ObjectMap', haxe.ds.ObjectMap);

        instance.set('__script__', instance);
        instance.set('super', function(){
            return instance;
        });

        instance.set('exit', function(){
            Sys.exit(0);
        });

        instance.set('windowName', function(daName:String){
            Lib.application.window.title = daName;
        });

        instance.set('switchState', function(newState:String){
            MusicBeatState.switchState(new HXState(newState));
        });

        instance.set('openSubState', function(newState:String){
            flixel.FlxG.state.openSubState(new HXSubState(newState));
        });

        instance.setAlias(['add', 'addSprite'], flixel.FlxG.state.add);
        instance.setAlias(['remove', 'removeSprite'], flixel.FlxG.state.remove);
        instance.setAlias(['insert', 'insertSprite'], flixel.FlxG.state.insert);

        instance.setAlias(["FlxCameraFollowStyle"], {
			LOCKON: flixel.FlxCamera.FlxCameraFollowStyle.LOCKON,
			PLATFORMER: flixel.FlxCamera.FlxCameraFollowStyle.PLATFORMER,
			TOPDOWN: flixel.FlxCamera.FlxCameraFollowStyle.TOPDOWN,
			TOPDOWN_TIGHT: flixel.FlxCamera.FlxCameraFollowStyle.TOPDOWN_TIGHT,
			SCREEN_BY_SCREEN: flixel.FlxCamera.FlxCameraFollowStyle.SCREEN_BY_SCREEN,
			NO_DEAD_ZONE: flixel.FlxCamera.FlxCameraFollowStyle.NO_DEAD_ZONE,

		});
		instance.setAlias(["FlxTextBorderStyle"], {
			NONE: flixel.text.FlxText.FlxTextBorderStyle.NONE,
			SHADOW: flixel.text.FlxText.FlxTextBorderStyle.SHADOW,
			OUTLINE: flixel.text.FlxText.FlxTextBorderStyle.OUTLINE,
			OUTLINE_FAST: flixel.text.FlxText.FlxTextBorderStyle.OUTLINE_FAST
		});
		instance.setAlias(["FlxTextAlign"], {
			CENTER: flixel.text.FlxText.FlxTextAlign.CENTER,
			JUSTIFY: flixel.text.FlxText.FlxTextAlign.JUSTIFY,
			LEFT: flixel.text.FlxText.FlxTextAlign.LEFT,
			RIGHT: flixel.text.FlxText.FlxTextAlign.RIGHT
		});
		instance.setAlias(["setTxtFormat"], function(txt:flixel.text.FlxText, ?Font:String, Size:Int = 8, Color:FlxColor = FlxColor.WHITE, ?Alignment:flixel.text.FlxText.FlxTextAlign, ?BorderStyle:flixel.text.FlxText.FlxTextBorderStyle, BorderColor:FlxColor = FlxColor.TRANSPARENT, EmbeddedFont:Bool = true){
			txt.setFormat(Font, Size, Color, Alignment, BorderStyle, BorderColor, EmbeddedFont);
		});

		instance.setAlias(["FlxAxes"], {
			X: flixel.util.FlxAxes.X,
			Y: flixel.util.FlxAxes.Y,
			XY: flixel.util.FlxAxes.XY
		});

        instance.setAlias(["FlxBarFillDirection"], {
            LEFT_TO_RIGHT: flixel.ui.FlxBar.FlxBarFillDirection.LEFT_TO_RIGHT,
            RIGHT_TO_LEFT: flixel.ui.FlxBar.FlxBarFillDirection.RIGHT_TO_LEFT,
            TOP_TO_BOTTOM: flixel.ui.FlxBar.FlxBarFillDirection.TOP_TO_BOTTOM,
            BOTTOM_TO_TOP: flixel.ui.FlxBar.FlxBarFillDirection.BOTTOM_TO_TOP,
            HORIZONTAL_INSIDE_OUT: flixel.ui.FlxBar.FlxBarFillDirection.HORIZONTAL_INSIDE_OUT,
            HORIZONTAL_OUTSIDE_IN: flixel.ui.FlxBar.FlxBarFillDirection.HORIZONTAL_OUTSIDE_IN,
            VERTICAL_INSIDE_OUT: flixel.ui.FlxBar.FlxBarFillDirection.VERTICAL_INSIDE_OUT,
            VERTICAL_OUTSIDE_IN: flixel.ui.FlxBar.FlxBarFillDirection.VERTICAL_OUTSIDE_IN
        });

        instance.set('FlxHorizontalAlign', {
            LEFT: flixel.util.FlxHorizontalAlign.LEFT,
            CENTER: flixel.util.FlxHorizontalAlign.CENTER,
            RIGHT: flixel.util.FlxHorizontalAlign.RIGHT
        });

        instance.set('FlxVerticalAlign', {
            TOP: flixel.util.FlxVerticalAlign.TOP,
            CENTER: flixel.util.FlxVerticalAlign.CENTER,
            BOTTOM: flixel.util.FlxVerticalAlign.BOTTOM
        });
    }
}

class CustomFlxColor {
	public static var TRANSPARENT(default, null):Int = FlxColor.TRANSPARENT;
	public static var BLACK(default, null):Int = FlxColor.BLACK;
	public static var WHITE(default, null):Int = FlxColor.WHITE;
	public static var GRAY(default, null):Int = FlxColor.GRAY;

	public static var GREEN(default, null):Int = FlxColor.GREEN;
	public static var LIME(default, null):Int = FlxColor.LIME;
	public static var YELLOW(default, null):Int = FlxColor.YELLOW;
	public static var ORANGE(default, null):Int = FlxColor.ORANGE;
	public static var RED(default, null):Int = FlxColor.RED;
	public static var PURPLE(default, null):Int = FlxColor.PURPLE;
	public static var BLUE(default, null):Int = FlxColor.BLUE;
	public static var BROWN(default, null):Int = FlxColor.BROWN;
	public static var PINK(default, null):Int = FlxColor.PINK;
	public static var MAGENTA(default, null):Int = FlxColor.MAGENTA;
	public static var CYAN(default, null):Int = FlxColor.CYAN;

	public static function fromInt(Value:Int):Int 
		return cast FlxColor.fromInt(Value);

	public static function fromRGB(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):Int
		return cast FlxColor.fromRGB(Red, Green, Blue, Alpha);

	public static function fromRGBFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1):Int
		return cast FlxColor.fromRGBFloat(Red, Green, Blue, Alpha);

	public static inline function fromCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float = 1):Int
		return cast FlxColor.fromCMYK(Cyan, Magenta, Yellow, Black, Alpha);

	public static function fromHSB(Hue:Float, Sat:Float, Brt:Float, Alpha:Float = 1):Int
		return cast FlxColor.fromHSB(Hue, Sat, Brt, Alpha);

	public static function fromHSL(Hue:Float, Sat:Float, Light:Float, Alpha:Float = 1):Int
		return cast FlxColor.fromHSL(Hue, Sat, Light, Alpha);

	public static function fromString(str:String):Int
		return cast FlxColor.fromString(str);
}