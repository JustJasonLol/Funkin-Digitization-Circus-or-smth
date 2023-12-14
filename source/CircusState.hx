package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.*;
import flixel.tweens.*;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
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
    public var selectedID:Int = 0;

    static var loaded = false;
    var hasSelected = false;

    public static var goToOptions:Bool = false;

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

    override public function destroy()
    {
        loaded = false;

        logoBl = null;
        menuOptions.clear();
        menuOptions = null;
        #if mobile
		FlxG.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		#end
		FlxG.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

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
        FlxG.mouse.visible = true;
        if(!initialized)
        {
            initialized = true;
            MusicBeatState.playMenuMusic(1, true);
        }
        // MusicBeatState.playMenuMusic(0, true);

        #if mobile
		FlxG.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		#end
		FlxG.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

        goToOptions = false;
    }

    var scale = 1.2;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        menuOptions.forEach(function(txt:FlxText){
            txt.screenCenter(X);

            if(!hasSelected)
            {
                if (FlxG.mouse.overlaps(txt))
                {
                    txt.scale.x = FlxMath.lerp(txt.scale.x, scale, CoolUtil.boundTo(elapsed * 5.4, 0, 1));
                    txt.scale.y = FlxMath.lerp(txt.scale.y, scale, CoolUtil.boundTo(elapsed * 5.4, 0, 1));
                }
                else
                {
                    txt.scale.x = FlxMath.lerp(txt.scale.x, 1, CoolUtil.boundTo(elapsed * 5.4, 0, 1));
                    txt.scale.y = FlxMath.lerp(txt.scale.y, 1, CoolUtil.boundTo(elapsed * 5.4, 0, 1));
                }
            }
                
        });

        if(hasSelected)
        {
            menuOptions.members[selectedID].scale.x = FlxMath.lerp(menuOptions.members[selectedID].scale.x, scale, CoolUtil.boundTo(elapsed * 5.4, 0, 1));
            menuOptions.members[selectedID].scale.y = FlxMath.lerp(menuOptions.members[selectedID].scale.y, scale, CoolUtil.boundTo(elapsed * 5.4, 0, 1));
        }
    }

    function goTo(id:Int)
    {
        hasSelected = true;
        var daChoice = options[id];
        selectedID = id;

        if (daChoice == "Quit")
            Sys.exit(0);
            
        menuOptions.forEach(function(spr:FlxText)
		{
            if (id != spr.ID)
			{
				FlxTween.tween(spr, {alpha: 0}, 0.4, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						spr.kill();
					}
				});
			}
            else
            {
                FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
                if(ClientPrefs.flashing){
                    FlxG.camera.flash(FlxColor.WHITE, 0.5);
					FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
					    menuOptions.forEach(function(spr:FlxText)
					    {
						    switch (daChoice)
						    {
                                case 'Play':
                                    MusicBeatState.switchState(new MainMenuState());
                                case 'Options':
                                    goToOptions = true;
                                    LoadingState.loadAndSwitchState(new options.OptionsState());
                            }
                         });
                    });
                }
                else
                {
                    new FlxTimer().start(1, function(_) {
                        menuOptions.forEach(function(spr:FlxText)
					    {
						    switch (daChoice)
						    {
                                case 'Play':
                                    MusicBeatState.switchState(new MainMenuState());
                                case 'Options':
                                    goToOptions = true;
                                    LoadingState.loadAndSwitchState(new options.OptionsState());
                            }
                        });
                    });
                }
            }
        });
    }

    // Mouse functions

    #if mobile
	var mouseHolding:Bool = false;
	var mouseHoldStartX:Float;
	var mouseSwipe:Float = 0;

	function onMouseDown(e)
	{
		mouseHolding = true;
		mouseHoldStartX = FlxG.mouse.x;
	}

	#else
	function updateMouseIcon()
	{
		for (spr in menuOptions){
			if (FlxG.mouse.overlaps(spr))
			{
				Mouse.cursor = MouseCursor.BUTTON;
				return;
			}
		}

		Mouse.cursor = MouseCursor.AUTO;
	}
	#end

	function onMouseMove(e)
	{
		#if mobile
		if (mouseHolding && !hasSelected)
			mouseSwipe = (mouseHoldStartX - FlxG.mouse.x) / FlxG.width;
		else
			mouseSwipe = 0;
		
		#else

		updateMouseIcon();
		#end
	}

    function onMouseUp(e)
    {
        #if mobile
		    mouseHolding = false;
		    mouseSwipe = 0;
		#end

        if(menuOptions != null && menuOptions.members.length > 0)
		for (txt in menuOptions){
			if (FlxG.mouse.overlaps(txt) && !hasSelected)
                goTo(txt.ID);
				// trace(txt.ID);
		}
    }

}