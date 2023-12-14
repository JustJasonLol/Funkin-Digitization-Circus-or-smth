package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.*;
import flixel.tweens.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import shaders.ColorSwap;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;
import openfl.events.MouseEvent;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

using StringTools;
#if discord_rpc
import Discord.DiscordClient;
#end
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class CircusState extends MusicBeatState
{
    public static var initialized:Bool = false;
    static var logoBl:FlxSprite;

    public static var menuOptions:FlxTypedGroup<FlxText>;
    static var options:Array<String> = 
    [
        'Play',
        'Options',
        'Quit'
    ];

    static var loaded = false;

    static public function load()
    {
        logoBl = new FlxSprite(0, 10).loadGraphic(Paths.image('circus'));
        logoBl.setGraphicSize(0,360);
		logoBl.scrollFactor.set();
        logoBl.updateHitbox();
		logoBl.screenCenter(X);
        MusicBeatState.playMenuMusic(0);
        loaded = true;

        menuOptions = new FlxTypedGroup<FlxText>();

        for(i in 0...options.length)
        {
            var opt:FlxText = new FlxText(0, 450 + 75*i, 0, options[i]);
            opt.setFormat(Paths.font("calibrib.ttf"), 60, Main.outOfDate?FlxColor.RED:FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            opt.screenCenter(X);
            opt.ID = i;
            menuOptions.add(opt);
        }
    }

    // FlxG.mouse.justPressed
    // Paths.font("calibrib.ttf")

    override public function destroy()
    {
        loaded = false;
    
        return super.destroy();
    }

    override public function create():Void
    {
        if (!loaded) load();
        FlxTransitionableState.defaultTransIn = FadeTransitionSubstate;
		FlxTransitionableState.defaultTransOut = FadeTransitionSubstate;

		persistentUpdate = true;

		super.create();

        add(logoBl);
        add(menuOptions);

        initialized = true;
        // MusicBeatState.playMenuMusic(0, true);
        MusicBeatState.playMenuMusic(1, true);

    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

}