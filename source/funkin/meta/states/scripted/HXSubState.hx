package funkin.meta.states.scripted;

class HXSubState extends MusicBeatSubstate
{
    public var irisScript:FunkinIris;
    public var FilePath:String;

    public function new(FilePath:String)
    {
        super();
        this.FilePath = FilePath;
    }

    override function destroy()
    {
        irisScript.destroy();
        super.destroy();
    }

    override function create()
    {
        var path = Paths.getPreloadPath('states/substates/${FilePath}.hx');
        if (sys.FileSystem.exists(Paths.modFolders('states/substates/${FilePath}.hx')))
            path = Paths.modFolders('states/substates/${FilePath}.hx');
        irisScript = new FunkinIris(path);
        irisScript.set('__substate__', this);
        irisScript.set('controls', controls);
        irisScript.set('close', function(){
            close();
        });
        irisScript.call('onState', []);

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        irisScript.call('onUpdate', [elapsed]);
    }
    
    override function beatHit()
    {
        super.beatHit();
        irisScript.set('curBeat', curBeat);
        irisScript.call('onBeatHit', []);
    }

    override function stepHit()
    {
        super.stepHit();
        irisScript.set('curStep', curStep);
        irisScript.call('onStepHit', []);
    }
}