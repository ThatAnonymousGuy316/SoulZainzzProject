package;

class HScriptedState extends MusicBeatState
{
    public var stateScript:FunkinHScript;
    public var StateScriptPath:String;

    public function new(StateScriptPath:String){
        super();
        this.StateScriptPath = StateScriptPath;
    }

    override function create(){
        super.create();
        for (i in GameConfig.hxExts){
            if (sys.FileSystem.exists(Paths.modFolders('scripts/states/${StateScriptPath}.${i}'))){
                stateScript = new FunkinHScript(Paths.modFolders('scripts/states/${StateScriptPath}.${i}'));
                for (name in ['this', 'instance', '_state_']){
                    stateScript.set(name, this);
                }
                stateScript.set('controls', controls);
                stateScript.call('onState', []);
            }
        }
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
        super.destroy();
    }

    override function update(elapsed:Float){
        super.update(elapsed);
        if (stateScript != null)
            stateScript.call('onUpdate', [elapsed]);
    }

    override public function stepHit():Void
	{
		super.stepHit();
        if (stateScript != null){
            stateScript.set('curStep', curStep);
            stateScript.call('onStepHit', []);
        }
	}

	override public function beatHit():Void
	{
		super.beatHit();
        if (stateScript != null){
            stateScript.set('curBeat', curBeat);
            stateScript.call('onBeatHit', []);
        }
	}
}

class HScriptedSubState extends MusicBeatSubstate
{
    public var stateScript:FunkinHScript;
    public var StateScriptPath:String;

    public function new(StateScriptPath:String){
        super();
        this.StateScriptPath = StateScriptPath;
    }

    override function create(){
        super.create();
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
                stateScript.call('onSubState', []);
            }
        }
    }

    override function destroy(){
        if (stateScript != null){
            stateScript.call('onDestroy', []);
            stateScript.destroy();
        }
        super.destroy();
    }

    override function update(elapsed:Float){
        super.update(elapsed);
        if (stateScript != null)
            stateScript.call('onUpdate', [elapsed]);
    }

    override public function stepHit():Void
	{
		super.stepHit();
        if (stateScript != null){
            stateScript.set('curStep', curStep);
            stateScript.call('onStepHit', []);
        }
	}

	override public function beatHit():Void
	{
		super.beatHit();
        if (stateScript != null){
            stateScript.set('curBeat', curBeat);
            stateScript.call('onBeatHit', []);
        }
	}
}