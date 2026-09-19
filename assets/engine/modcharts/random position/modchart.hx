var elapsedtime:Float = 0;
var timerOfStrums:Float = 0;
var tweenInterval:Float = 2;

function onUpdate(elapsed)
{
    elapsedtime += elapsed;
    timerOfStrums += elapsed;

    if (timerOfStrums >= tweenInterval)
    {
        game.playerStrums.forEach(function(spr:FlxSprite)
        {
            FlxTween.tween(spr, {x: FlxG.random.float(0, 1000), y: FlxG.random.float(0, 500)}, tweenInterval, {ease: FlxEase.quadInOut});
        });
        game.opponentStrums.forEach(function(spr:FlxSprite)
        {
            FlxTween.tween(spr, {x: FlxG.random.float(0, 1000), y: FlxG.random.float(0, 500)}, tweenInterval, {ease: FlxEase.quadInOut});
        });
        timerOfStrums = 0;
    }
}