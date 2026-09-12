var songs:Array<String> = [];
var songFolders:Array<String> = [];
var songWeeks:Array<WeekData> = [];
var songWeekIndices:Array<Int> = [];

var curSelected:Int = 0;
var curDiff:Int = -1;
var difficulties:Array<String> = [];
var lastDifficultyName:String = '';

var capsuleSpacing:Float = 450;
var capsuleTweenTime:Float = 0.2;

var diffTweenTime:Float = 0.2;
var diffTextY:Float = 0;
var diffTextDrop:Float = 60;
var diffHintOffset:Float = 200;

var pico:FlxSprite;
var boyfriend:FlxSprite;
var capsuleGrp:FlxSpriteGroup;
var freakyMenu:FlxSound;
var freeplayBG:FlxSprite;

var selectorSongBf:FlxSprite;
var selectorSongPico:FlxSprite;

var selectorDiffBf:FlxSprite;
var selectorDiffPico:FlxSprite;

var capsuleY:Float = 0;

var capsuleSlots:Array<Dynamic> = [];

var diffText:FlxText;

var loadingSong:Bool = false;
var loadDelayTime:Float = 1;
var loadFadeTime:Float = 0.5;
var pendingSong:String;
var pendingDiff:Int;

function onState()
{
    mouse.visible = false;

    PlayState.isStoryMode = false;

    WeekData.reloadWeekFiles(false);

    DiscordClient.changePresence("Freeplay Menu", null);

	for (i in 0...WeekData.weeksList.length) {
		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
		WeekData.setDirectoryFromWeek(leWeek);
		for (song in leWeek.songs)
		{
            songs.push(song[0]);
            songFolders.push(Paths.currentModDirectory);
            songWeeks.push(leWeek);
            songWeekIndices.push(i);
		}
	}
	WeekData.loadTheFirstEnabledMod();

    freeplayBG = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
    add(freeplayBG);

    WeekData.setDirectoryFromWeek();

    pico = new FlxSprite(970, 320);
    pico.frames = Paths.getSparrowAtlas('freeplay/pico');
    pico.animation.addByPrefix('idle', 'idle', 24, true);
    pico.animation.addByPrefix('selected', 'selected', 24, false);
    pico.animation.play('idle');
    pico.flipX = true;
    pico.scale.set(1.25, 1.25);
    pico.antialiasing = ClientPrefs.globalAntialiasing;
    add(pico);

    boyfriend = new FlxSprite(0, 320);
    boyfriend.frames = Paths.getSparrowAtlas('freeplay/bf');
    boyfriend.animation.addByPrefix('idle', 'idle', 24, true);
    boyfriend.animation.addByPrefix('selected', 'selected', 24, false);
    boyfriend.animation.play('idle');
    boyfriend.flipX = true;
    boyfriend.scale.set(1.25, 1.25);
    boyfriend.antialiasing = ClientPrefs.globalAntialiasing;
    add(boyfriend);

    if (lastDifficultyName == '')
    {
        lastDifficultyName = CoolUtil.defaultDifficulty;
    }

    capsuleGrp = new FlxSpriteGroup();
    add(capsuleGrp);

    curSelected = 0;

    if (songs.length > 0)
    {
        updateDifficultiesForSong(curSelected);
        buildCapsules();
    }

    diffTextY = capsuleY + diffHintOffset;
    diffText = createDiffText(diffTextY);

    selectorSongBf = new FlxSprite(370, capsuleY + 25);
    selectorSongBf.frames = Paths.getSparrowAtlas('freeplay/freeplaySelector');
    selectorSongBf.animation.addByPrefix('idle', 'arrow pointer loop', 24, true);
    selectorSongBf.animation.play('idle');
    selectorSongBf.antialiasing = ClientPrefs.globalAntialiasing;
    add(selectorSongBf);

    selectorSongPico = new FlxSprite(870, capsuleY + 25);
    selectorSongPico.frames = Paths.getSparrowAtlas('freeplay/freeplaySelector_pico');
    selectorSongPico.animation.addByPrefix('idle', 'arrow pointer loop', 24, true);
    selectorSongPico.animation.play('idle');
    selectorSongPico.antialiasing = ClientPrefs.globalAntialiasing;
    selectorSongPico.flipX = true;
    add(selectorSongPico);

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

    freakyMenu = new FlxSound().loadEmbedded(Paths.music('freeplayRandom/freeplayRandom'));
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
    if (loadingSong)
    {
        return;
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

    if (songs.length > 0)
    {
        if (controls.UI_RIGHT_P)
        {
            changeSong(1);
        }
        if (controls.UI_LEFT_P)
        {
            changeSong(-1);
        }

        if (controls.ACCEPT)
        {
            confirmSong();
        }
    }
}

function wrapIndex(i:Int):Int
{
    if (i < 0)
    {
        return songs.length - 1;
    }
    if (i >= songs.length)
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

function updateDifficultiesForSong(index:Int)
{
    Paths.currentModDirectory = songFolders[index];
    PlayState.storyWeek = songWeekIndices[index];

    var leWeek:WeekData = songWeeks[index];

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
        curDiff = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
    }
    else
    {
        curDiff = 0;
    }

    var newPos:Int = difficulties.indexOf(lastDifficultyName);
    if (newPos > -1)
    {
        curDiff = newPos;
    }

    curDiff = wrapDiff(curDiff);
}

function confirmSong()
{
    if (loadingSong)
    {
        return;
    }
    loadingSong = true;

    FlxG.sound.play(Paths.sound('confirmMenu'));

    pendingSong = songs[curSelected];
    pendingDiff = curDiff;

    boyfriend.animation.play('selected');
    pico.animation.play('selected');

    new FlxTimer().start(loadDelayTime, function(tmr:FlxTimer)
    {
        fadeOutEverything();
    });
}

function fadeOutEverything()
{
    FlxTween.tween(freeplayBG, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(pico, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(selectorSongBf, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(selectorSongPico, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(selectorDiffBf, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(selectorDiffPico, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    FlxTween.tween(diffText, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});

    for (member in capsuleGrp.members)
    {
        FlxTween.tween(member, {alpha: 0}, loadFadeTime, {ease: FlxEase.quadOut});
    }

    FlxTween.tween(boyfriend, {alpha: 0}, loadFadeTime, {
        ease: FlxEase.quadOut,
        onComplete: function(twn:FlxTween)
        {
            loadDaSong(pendingSong, pendingDiff);
        }
    });
}

function loadDaSong(song:String, difficulty:Int)
{
    this.persistentUpdate = false;
    var songLowercase:String = Paths.formatToSongPath(song);
	var poop:String = Highscore.formatSong(songLowercase, difficulty);
	trace(poop);
    PlayState.isStoryMode = false;
	PlayState.storyDifficulty = difficulty;
	PlayState.SONG = Song.loadFromJson(poop, songLowercase);

	trace('CURRENT WEEK: ' + WeekData.getWeekFileName());

	LoadingState.loadAndSwitchState(new PlayState());
}

function changeSong(direction:Int)
{
    curSelected = wrapIndex(curSelected + direction);

    updateDifficultiesForSong(curSelected);
    saveData.curDiffFreeplay = curDiff;
    diffText.text = difficulties[curDiff].toUpperCase();

    var prevEntry:Dynamic = capsuleSlots[0];
    var curEntry:Dynamic = capsuleSlots[1];
    var nextEntry:Dynamic = capsuleSlots[2];

    if (direction < 0)
    {
        destroyCapsuleEntry(nextEntry, 330 + capsuleSpacing * 2, capsuleY + 75);

        moveCapsuleEntry(curEntry, 330 + capsuleSpacing, capsuleY + 75, false, 0.5);
        moveCapsuleEntry(prevEntry, 330, capsuleY, true, 1);

        var newPrevIndex:Int = wrapIndex(curSelected - 1);
        var newPrevEntry:Dynamic = createCapsuleEntry(newPrevIndex, 330 - capsuleSpacing * 2, capsuleY + 75, false, 0.5);
        moveCapsuleEntry(newPrevEntry, 330 - capsuleSpacing, capsuleY + 75, false, 0.5);

        capsuleSlots = [newPrevEntry, prevEntry, curEntry];
    }
    else if (direction > 0)
    {
        destroyCapsuleEntry(prevEntry, 330 - capsuleSpacing * 2, capsuleY + 75);

        moveCapsuleEntry(curEntry, 330 - capsuleSpacing, capsuleY + 75, false, 0.5);
        moveCapsuleEntry(nextEntry, 330, capsuleY, true, 1);

        var newNextIndex:Int = wrapIndex(curSelected + 1);
        var newNextEntry:Dynamic = createCapsuleEntry(newNextIndex, 330 + capsuleSpacing * 2, capsuleY + 75, false, 0.5);
        moveCapsuleEntry(newNextEntry, 330 + capsuleSpacing, capsuleY + 75, false, 0.5);

        capsuleSlots = [curEntry, nextEntry, newNextEntry];
    }
}

function buildCapsules()
{
    var prevIndex:Int = wrapIndex(curSelected - 1);
    var nextIndex:Int = wrapIndex(curSelected + 1);

    capsuleSlots = [
        createCapsuleEntry(prevIndex, 330 - capsuleSpacing, capsuleY + 75, false, 0.5),
        createCapsuleEntry(curSelected, 330, capsuleY, true, 1),
        createCapsuleEntry(nextIndex, 330 + capsuleSpacing, capsuleY + 75, false, 0.5)
    ];
}

function createCapsuleEntry(index:Int, x:Float, y:Float, selected:Bool, alpha:Float):Dynamic
{
    var capsule:FlxSprite = new FlxSprite(x, y);
    capsule.frames = Paths.getSparrowAtlas('freeplay/freeplayCapsule');
    capsule.animation.addByPrefix('unselected', 'mp3 capsule w backing NOT SELECTED', 24, true);
    capsule.animation.addByPrefix('selected', 'mp3 capsule w backing0', 24, true);
    capsule.animation.play(selected ? 'selected' : 'unselected');
    capsule.antialiasing = ClientPrefs.globalAntialiasing;
    capsule.scale.set(0.75, 0.75);
    capsule.alpha = alpha;
    capsuleGrp.add(capsule);

    var songName:FlxText = new FlxText(x + 170, y + 44, 0, songs[index], 20);
    songName.setFormat(Paths.font("5by7.ttf"), 36, FlxColor.WHITE, FlxHorizontalAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    songName.scrollFactor.set();
    songName.borderSize = 2;
    songName.antialiasing = ClientPrefs.globalAntialiasing;
    songName.alpha = alpha;
    capsuleGrp.add(songName);

    return {capsule: capsule, text: songName, index: index};
}

function moveCapsuleEntry(entry:Dynamic, x:Float, y:Float, selected:Bool, alpha:Float)
{
    entry.capsule.animation.play(selected ? 'selected' : 'unselected');

    FlxTween.tween(entry.capsule, {x: x, y: y, alpha: alpha}, capsuleTweenTime, {ease: FlxEase.quadOut});
    FlxTween.tween(entry.text, {x: x + 170, y: y + 44, alpha: alpha}, capsuleTweenTime, {ease: FlxEase.quadOut});
}

function destroyCapsuleEntry(entry:Dynamic, x:Float, y:Float)
{
    FlxTween.tween(entry.capsule, {x: x, y: y, alpha: 0}, capsuleTweenTime, {
        ease: FlxEase.quadOut,
        onComplete: function(twn:FlxTween)
        {
            capsuleGrp.remove(entry.capsule, true);
            entry.capsule.destroy();
        }
    });
    FlxTween.tween(entry.text, {x: x + 170, y: y + 44, alpha: 0}, capsuleTweenTime, {
        ease: FlxEase.quadOut,
        onComplete: function(twn:FlxTween)
        {
            capsuleGrp.remove(entry.text, true);
            entry.text.destroy();
        }
    });
}

function createDiffText(y:Float):FlxText
{
    var txt:FlxText = new FlxText(0, y, FlxG.width, difficulties[curDiff].toUpperCase(), 76);
    txt.setFormat(Paths.font("pah.ttf"), 76, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    txt.scrollFactor.set();
    txt.borderSize = 2;
    txt.antialiasing = ClientPrefs.globalAntialiasing;
    add(txt);
    return txt;
}

function changeDifficulty(direction:Int)
{
    curDiff = wrapDiff(curDiff + direction);
    lastDifficultyName = difficulties[curDiff];

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
    newText.text = difficulties[curDiff].toUpperCase();
    newText.alpha = 0;

    FlxTween.tween(newText, {y: diffTextY, alpha: 1}, diffTweenTime, {ease: FlxEase.quadOut});

    diffText = newText;
}