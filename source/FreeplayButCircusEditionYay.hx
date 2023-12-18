package;

#if discord_rpc
import Discord.DiscordClient;
#end
import flixel.tweens.FlxTween;
import flixel.effects.FlxFlicker;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

class FreeplayButCircusEditionYay extends MusicBeatState 
{
    var background:FlxSprite;
    var bars:FlxSprite;

    var songArray:Array<Array<String>> = [['Welcome', 'caine'], ['Buffon', 'caine']];
    var textGroup:FlxTypedGroup<FlxText>;
    var iconGroup:FlxTypedGroup<HealthIcon>;
    var score:FlxText;
    var composers:FlxText;
    var scoreInt:Int = 0;

    var curSelected = 0;

    // default and the current selected
    var forcedPos = [40, 125];
    var forcedIconPos = [270, 380];
    var forcedScale = [1, 1.35];

    override function create() {
        #if discord_rpc
        DiscordClient.changePresence('In the Freeplay Menu', null);
        #end

        background = new FlxSprite(0, 0).loadGraphic(Paths.image('title/bg'));
        background.scale.set(.5, .5);
		background.updateHitbox();
		background.screenCenter();
        add(background);

        bars = new FlxSprite(0, 0).loadGraphic(Paths.image('title/bars'));
        bars.scale.set(.5, .5);
		bars.updateHitbox();
		bars.screenCenter();
        add(bars);

        add(textGroup = new FlxTypedGroup<FlxText>());
        add(iconGroup = new FlxTypedGroup<HealthIcon>());

        for (i in 0...songArray.length)
        {
            var song = new FlxText(40, 290 + 90 * i, 0, songArray[i][0]);
            song.setFormat(Paths.font('calibrib.ttf'), 65, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            song.borderSize += .3;

            var icon = new HealthIcon(songArray[i][1]);
            icon.setPosition(forcedIconPos[0], 270 + 90 * i);

            textGroup.add(song);
            iconGroup.add(icon);
        }

        score = new FlxText(FlxG.width * .3, 290, FlxG.width, 'High score:\n', 70).setFormat(Paths.font('calibrib.ttf'), 70, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        score.borderSize += .35;
        add(score);

        composers = new FlxText(0, FlxG.height * .8, FlxG.width).setFormat(Paths.font('calibrib.ttf'), 30, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
        composers.borderSize += .35;
        composers.screenCenter(X);
        add(composers);

        FlxTween.tween(composers, {alpha: 0}, 1, {type: 4});

        super.create();

        change(0);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        for (i in 0...textGroup.length)
        {
            textGroup.members[i].x = FlxMath.lerp(forcedPos[0], textGroup.members[i].x, CoolUtil.boundTo(1 - (elapsed * 6), 0, 1));
            textGroup.members[curSelected].x = FlxMath.lerp(forcedPos[1], textGroup.members[curSelected].x, CoolUtil.boundTo(1 - (elapsed * 6), 0, 1));

            iconGroup.members[i].x = FlxMath.lerp(textGroup.members[i].x + textGroup.members[i].width + 10, iconGroup.members[i].x, CoolUtil.boundTo(1 - (elapsed * 6), 0, 1));
            iconGroup.members[curSelected].x = FlxMath.lerp(textGroup.members[curSelected].x + textGroup.members[curSelected].width + 10, iconGroup.members[curSelected].x, CoolUtil.boundTo(1 - (elapsed * 6), 0, 1));

            iconGroup.members[i].scale.x = FlxMath.lerp(forcedScale[0], iconGroup.members[i].scale.x, CoolUtil.boundTo(1 - (elapsed * 12), 0, 1));
            iconGroup.members[curSelected].scale.x = FlxMath.lerp(forcedScale[1], iconGroup.members[curSelected].scale.x, CoolUtil.boundTo(1 - (elapsed * 12), 0, 1));

            iconGroup.members[i].scale.y = FlxMath.lerp(forcedScale[0], iconGroup.members[i].scale.y, CoolUtil.boundTo(1 - (elapsed * 12), 0, 1));
            iconGroup.members[curSelected].scale.y = FlxMath.lerp(forcedScale[1], iconGroup.members[curSelected].scale.y, CoolUtil.boundTo(1 - (elapsed * 12), 0, 1));
        }

        if (controls.UI_DOWN_P) change(1);
        else if (controls.UI_UP_P) change(-1);

        if (controls.ACCEPT)
        {
            for (objects in [textGroup.members[curSelected], iconGroup.members[curSelected]])
                FlxFlicker.flicker(objects, 0, .1);

            PlayState.SONG = Song.loadFromJson(songArray[curSelected][0].toLowerCase(), songArray[curSelected][0].toLowerCase());
            PlayState.campaignScore = 0;
            PlayState.campaignMisses = 0;

            FlxG.sound.play(Paths.music('gameOverEnd'), .7);
            FlxG.sound.music.fadeOut(.6);
            FlxG.camera.fade();
            @:privateAccess
                FlxG.camera._fxFadeComplete = () -> {
                    LoadingState.loadAndSwitchState(new PlayState());
                };
        }

        if (controls.BACK)
            MusicBeatState.switchState(new CircusState());
    }

    function change(hmm = 0)
    {
        curSelected += hmm;
        FlxG.sound.play(Paths.sound('scrollMenu'), .4);

        if (curSelected >= songArray.length) curSelected = 0;
        else if (curSelected < 0) curSelected = songArray.length - 1;

        scoreInt = Highscore.getScore(curSelected == 0 ? 'Welcome' : 'Buffon');

        score.text = 'High score:\n$scoreInt';

        composers.text = curSelected == 0 ? 'Composed by Majavi' : 'Composed by Kylevi & Sic';

        #if discord_rpc
        DiscordClient.changePresence('In the Freeplay Menu', 'Selecting ${curSelected == 0 ? 'Welcome by Majavi' : 'Buffon by Kylevi & Sic'}');
        #end
    }
}