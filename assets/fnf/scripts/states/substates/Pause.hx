var resume:FlxText;
var restartSong:FlxText;
var options:FlxText;
var exit:FlxText;

var menuItems:Array<FlxText>;
var curSelected:Int = 0;

function onSubState()
{
    mouse.visible = false;

    var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	bg.alpha = 0.5;
	bg.scrollFactor.set();
	addToSubState(bg);

    var songTxt:FlxText = new FlxText(0, 0, FlxG.width, PlayState.SONG.song, 32);
    songTxt.setFormat(Paths.font("pah.ttf"), 76, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    songTxt.scrollFactor.set();
    songTxt.borderSize = 2;
    songTxt.antialiasing = ClientPrefs.globalAntialiasing;
    addToSubState(songTxt);

    var diffTxt:FlxText = new FlxText(songTxt.x, songTxt.y + 75, FlxG.width, CoolUtil.difficultyString(), 32);
    diffTxt.setFormat(Paths.font("pah.ttf"), 76, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    diffTxt.scrollFactor.set();
    diffTxt.borderSize = 2;
    diffTxt.antialiasing = ClientPrefs.globalAntialiasing;
    addToSubState(diffTxt);

    resume = makeMenuText("Resume", 0);
    restartSong = makeMenuText("Restart Song", 1);
    options = makeMenuText("Options", 2);
    exit = makeMenuText("Exit", 3);

    menuItems = [resume, restartSong, options, exit];
    curSelected = 0;
    updateSelection();

    this.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
}

function makeMenuText(label:String, index:Int):FlxText
{
    var spacing:Float = 120;
    var totalItems:Int = 4;
    var startY:Float = (FlxG.height / 2) - ((totalItems - 1) * spacing / 2);

    var txt:FlxText = new FlxText(0, startY + (index * spacing), FlxG.width, label, 32);
    txt.setFormat(Paths.font("pah.ttf"), 76, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    txt.scrollFactor.set();
    txt.borderSize = 2;
    txt.antialiasing = ClientPrefs.globalAntialiasing;
    addToSubState(txt);
    return txt;
}

function updateSelection()
{
    for (i in 0...menuItems.length)
    {
        if (i == curSelected)
        {
            menuItems[i].color = FlxColor.LIME;
            menuItems[i].alpha = 1;
        }
        else
        {
            menuItems[i].color = FlxColor.WHITE;
            menuItems[i].alpha = 0.5;
        }
    }
}

function confirmSelection()
{
    switch (curSelected)
    {
        case 0:
            resumeGame();
        case 1:
            MusicBeatState.resetState();
        case 2:
            goToOptions(true);
        case 3:
            if (PlayState.isStoryMode){
                switchState("Story");
            }else{
                switchState("Freeplay");
            }
    }
}

function onUpdate(elapsed)
{
    if (controls.BACK)
    {
        resumeGame();
    }

    if (controls.UI_UP_P)
    {
        curSelected -= 1;
        if (curSelected < 0)
        {
            curSelected = menuItems.length - 1;
        }
        updateSelection();
    }

    if (controls.UI_DOWN_P)
    {
        curSelected += 1;
        if (curSelected >= menuItems.length)
        {
            curSelected = 0;
        }
        updateSelection();
    }

    if (controls.ACCEPT)
    {
        confirmSelection();
    }
}

function resumeGame()
{
    close();
}