package;

#if mobileC
import mobile.MobileControls;
import mobile.flixel.FlxVirtualPad;
import flixel.FlxCamera;
import flixel.input.actions.FlxActionInput;
import flixel.util.FlxDestroyUtil;
#end

class HScriptedState extends MusicBeatState
{
    public var stateScript:FunkinHScript;
    public var StateScriptPath:String;
    public var stateArgs:Array<Dynamic> = [];

    public function new(StateScriptPath:String, ?stateArgs:Array<Dynamic>){
        super();
        this.StateScriptPath = StateScriptPath;
        if (stateArgs == null)
			stateArgs = [];
        this.stateArgs = stateArgs;
    }

    override function create(){
        for (i in GameConfig.hxExts){
            if (sys.FileSystem.exists(Paths.modFolders('scripts/states/${StateScriptPath}.${i}'))){
                stateScript = new FunkinHScript(Paths.modFolders('scripts/states/${StateScriptPath}.${i}'));
                for (name in ['this', 'instance', '_state_']){
                    stateScript.set(name, this);
                }
                stateScript.set('controls', controls);
                stateScript.set('addDPad', function(){
                    // too lazy to remove :/
                });
                stateScript.set('removeDPad', function(){
                    // too lazy to remove :/
                });
                stateScript.set('switchFromTitleonMobile', function(){
                    // too lazy to remove :/
                });
                stateScript.call('onState', stateArgs);
            }
        }

        #if mobileC
        addVirtualPadCamera();
        #end

        super.create();

        #if mobileC
        addVirtualPad(LEFT_FULL, A_B_C);
        #end
    }

    override public function onFocusLost():Void {
        if (stateScript != null)
            stateScript.call('onFocusLost', []);
        super.onFocusLost();
    }

    override public function onFocus():Void {
        if (stateScript != null)
            stateScript.call('onFocus', []);
        super.onFocus();
    }


    override function destroy(){
        if (stateScript != null){
            stateScript.call('onDestroy', []);
            stateScript.destroy();
        }
        #if mobileC
        removeVirtualPad();
        #end
        super.destroy();
    }

    override function update(elapsed:Float){
        if (stateScript != null)
            stateScript.call('onUpdate', [elapsed]);

        super.update(elapsed);
    }

    override public function stepHit():Void
	{
        if (stateScript != null){
            stateScript.set('curStep', curStep);
            stateScript.call('onStepHit', []);
        }

        super.stepHit();
	}

	override public function beatHit():Void
	{
        if (stateScript != null){
            stateScript.set('curBeat', curBeat);
            stateScript.call('onBeatHit', []);
        }
        super.beatHit();
	}
}

class HScriptedSubState extends MusicBeatSubstate
{
    public var stateScript:FunkinHScript;
    public var StateScriptPath:String;
    public var stateArgs:Array<Dynamic> = [];

    public function new(StateScriptPath:String, ?stateArgs:Array<Dynamic>){
        super();
        this.StateScriptPath = StateScriptPath;
        if (stateArgs == null)
			stateArgs = [];
        this.stateArgs = stateArgs;
    }

    override function create(){
        for (i in GameConfig.hxExts){
            if (sys.FileSystem.exists(Paths.modFolders('scripts/states/substates/${StateScriptPath}.${i}'))){
                stateScript = new FunkinHScript(Paths.modFolders('scripts/states/substates/${StateScriptPath}.${i}'));
                for (name in ['this', 'instance', '_substate_']){
                    stateScript.set(name, this);
                }
                stateScript.set('controls', controls);
                stateScript.set('addToSubState', this.add);
                stateScript.set('insertToSubState', this.insert);
                stateScript.set('removeFromSubState', this.remove);
                stateScript.set('close', function(){
                    close();
                });
                stateScript.set('addDPad', function(){
                    // too lazy to remove :/
                });
                stateScript.set('removeDPad', function(){
                    // too lazy to remove :/
                });
                stateScript.call('onSubState', stateArgs);
            }
        }

        #if mobileC
        addVirtualPadCamera();
        #end

        super.create();

        #if mobileC
        addVirtualPad(LEFT_FULL, A_B);
        #end
    }

    override function destroy(){
        if (stateScript != null){
            stateScript.call('onDestroy', []);
            stateScript.destroy();
        }
        #if mobileC
        removeVirtualPad();
        #end
        super.destroy();
    }

    override function update(elapsed:Float){
        if (stateScript != null)
            stateScript.call('onUpdate', [elapsed]);
        super.update(elapsed);
    }

    override public function stepHit():Void
	{
        if (stateScript != null){
            stateScript.set('curStep', curStep);
            stateScript.call('onStepHit', []);
        }
        super.stepHit();
	}

	override public function beatHit():Void
	{
        if (stateScript != null){
            stateScript.set('curBeat', curBeat);
            stateScript.call('onBeatHit', []);
        }
        super.beatHit();
	}
}