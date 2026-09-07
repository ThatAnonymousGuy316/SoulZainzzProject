package funkin.meta.states.scripted;

class HXState extends MusicBeatState
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
        irisScript = new FunkinIris(Paths.modFolders('states/${FilePath}.hx'));
        irisScript.set('__state__', this);
        irisScript.set('controls', controls);
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