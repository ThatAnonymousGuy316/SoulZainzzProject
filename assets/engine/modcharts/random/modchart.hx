var elapsedtime:Float = 0;
var fastMove:Float = 3;

function onUpdate(elapsed)
{
    elapsedtime += elapsed;
    if (!game.inCutscene)
    {
        game.playerStrums.forEach(function(spr:FlxSprite)
		{
            spr.x += Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1) * fastMove;
            spr.x -= Math.sin(elapsedtime) * 1.5 * fastMove;
            spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos(elapsedtime + (spr.ID)) * 300);
        });
        game.opponentStrums.forEach(function(spr:FlxSprite)
        {
            spr.x -= Math.sin(elapsedtime) * ((spr.ID % 2) == 0 ? 1 : -1) * fastMove;
            spr.x += Math.sin(elapsedtime) * 1.5 * fastMove;
            spr.y = ((FlxG.height / 2) - (spr.height / 2)) + (Math.cos((elapsedtime + (spr.ID)) * 2) * 300);
        });
    }
}