var curWeekSelected:Int = 0;
var curDifficulty:Int = 0;
var difficulties:Array<String> = [];
var lastDifficultyName:String = '';

var nene:FlxSprite;
var loadedWeeks:Array<WeekData> = [];
var menuBG:FlxSprite;

var pico:FlxSprite;
var boyfriend:FlxSprite;

var weekGrp:FlxSpriteGroup;
var weekSlots:Array<Dynamic> = [];
var weekSpacing:Float = 450;
var weekTweenTime:Float = 0.2;
var weekY:Float = 100;

var selectorWeekBf:FlxSprite;
var selectorWeekPico:FlxSprite;

var selectorDiffBf:FlxSprite;
var selectorDiffPico:FlxSprite;

var diffText:FlxText;
var diffTextY:Float = 30;
var diffTextDrop:Float = 60;
var diffTweenTime:Float = 0.2;

var txtTracklist:FlxText;
var tracklistY:Float = 0;

var freakyMenu:FlxSound;

var loadingWeek:Bool = false;
var loadDelayTime:Float = 1;
var loadFadeTime:Float = 0.5;
var pendingSongArray:Array<String>;
var pendingDiff:Int;

function onState()
{
    mouse.visible = false;

    DiscordClient.changePresence("Story Menu", null);

	PlayState.isStoryMode = true;
	WeekData.reloadWeekFiles(true);

    menuBG = new FlxSprite().loadGraphic(Paths.image('stageback'));
    add(menuBG);

    pico = new FlxSprite(890, 320);
    pico.frames = Paths.getSparrowAtlas('storymenu/djpico');
    pico.animation.addByPrefix('idle', 'Pico DJ0', 24, true);
    pico.animation.addByPrefix('selected', 'Pico DJ confirm', 24, false);
    pico.animation.play('idle');
    pico.scale.set(1, 1);
    pico.antialiasing = ClientPrefs.globalAntialiasing;
    add(pico);

    boyfriend = new FlxSprite(0, 320);
    boyfriend.frames = Paths.getSparrowAtlas('storymenu/djbf');
    boyfriend.animation.addByPrefix('idle', 'Boyfriend DJ0', 24, true);
    boyfriend.animation.addByPrefix('selected', 'Boyfriend DJ confirm', 24, false);
    boyfriend.animation.play('idle');
    boyfriend.flipX = true;
    boyfriend.scale.set(1, 1);
    boyfriend.antialiasing = ClientPrefs.globalAntialiasing;
    add(boyfriend);

	for (i in 0...WeekData.weeksList.length)
	{
		var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
		loadedWeeks.push(weekFile);
	}

    weekGrp = new FlxSpriteGroup();
    add(weekGrp);

    if (lastDifficultyName == '')
    {
        lastDifficultyName = CoolUtil.defaultDifficulty;
    }

    txtTracklist = new FlxText(0, 0, FlxG.width, "", 28);
    txtTracklist.setFormat(Paths.font("5by7.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    txtTracklist.scrollFactor.set();
    txtTracklist.borderSize = 2;
    txtTracklist.antialiasing = ClientPrefs.globalAntialiasing;
    tracklistY = FlxG.height - 220;
    txtTracklist.y = tracklistY;
    add(txtTracklist);

    curWeekSelected = 0;
    if (loadedWeeks.length > 0)
    {
        WeekData.setDirectoryFromWeek(loadedWeeks[curWeekSelected]);
        updateDifficultiesForWeek(curWeekSelected);
        buildWeekSlots();
        updateTracklist(curWeekSelected);
    }

    diffTextY = weekY + 160;
    diffText = createDiffText(diffTextY);

    selectorWeekBf = new FlxSprite(370, weekY);
    selectorWeekBf.frames = Paths.getSparrowAtlas('freeplay/freeplaySelector');
    selectorWeekBf.animation.addByPrefix('idle', 'arrow pointer loop', 24, true);
    selectorWeekBf.animation.play('idle');
    selectorWeekBf.antialiasing = ClientPrefs.globalAntialiasing;
    add(selectorWeekBf);

    selectorWeekPico = new FlxSprite(870, weekY);
    selectorWeekPico.frames = Paths.getSparrowAtlas('freeplay/freeplaySelector_pico');
    selectorWeekPico.animation.addByPrefix('idle', 'arrow pointer loop', 24, true);
    selectorWeekPico.animation.play('idle');
    selectorWeekPico.antialiasing = ClientPrefs.globalAntialiasing;
    selectorWeekPico.flipX = true;
    add(selectorWeekPico);

    selectorDiffBf = new FlxSprite(FlxG.width / 2, diffTextY - 70);
    selectorDiffBf.frames = Paths.getSparrowAtlas('freeplay/freeplaySelector');
    selectorDiffBf.animation.addByPrefix('idle', 'arrow pointer loop', 24, true);
    selectorDiffBf.animation.play('idle');
    selectorDiffBf.antialiasing = ClientPrefs.globalAntialiasing;
    selectorDiffBf.angle = 90;
    selectorDiffBf.screenCenter(FlxAxes.X);
    add(selectorDiffBf);

    selectorDiffPico = new FlxSprite(FlxG.width / 2, diffTextY + 70);
    selectorDiffPico.frames = Paths.getSparrowAtlas('freeplay/freeplaySelector_pico');
    selectorDiffPico.animation.addByPrefix('idle', 'arrow pointer loop', 24, true);
    selectorDiffPico.animation.play('idle');
    selectorDiffPico.antialiasing = ClientPrefs.globalAntialiasing;
    selectorDiffPico.angle = -90;
    selectorDiffPico.screenCenter(FlxAxes.X);
    add(selectorDiffPico);

    freakyMenu = new FlxSound().loadEmbedded(Paths.music('girlfriendsRingtone/girlfriendsRingtone'));
    freakyMenu.volume = 0.5;
    freakyMenu.play();
}

function onDestroy()
{
    freakyMenu.stop();
    freakyMenu.destroy();
}

function onFocus(){
    freakyMenu.play();
}

function onFocusLost(){
    freakyMenu.pause();
}

function onUpdate(elapsed)
{
    if (loadingWeek)
    {
        return; // block all input while the confirm/fade/load sequence is playing out
    }

    if (keys.justPressed.CONTROL)
    {
        openGameplayChangers();
    }
    
    if (controls.BACK)
    {
        switchState("Menu");
    }

    if (controls.UI_UP_P)
    {
        changeDifficulty(-1);
    }

    if (controls.UI_DOWN_P)
    {
        changeDifficulty(1);
    }

    if (loadedWeeks.length > 0)
    {
        if (controls.UI_RIGHT_P)
        {
            changeWeek(1);
        }
        if (controls.UI_LEFT_P)
        {
            changeWeek(-1);
        }

        if (controls.ACCEPT)
        {
            confirmWeek();
        }
    }
}

function wrapWeekIndex(i:Int):Int
{
    if (i < 0)
    {
        return loadedWeeks.length - 1;
    }
    if (i >= loadedWeeks.length)
    {
        return 0;
    }
    return i;
}

function wrapDiff(i:Int):Int
{
    if (i < 0)
    {
        return difficulties.length - 1;
    }
    if (i >= difficulties.length)
    {
        return 0;
    }
    return i;
}

function updateDifficultiesForWeek(index:Int)
{
    var leWeek:WeekData = loadedWeeks[index];

    var diffs:Array<String> = CoolUtil.defaultDifficulties.copy();

    var diffStr:String = leWeek.difficulties;
    if (diffStr != null)
    {
        diffStr = diffStr.trim();
    }

    if (diffStr != null && diffStr.length > 0)
    {
        var splitDiffs:Array<String> = diffStr.split(',');
        var i:Int = splitDiffs.length - 1;
        while (i > 0)
        {
            if (splitDiffs[i] != null)
            {
                splitDiffs[i] = splitDiffs[i].trim();
                if (splitDiffs[i].length < 1)
                {
                    splitDiffs.remove(splitDiffs[i]);
                }
            }
            --i;
        }

        if (splitDiffs.length > 0 && splitDiffs[0].length > 0)
        {
            diffs = splitDiffs;
        }
    }

    difficulties = diffs;
    CoolUtil.difficulties = diffs;

    if (difficulties.contains(CoolUtil.defaultDifficulty))
    {
        curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
    }
    else
    {
        curDifficulty = 0;
    }

    var newPos:Int = difficulties.indexOf(lastDifficultyName);
    if (newPos > -1)
    {
        curDifficulty = newPos;
    }

    curDifficulty = wrapDiff(curDifficulty);
}

function updateTracklist(index:Int)
{
    var leWeek:WeekData = loadedWeeks[index];

    var songNames:Array<String> = [];
    for (i in 0...leWeek.songs.length)
    {
        songNames.push(leWeek.songs[i][0]);
    }

    var listText:String = songNames.join('\n\n');
    txtTracklist.text = listText.toUpperCase();
    txtTracklist.y = tracklistY;
}

function confirmWeek()
{
    if (loadingWeek)
    {
        return;
    }
    loadingWeek = true;

    FlxG.sound.play(Paths.sound('confirmMenu'));

    boyfriend.animation.play('selected');
    pico.animation.play('selected');

    var leWeek:WeekData = loadedWeeks[curWeekSelected];
    var songArray:Array<String> = [];
    for (i in 0...leWeek.songs.length)
    {
        songArray.push(leWeek.songs[i][0]);
    }

    pendingSongArray = songArray;
    pendingDiff = curDifficulty;

    new FlxTimer().start(loadDelayTime, function(tmr:FlxTimer)
    {
        fadeOutEverything();
    });
}

function fadeOutEverything()
{
    FlxTween.tween(menuBG, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(pico, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(selectorWeekBf, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(selectorWeekPico, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(selectorDiffBf, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(selectorDiffPico, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(diffText, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(txtTracklist, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});

    for (member in weekGrp.members)
    {
        FlxTween.tween(member, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    }

    // boyfriend fades out last of all, and its onComplete is what actually triggers the week load
    FlxTween.tween(boyfriend, {alpha: 0}, loadFadeTime, {
        ease: FlxEase.quadOut,
        onComplete: function(twn:FlxTween)
        {
            loadWeek(pendingSongArray, pendingDiff);
        }
    });
}

function loadWeek(songArray:Array<String>, difficulty:Int)
{
    this.persistentUpdate = false;

    PlayState.storyPlaylist = songArray;
    PlayState.isStoryMode = true;
    PlayState.storyWeek = curWeekSelected;
    PlayState.storyDifficulty = difficulty;
    PlayState.campaignScore = 0;
    PlayState.campaignMisses = 0;

    var diffSuffix:String = CoolUtil.getDifficultyFilePath(difficulty);
    if (diffSuffix == null)
    {
        diffSuffix = '';
    }

    var firstSongLower:String = songArray[0].toLowerCase();
    PlayState.SONG = Song.loadFromJson(firstSongLower + diffSuffix, firstSongLower);

    trace('CURRENT WEEK: ' + WeekData.getWeekFileName());

    LoadingState.loadAndSwitchState(new PlayState(), true);
}

function changeWeek(direction:Int)
{
    curWeekSelected = wrapWeekIndex(curWeekSelected + direction);
    WeekData.setDirectoryFromWeek(loadedWeeks[curWeekSelected]);
    updateDifficultiesForWeek(curWeekSelected);
    diffText.text = difficulties[curDifficulty].toUpperCase();
    updateTracklist(curWeekSelected);

    var prevEntry:Dynamic = weekSlots[0];
    var curEntry:Dynamic = weekSlots[1];
    var nextEntry:Dynamic = weekSlots[2];

    if (direction < 0)
    {
        destroyWeekEntry(nextEntry, FlxG.width / 2 + weekSpacing * 2);

        moveWeekEntry(curEntry, FlxG.width / 2 + weekSpacing, false, 0.5);
        moveWeekEntry(prevEntry, FlxG.width / 2, true, 1);

        var newPrevIndex:Int = wrapWeekIndex(curWeekSelected - 1);
        var newPrevEntry:Dynamic = createWeekEntry(newPrevIndex, FlxG.width / 2 - weekSpacing * 2, false, 0.5);
        moveWeekEntry(newPrevEntry, FlxG.width / 2 - weekSpacing, false, 0.5);

        weekSlots = [newPrevEntry, prevEntry, curEntry];
    }
    else if (direction > 0)
    {
        destroyWeekEntry(prevEntry, FlxG.width / 2 - weekSpacing * 2);

        moveWeekEntry(curEntry, FlxG.width / 2 - weekSpacing, false, 0.5);
        moveWeekEntry(nextEntry, FlxG.width / 2, true, 1);

        var newNextIndex:Int = wrapWeekIndex(curWeekSelected + 1);
        var newNextEntry:Dynamic = createWeekEntry(newNextIndex, FlxG.width / 2 + weekSpacing * 2, false, 0.5);
        moveWeekEntry(newNextEntry, FlxG.width / 2 + weekSpacing, false, 0.5);

        weekSlots = [curEntry, nextEntry, newNextEntry];
    }
}

function buildWeekSlots()
{
    var prevIndex:Int = wrapWeekIndex(curWeekSelected - 1);
    var nextIndex:Int = wrapWeekIndex(curWeekSelected + 1);

    weekSlots = [
        createWeekEntry(prevIndex, FlxG.width / 2 - weekSpacing, false, 0.5),
        createWeekEntry(curWeekSelected, FlxG.width / 2, true, 1),
        createWeekEntry(nextIndex, FlxG.width / 2 + weekSpacing, false, 0.5)
    ];
}

function createWeekEntry(index:Int, x:Float, selected:Bool, alpha:Float):Dynamic
{
    var txt:FlxText = new FlxText(0, weekY, FlxG.width, WeekData.weeksList[index], 32);
    txt.setFormat(Paths.font("pah.ttf"), 76, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    txt.scrollFactor.set();
    txt.borderSize = 2;
    txt.antialiasing = ClientPrefs.globalAntialiasing;

    txt.x = x - (FlxG.width / 2);
    txt.alpha = alpha;

    weekGrp.add(txt);

    return {text: txt, index: index};
}

function moveWeekEntry(entry:Dynamic, x:Float, selected:Bool, alpha:Float)
{
    FlxTween.tween(entry.text, {x: x - (FlxG.width / 2), alpha: alpha}, weekTweenTime, {ease: FlxEase.quadOut});
}

function destroyWeekEntry(entry:Dynamic, x:Float)
{
    FlxTween.tween(entry.text, {x: x - (FlxG.width / 2), alpha: 0}, weekTweenTime, {
        ease: FlxEase.quadOut,
        onComplete: function(twn:FlxTween)
        {
            weekGrp.remove(entry.text, true);
            entry.text.destroy();
        }
    });
}

function createDiffText(y:Float):FlxText
{
    var txt:FlxText = new FlxText(0, y, FlxG.width, difficulties[curDifficulty].toUpperCase(), 76);
    txt.setFormat(Paths.font("pah.ttf"), 76, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    txt.scrollFactor.set();
    txt.borderSize = 2;
    txt.antialiasing = ClientPrefs.globalAntialiasing;
    add(txt);
    return txt;
}

function changeDifficulty(direction:Int)
{
    curDifficulty = wrapDiff(curDifficulty + direction);
    lastDifficultyName = difficulties[curDifficulty];

    var oldText:FlxText = diffText;

    FlxTween.tween(oldText, {y: oldText.y - diffTextDrop, alpha: 0}, diffTweenTime, {
        ease: FlxEase.quadOut,
        onComplete: function(twn:FlxTween)
        {
            remove(oldText);
            oldText.destroy();
        }
    });

    var newText:FlxText = createDiffText(diffTextY + diffTextDrop);
    newText.text = difficulties[curDifficulty].toUpperCase();
    newText.alpha = 0;

    FlxTween.tween(newText, {y: diffTextY, alpha: 1}, diffTweenTime, {ease: FlxEase.quadOut});

    diffText = newText;
}
