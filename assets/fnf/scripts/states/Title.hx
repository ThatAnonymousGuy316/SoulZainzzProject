var logo:FlxSprite;
var icon:FlxSprite;

var logoScale:Float = 0.75;

var floatshit:Float = 0;

var freakyMenu:FlxSound;

function onState()
{   
    mouse.visible = false;

    DiscordClient.changePresence("Title Screen", null);

    add(new FlxSprite().loadGraphic(Paths.image('menuBG')));

    logo = new FlxSprite().loadGraphic(Paths.image('SoulZainzzLogo'));
    logo.screenCenter(FlxAxes.XY);
    logo.antialiasing = ClientPrefs.globalAntialiasing;
    logo.scale.set(logoScale, logoScale);
    add(logo);

    freakyMenu = new FlxSound().loadEmbedded(Paths.music('freakyMenu'));
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
    floatshit += 0.1;
    logo.y += Math.sin(floatshit);
    if (controls.ACCEPT){
        switchState('Menu');
    }
}