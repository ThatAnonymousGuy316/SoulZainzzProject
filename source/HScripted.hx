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
            stateScript = new FunkinHScript(Paths.modFolders('scripts/states/${StateScriptPath}.${i}'));
            for (name in ['this', 'instance', '_state_']){
                stateScript.set(name, this);
            }
            stateScript.set('controls', controls);
            stateScript.call('onState', []);
        }
    }

    override function destroy(){
        stateScript.destroy();
        super.destroy();
    }

    override function update(elapsed:Float){
        super.update(elapsed);

        stateScript.call('onUpdate', [elapsed]);
    }

    override public function stepHit():Void
	{
		super.stepHit();
        stateScript.set('curStep', curStep);
        stateScript.call('onStepHit', []);
	}

	override public function beatHit():Void
	{
		super.beatHit();
        stateScript.set('curBeat', curBeat);
        stateScript.call('onBeatHit', []);
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
            stateScript = new FunkinHScript(Paths.modFolders('scripts/states/substates/${StateScriptPath}.${i}'));
            for (name in ['this', 'instance', '_state_']){
                stateScript.set(name, this);
            }
            stateScript.set('controls', controls);
            stateScript.set('close', function(){
                close();
            });
            stateScript.call('onState', []);
        }
    }

    override function destroy(){
        stateScript.destroy();
        super.destroy();
    }

    override function update(elapsed:Float){
        super.update(elapsed);

        stateScript.call('onUpdate', [elapsed]);
    }

    override public function stepHit():Void
	{
		super.stepHit();
        stateScript.set('curStep', curStep);
        stateScript.call('onStepHit', []);
	}

	override public function beatHit():Void
	{
		super.beatHit();
        stateScript.set('curBeat', curBeat);
        stateScript.call('onBeatHit', []);
	}
}