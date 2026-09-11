var elapsedtime:Float = 0;

function onUpdate(elapsed)
{
    elapsedtime += elapsed;
    {
        game.playerStrums.forEach(function(spr:FlxSprite)
        {
            spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin(elapsedtime + (spr.ID)) * 300);
            spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(elapsedtime + (spr.ID)) * 300);
        });
        game.opponentStrums.forEach(function(spr:FlxSprite)
        {
            spr.x = ((FlxG.width / 2) - (spr.width / 2)) + (Math.sin((elapsedtime + (spr.ID )) * 2) * 300);
            spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID)) * 2) * 300);
        });
    }
}