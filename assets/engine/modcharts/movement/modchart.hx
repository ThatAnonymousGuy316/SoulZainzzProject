var elapsedtime:Float = 0;
var fastMove:Float = 1.75;

function onUpdate(elapsed)
{
    elapsedtime += elapsed;
    if (!game.inCutscene)
    {
        game.playerStrums.forEach(function(spr:FlxSprite)
		{
            spr.x += Math.sin(elapsedtime) * 3 * fastMove;
            spr.x -= Math.sin(elapsedtime) * 6 * fastMove;
        });
        game.opponentStrums.forEach(function(spr:FlxSprite)
        {
            spr.x -= Math.sin(elapsedtime) * 3 * fastMove;
            spr.x += Math.sin(elapsedtime) * 6 * fastMove;
        });
    }
}