package;

import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Thanks extends MusicBeatState 
{
    override function create(){
		trace("the original create function yeah");

		var text = new FlxText(0, 290);
		text.text = "Thank you for playing this demostration.";
		text.setFormat(Paths.font("vcr-org.ttf"), 38, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE, FlxColor.WHITE);
		text.screenCenter(X);
		add(text);

        FlxG.camera.fade(FlxColor.BLACK, 2, true, () -> {
            var text2 = new FlxText(0, 340);
            text2.text = "Press any button to exit.";
            text2.setFormat(Paths.font("vcr-org.ttf"), 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE, FlxColor.WHITE);
            text2.screenCenter(X);
            add(text2);

            text2.alpha = 0;
            FlxTween.tween(text2, {alpha: 1}, 2);
        });

        super.create();
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ANY) Sys.exit(500);
        super.update(elapsed);
    }     
}