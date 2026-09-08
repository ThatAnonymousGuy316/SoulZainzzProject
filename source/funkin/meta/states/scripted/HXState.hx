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
        if (irisScript != null)
            irisScript.destroy();
        super.destroy();
    }

    override function create()
    {
        for (ext in ScriptExts.HScript){
            var path = Paths.getPreloadPath('states/${FilePath}.${ext}');
            if (sys.FileSystem.exists(Paths.modFolders('states/${FilePath}.${ext}')))
                path = Paths.modFolders('states/${FilePath}.${ext}');
            if (sys.FileSystem.exists(path)){
                irisScript = new FunkinIris(path);
                irisScript.set('__state__', this);
                irisScript.set('controls', controls);
                irisScript.call('onState', []);
            }
        }

        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (irisScript != null)
            irisScript.call('onUpdate', [elapsed]);
    }
    
    override function beatHit()
    {
        super.beatHit();
        if (irisScript != null){
            irisScript.set('curBeat', curBeat);
            irisScript.call('onBeatHit', []);
        }
    }

    override function stepHit()
    {
        super.stepHit();
        if (irisScript != null){
            irisScript.set('curStep', curStep);
            irisScript.call('onStepHit', []);
        }
    }
}