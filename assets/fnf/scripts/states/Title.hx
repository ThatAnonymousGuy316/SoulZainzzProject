var logo:FlxSprite;
var icon:FlxSprite;

var logoScale:Float = 0.75;

var floatshit:Float = 0;

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

    playMusic('freakyMenu');

    addDPad();
}

function onUpdate(elapsed)
{
    floatshit += 0.1;
    plusYSprite(logo, Math.sin(floatshit));
    switchFromTitleonMobile(); // DONT MESS WITH THIS :/
    if (controls.ACCEPT){
        switchState('Menu');
    }
}