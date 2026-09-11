var elapsedtime:Float = 0;
var timerOfStrums:Float = 240;

function onUpdate(elapsed)
{
    elapsedtime += elapsed;
    timerOfStrums += 2;
    if (timerOfStrums >= 240)
    {
        game.playerStrums.forEach(function(spr:FlxSprite)
        {
            spr.x = FlxG.random.float(0, 1000);
            spr.y = FlxG.random.float(0, 500);
        });
        game.opponentStrums.forEach(function(spr:FlxSprite)
        {
            spr.x = FlxG.random.float(0, 1000);
            spr.y = FlxG.random.float(0, 500);
        });
        timerOfStrums = 0;
    }
}