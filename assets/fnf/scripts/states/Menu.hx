var storyMenu:FlxSprite;
var freeplay:FlxSprite;
var options:FlxSprite;
var boyfriend:FlxSprite;
var menuBG:FlxSprite;
var freakyMenu:FlxSound;

var menuItems:Array<FlxSprite>;
var curSelected:Int = 0;

function swipeOut(selected:FlxSprite, others:Array<FlxSprite>, bg:FlxSprite, onDone:Void->Void)
{
    FlxTween.tween(selected, {x: selected.x + FlxG.width + selected.width, alpha: 0}, 0.5, {
        ease: FlxEase.quadIn,
        onComplete: function(twn:FlxTween)
        {
            onDone();
        }
    });

    for (spr in others)
    {
        FlxTween.tween(spr, {x: spr.x - FlxG.width - spr.width, alpha: 0}, 0.5, {ease: FlxEase.quadIn});
    }

    FlxTween.tween(bg, {alpha: 0}, 0.5, {ease: FlxEase.quadIn});
}

function swipeDown(spr:FlxSprite)
{
    FlxTween.tween(spr, {y: spr.y + FlxG.height, alpha: 0}, 0.5, {ease: FlxEase.quadIn});
}

function onState()
{
    mouse.visible = true;

    DiscordClient.changePresence("Main Menu", null);

    menuBG = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    add(menuBG);

    storyMenu = new FlxSprite(0);
    storyMenu.frames = Paths.getSparrowAtlas('mainmenu/menu_story_mode');
    storyMenu.animation.addByPrefix('unselected', 'story_mode basic', 24, true);
    storyMenu.animation.addByPrefix('selected', 'story_mode white', 24, true);
    storyMenu.animation.play('unselected');
    storyMenu.antialiasing = ClientPrefs.globalAntialiasing;
    add(storyMenu);

    freeplay = new FlxSprite(0, 280);
    freeplay.frames = Paths.getSparrowAtlas('mainmenu/menu_freeplay');
    freeplay.animation.addByPrefix('unselected', 'freeplay basic', 24, true);
    freeplay.animation.addByPrefix('selected', 'freeplay white', 24, true);
    freeplay.animation.play('unselected');
    freeplay.antialiasing = ClientPrefs.globalAntialiasing;
    add(freeplay);

    options = new FlxSprite(0, 560);
    options.frames = Paths.getSparrowAtlas('mainmenu/menu_options');
    options.animation.addByPrefix('unselected', 'options basic', 24, true);
    options.animation.addByPrefix('selected', 'options white', 24, true);
    options.animation.play('unselected');
    options.antialiasing = ClientPrefs.globalAntialiasing;
    add(options);

    boyfriend = new FlxSprite(760, 150);
    boyfriend.frames = Paths.getSparrowAtlas('characters/rodentrap');
    boyfriend.animation.addByPrefix('idle', 'BF idle dance0', 24, true);
    boyfriend.animation.addByPrefix('idle-alt', 'BF idle dance ALT', 24, true);
    if (FlxG.random.int(1, 10) == 1){
        boyfriend.animation.play('idle-alt');
    }else{
        boyfriend.animation.play('idle');
    }
    boyfriend.antialiasing = ClientPrefs.globalAntialiasing;
    add(boyfriend);

    menuItems = [storyMenu, freeplay, options];

    curSelected = 0;
    updateSelection();

    freakyMenu = new FlxSound().loadEmbedded(Paths.music('stayFunky/stayFunky'));
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
    if (keys.justPressed.F5)
    {
        switchState('Menu');
    }

    if (keys.justPressed.SEVEN)
    {
        goToEditorSelect();
    }

    if (mouse.overlaps(boyfriend))
    {
        mouse.createPointer();
        if (mouse.justPressed)
        {
            FlxTween.tween(boyfriend.scale, {x: 1.1, y: 1.1}, 0.05, {
                ease: FlxEase.quadOut,
                onComplete: function(twn:FlxTween)
                {
                    FlxTween.tween(boyfriend.scale, {x: 1, y: 1}, 0.05, {ease: FlxEase.quadIn});
                }
            });
        }
    }else{
        mouse.createDefault();
    }

    if (controls.UI_UP_P)
    {
        var newSelected:Int = curSelected - 1;
        if (newSelected < 0)
        {
            newSelected = menuItems.length - 1;
        }
        setSelected(newSelected);
    }

    if (controls.UI_DOWN_P)
    {
        var newSelected:Int = curSelected + 1;
        if (newSelected >= menuItems.length)
        {
            newSelected = 0;
        }
        setSelected(newSelected);
    }

    if (controls.ACCEPT)
    {
        confirmSelection();
    }
}

function setSelected(index:Int)
{
    curSelected = index;
    updateSelection();
}

function updateSelection()
{
    for (i in 0...menuItems.length)
    {
        menuItems[i].animation.play(i == curSelected ? 'selected' : 'unselected');
    }
}

function confirmSelection()
{
    mouse.visible = false;
    FlxG.sound.play(Paths.sound('confirmMenu'));
    switch (curSelected)
    {
        case 0:
            swipeOut(storyMenu, [freeplay, options], menuBG, function()
            {
                switchState('Story');
            });
            swipeDown(boyfriend);
        case 1:
            swipeOut(freeplay, [storyMenu, options], menuBG, function()
            {
                switchState('Freeplay');
            });
            swipeDown(boyfriend);
        case 2:
            swipeOut(options, [storyMenu, freeplay], menuBG, function()
            {
                goToOptions();
            });
            swipeDown(boyfriend);
    }
}