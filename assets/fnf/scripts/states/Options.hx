var prefs = [
    'Controls',
    'Note Colors',
    'Adjust Combo & Offset',
    'Visuals',
    'Gameplay',
    'Graphics',
    'Audio'
];

var categoryTexts = [];

var curCategory:Int = 0;
var inSubMenu:Bool = false;
var curSubSelected:Int = 0;

var subMenuCache = {};
var subMenuOptions = [];

var holdTime = 0.0;
var holdRepeatTimer = 0.0;
var holdRepeatRate = 0.05;
var holdThreshold = 0.5;

var colorOn = 0xFF66FF66;
var colorOff = 0xFFFF6666;
var colorIdle = 0xFFFFFFFF;

var optionFont = Paths.font("funkin.otf");
var optionSize = 48;
var startY = 120;
var spacing = 50;
var maxVisibleOptions = 10;

var onPlayState:Bool = false;

function onState(inPlayState)
{
    if (isMobile()){
        prefs.remove('Controls');
        prefs.push('Mobile');
    }

    onPlayState = inPlayState;

    if (onPlayState){
        prefs.remove('Adjust Combo & Offset');
    }
    
    DiscordClient.changePresence("Title Screen", null);

    add(new FlxSprite().loadGraphic(Paths.image('menuBGBlue')));

    playMusic('offsetsLoop/offsetsLoop');

    for (i in 0...prefs.length)
    {
        var txt = new FlxText(100, startY + (i * spacing), 600, prefs[i]);
        setTxtFormat(txt, optionFont, optionSize, colorIdle, FlxTextAlign.LEFT);
        add(txt);
        categoryTexts.push(txt);
    }

    updateCategorySelection();
}

function onUpdate(elapsed)
{
    if (inSubMenu)
    {
        updateSubMenu(elapsed);
    }
    else
    {
        if (controls.UI_UP_P) changeCategorySelection(-1);
        if (controls.UI_DOWN_P) changeCategorySelection(1);
        if (controls.ACCEPT) selectCategory();
        if (controls.BACK)
        {
            ClientPrefs.saveSettings();
            if (onPlayState){
                LoadingState.loadAndSwitchState(new PlayState());
            }else{
                switchState('Menu');
            }
        }
    }
}

function updateCategorySelection()
{
    for (i in 0...categoryTexts.length)
        categoryTexts[i].alpha = (i == curCategory) ? 1 : 0.6;
}

function changeCategorySelection(change)
{
    curCategory += change;
    if (curCategory < 0) curCategory = prefs.length - 1;
    if (curCategory >= prefs.length) curCategory = 0;
    updateCategorySelection();
}

function selectCategory()
{
    switch (prefs[curCategory])
    {
        case 'Controls':
            openControls();
        case 'Note Colors':
            openNoteColors();
        case 'Adjust Combo & Offset':
            openNoteOffset();
        case 'Mobile':
            openMobileSubstate();
        case 'Visuals':
            openSubMenu('Visuals', generateVisualsPrefs);
        case 'Gameplay':
            openSubMenu('Gameplay', generateGameplayPrefs);
        case 'Graphics':
            openSubMenu('Graphics', generateGraphicsPrefs);
        case 'Audio':
            openSubMenu('Audio', generateAudioPrefs);
    }
}

function openSubMenu(name, generatorFn)
{
    inSubMenu = true;
    curSubSelected = 0;
    holdTime = 0;
    holdRepeatTimer = 0;

    for (i in 0...categoryTexts.length)
        categoryTexts[i].visible = false;

    if (Reflect.hasField(subMenuCache, name))
    {
        subMenuOptions = Reflect.field(subMenuCache, name);
    }
    else
    {
        subMenuOptions = [];
        generatorFn();
        Reflect.setField(subMenuCache, name, subMenuOptions);
    }

    updateSubMenuSelection();
}

function closeSubMenu()
{
    ClientPrefs.saveSettings();

    inSubMenu = false;

    for (i in 0...categoryTexts.length)
        categoryTexts[i].visible = true;

    for (i in 0...subMenuOptions.length)
        subMenuOptions[i].text.visible = false;

    updateCategorySelection();
}

function generateGameplayPrefs()
{
    createOption('Controller Mode', 'bool', 'controllerMode', null, null, null, false, null);
    createOption('Downscroll', 'bool', 'downScroll', null, null, null, false, null);
    createOption('Middlescroll', 'bool', 'middleScroll', null, null, null, false, null);
    createOption('Opponent Notes', 'bool', 'opponentStrums', null, null, null, true, null);
    createOption('Ghost Tapping', 'bool', 'ghostTapping', null, null, null, true, null);
    createOption('Disable Reset Button', 'bool', 'noReset', null, null, null, false, null);
    createOption('Rating Offset', 'int', 'ratingOffset', -30, 30, null, 0, null);
    createOption('Sick! Hit Window', 'int', 'sickWindow', 15, 45, null, 45, null);
    createOption('Good Hit Window', 'int', 'goodWindow', 15, 90, null, 90, null);
    createOption('Bad Hit Window', 'int', 'badWindow', 15, 135, null, 135, null);
    createOption('Safe Frames', 'float', 'safeFrames', 2, 10, null, 10, null);
}

function generateVisualsPrefs()
{
    createOption('Note Splashes', 'bool', 'noteSplashes', null, null, null, true, null);
    createOption('Note Skin', 'string', 'noteSkin', null, null, ['Default', 'Chip', 'Future', 'Soul'], 'Default', null);
    createOption('Note Splash Skin', 'string', 'splashSkin', null, null, ['Default', 'Soul'], 'Default', null);
    createOption('Hide HUD', 'bool', 'hideHud', null, null, null, false, null);
    createOption('Time Bar', 'string', 'timeBarType', null, null, ['Time Left', 'Time Elapsed', 'Song Name', 'Disabled'], 'Time Left', null);
    createOption('Flashing Lights', 'bool', 'flashing', null, null, null, true, null);
    createOption('Camera Zooms', 'bool', 'camZooms', null, null, null, true, null);
    createOption('Score Text Zoom on Hit', 'bool', 'scoreZoom', null, null, null, true, null);
    createOption('Health Bar Transparency', 'percent', 'healthBarAlpha', 0, 1, null, 1, null);
    createOption('FPS Counter', 'bool', 'showFPS', null, null, null, true, function() {
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	});
    createOption('Pause Screen Song', 'string', 'pauseMusic', null, null, ['None', 'Breakfast', 'Tea Time'], 'Tea Time', null);
    createOption('Combo Stacking', 'bool', 'comboStacking', null, null, null, true, null);
}

function generateGraphicsPrefs()
{
    createOption('Low Quality', 'bool', 'lowQuality', null, null, null, false, null);
    createOption('Anti-Aliasing', 'bool', 'globalAntialiasing', null, null, null, true, null);
    createOption('Shaders', 'bool', 'shaders', null, null, null, true, null);
    createOption('Framerate', 'int', 'framerate', 60, 240, null, 60, function() {
        if (ClientPrefs.framerate > FlxG.drawFramerate)
        {
            FlxG.updateFramerate = ClientPrefs.framerate;
            FlxG.drawFramerate = ClientPrefs.framerate;
        }
        else
        {
            FlxG.drawFramerate = ClientPrefs.framerate;
            FlxG.updateFramerate = ClientPrefs.framerate;
        }
    });
}

function generateAudioPrefs()
{
    createOption('Hitsound Volume', 'percent', 'hitsoundVolume', 0, 1, null, 0, function() {
        FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
    });

    createOption('MissSound Volume', 'percent', 'missSoundVolume', 0, 1, null, 0.3, function() {
        FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), ClientPrefs.missSoundVolume);
    });

    createOption('Vocals Volume', 'percent', 'vocalsVolume', 0, 1, null, 1, null);
}

function createOption(name, optKind, optionVar, minVal, maxVal, choices, defaultVal, onChangeFn)
{
    var index = subMenuOptions.length;
    var txt = new FlxText(100, startY + (index * spacing), 900, '');
    add(txt);

    var opt = {
        name: name,
        kind: optKind,
        variable: optionVar,
        minVal: minVal,
        maxVal: maxVal,
        choices: choices,
        defaultVal: defaultVal,
        onChangeFn: onChangeFn,
        text: txt
    };

    subMenuOptions.push(opt);
    refreshOptionVisual(opt);
    return opt;
}

function getOptionValue(variable)
{
    return Reflect.getProperty(ClientPrefs, variable);
}

function setOptionValue(variable, value)
{
    Reflect.setProperty(ClientPrefs, variable, value);
}

function refreshOptionVisual(opt)
{
    var value = getOptionValue(opt.variable);

    if (opt.kind == 'bool')
    {
        opt.text.text = opt.name + ':  ' + (value ? 'ON' : 'OFF');
        setTxtFormat(opt.text, optionFont, optionSize, value ? colorOn : colorOff, FlxTextAlign.LEFT);
    }
    else if (opt.kind == 'percent')
    {
        opt.text.text = opt.name + ':  ' + Math.round(value * 100) + '%';
        setTxtFormat(opt.text, optionFont, optionSize, colorIdle, FlxTextAlign.LEFT);
    }
    else if (opt.kind == 'float')
    {
        opt.text.text = opt.name + ':  ' + (Math.round(value * 100) / 100);
        setTxtFormat(opt.text, optionFont, optionSize, colorIdle, FlxTextAlign.LEFT);
    }
    else
    {
        opt.text.text = opt.name + ':  ' + value;
        setTxtFormat(opt.text, optionFont, optionSize, colorIdle, FlxTextAlign.LEFT);
    }
}

function updateSubMenuSelection()
{
    var scrollOffset = curSubSelected - Math.floor(maxVisibleOptions / 2);
    if (scrollOffset < 0) scrollOffset = 0;

    var maxOffset = subMenuOptions.length - maxVisibleOptions;
    if (maxOffset < 0) maxOffset = 0;
    if (scrollOffset > maxOffset) scrollOffset = maxOffset;

    for (i in 0...subMenuOptions.length)
    {
        var opt = subMenuOptions[i];
        var visible = (i >= scrollOffset && i < scrollOffset + maxVisibleOptions);

        opt.text.visible = visible;
        opt.text.alpha = (i == curSubSelected) ? 1 : 0.6;

        if (visible)
            opt.text.y = startY + ((i - scrollOffset) * spacing);
    }
}

function changeSubMenuSelection(change)
{
    curSubSelected += change;
    if (curSubSelected < 0) curSubSelected = subMenuOptions.length - 1;
    if (curSubSelected >= subMenuOptions.length) curSubSelected = 0;
    holdTime = 0;
    holdRepeatTimer = 0;
    updateSubMenuSelection();
}

function toggleOrChangeOption(opt, direction)
{
    var value = getOptionValue(opt.variable);

    if (opt.kind == 'bool')
    {
        setOptionValue(opt.variable, !value);
    }
    else if (opt.kind == 'string')
    {
        var idx = opt.choices.indexOf(value);
        idx += direction;
        if (idx < 0) idx = opt.choices.length - 1;
        if (idx >= opt.choices.length) idx = 0;
        setOptionValue(opt.variable, opt.choices[idx]);
    }
    else if (opt.kind == 'int' || opt.kind == 'float' || opt.kind == 'percent')
    {
        var change = 1;
        if (opt.kind == 'percent') change = 0.01;
        if (opt.kind == 'float') change = 0.05;

        var newValue = value + (change * direction);

        if (opt.kind == 'float') newValue = Math.round(newValue * 100) / 100;

        if (opt.minVal != null && newValue < opt.minVal) newValue = opt.minVal;
        if (opt.maxVal != null && newValue > opt.maxVal) newValue = opt.maxVal;

        setOptionValue(opt.variable, newValue);
    }

    refreshOptionVisual(opt);

    if (opt.onChangeFn != null)
        opt.onChangeFn();
}

function resetOption(opt)
{
    setOptionValue(opt.variable, opt.defaultVal);
    refreshOptionVisual(opt);

    if (opt.onChangeFn != null)
        opt.onChangeFn();
}

function resetAllOptions()
{
    for (i in 0...subMenuOptions.length)
        resetOption(subMenuOptions[i]);
}

function updateSubMenu(elapsed)
{
    var curOpt = subMenuOptions[curSubSelected];

    if (controls.UI_UP_P) changeSubMenuSelection(-1);
    if (controls.UI_DOWN_P) changeSubMenuSelection(1);

    if (curOpt.kind == 'bool')
    {
        if (controls.ACCEPT) toggleOrChangeOption(curOpt, 1);
    }
    else if (curOpt.kind == 'string')
    {
        if (controls.UI_LEFT_P) toggleOrChangeOption(curOpt, -1);
        if (controls.UI_RIGHT_P) toggleOrChangeOption(curOpt, 1);
    }
    else
    {
        if (controls.UI_LEFT_P) toggleOrChangeOption(curOpt, -1);
        if (controls.UI_RIGHT_P) toggleOrChangeOption(curOpt, 1);

        if (controls.UI_LEFT || controls.UI_RIGHT)
        {
            holdTime += elapsed;

            if (holdTime >= holdThreshold)
            {
                holdRepeatTimer += elapsed;

                if (holdRepeatTimer >= holdRepeatRate)
                {
                    holdRepeatTimer = 0;
                    toggleOrChangeOption(curOpt, controls.UI_LEFT ? -1 : 1);
                }
            }
        }
        else
        {
            holdTime = 0;
            holdRepeatTimer = 0;
        }
    }

    if (controls.RESET)
    {
        if (keys.pressed.SHIFT)
            resetAllOptions();
        else
            resetOption(curOpt);
    }

    if (controls.BACK) closeSubMenu();
}
