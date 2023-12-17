package;

import openfl.events.MouseEvent;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
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
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;
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

    static var blackScreen:FlxSprite;
    static var textGroup:FlxTypedGroup<Alphabet>;
    static var impStudios:FlxSprite;
    static var glitchProd:FlxSprite;

    var camZoom:FlxTween;
    
    public static var menuOptions:FlxTypedSpriteGroup<FlxText>;
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
        logoBl = new FlxSprite(0, 0).loadGraphic(Paths.image('circus'));
        logoBl.setGraphicSize(0,360);
		logoBl.scrollFactor.set();
        logoBl.updateHitbox();
		logoBl.screenCenter(X);
        logoBl.y = -logoBl.height;

        // if(FlxG.sound.music == null)
            MusicBeatState.playMenuMusic(0);

        loaded = true;

        menuOptions = new FlxTypedSpriteGroup<FlxText>(0,FlxG.height);

        for(i in 0...options.length)
        {
            var opt:FlxText = new FlxText(0, 450 + 75*i, 0, options[i]);
            opt.setFormat(Paths.font("calibrib.ttf"), 60, Main.outOfDate?FlxColor.RED:FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
            opt.screenCenter(X);
            opt.ID = i;
            menuOptions.add(opt);
        }

        blackScreen = new FlxSprite().makeGraphic(FlxG.width * 5, FlxG.height * 5, FlxColor.BLACK);
        blackScreen.screenCenter();

        textGroup = new FlxTypedGroup<Alphabet>();

        impStudios= new FlxSprite(0, FlxG.height * 0.425).loadGraphic(Paths.image('impStudios'));
		impStudios.alpha = 0;
		impStudios.setGraphicSize(0, 480);
		impStudios.updateHitbox();
		impStudios.screenCenter();

        glitchProd = new FlxSprite(0, FlxG.height * 0.425).loadGraphic(Paths.image('glitch_prod'));
		glitchProd.alpha = 0;
		glitchProd.setGraphicSize(0, 320);
		glitchProd.updateHitbox();
		glitchProd.screenCenter(X);
    }

    override public function destroy()
    {
        loaded = false;

        logoBl = null;
        menuOptions.clear();
        menuOptions = null;

        blackScreen = null;
		textGroup = null;
		glitchProd = null;
        impStudios = null;

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
        add(blackScreen);
        add(textGroup);
        add(impStudios);
        add(glitchProd);

        // createCoolText(['Based on the series from']);

        FlxG.mouse.visible = true;
        // MusicBeatState.playMenuMusic(0, true);
		#if mobile
		FlxG.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		#end
        FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        FlxG.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

        goToOptions = false;

        if (initialized)
			skipIntro();
		else{
			initialized = true;
			// MusicBeatState.playMenuMusic(0, true);
		}
    }

    var scale = 1.2;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || (controls != null && controls.ACCEPT) || FlxG.mouse.justPressed;

		#if mobile
		for (touch in FlxG.touches.list){
			if (touch.justPressed)
				pressedEnter = true;
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

        if (initialized && pressedEnter && !skippedIntro)
			skipIntro();

        // if(FlxG.sound.music == null && pressedEnter && !skippedIntro)
        //     MusicBeatState.playMenuMusic(1, true);

        menuOptions.forEach(function(txt:FlxText){
            txt.screenCenter(X);

            // dancetrap marry me
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

        closedState = true;

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
                    
                    FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
                    FlxG.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					
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

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
    override function beatHit()
    {
        super.beatHit();

        if(!closedState) {
			sickBeats++;
		    switch (sickBeats * 0.5)
			{
                case 1:
					FlxG.sound.music.stop();
					if (MusicBeatState.menuVox != null)
					{
						MusicBeatState.menuVox.stop();
						MusicBeatState.menuVox.destroy();
						MusicBeatState.menuVox = null;
					}
					MusicBeatState.playMenuMusic(0, true);
                    MusicBeatState.playMenuMusic(1, true);
                    FlxG.camera.zoom = 0.75;
                    camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 10);
					createCoolText(['','','','','','','','PRESENTS']);
                    FlxTween.tween(impStudios, {alpha: 1}, 2);
                    for(text in textGroup.members)
                    {
                        text.alpha = 0;
                        FlxTween.tween(text, {alpha: 1}, 2);
                    }
					//FlxG.sound.music.fadeIn(4, 0, 0.7);
                case 7:
                    for(text in textGroup.members)
                    {
                        FlxTween.tween(text, {alpha: 0}, 1);
                    }
                    FlxTween.tween(impStudios, {alpha: 0}, 1);
                case 9:
                    deleteCoolText();
                    if(camZoom != null) camZoom.cancel();
                    FlxG.camera.zoom = 0.75;
                    camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 10);
                    createCoolText(['Based on the series from']);
                    for(text in textGroup.members)
                    {
                        text.alpha = 0;
                        FlxTween.tween(text, {alpha: 1}, 2);
                    }
                    FlxTween.tween(glitchProd, {alpha: 1}, 2);
                case 15:
                    for(text in textGroup.members)
                    {
                        FlxTween.tween(text, {alpha: 0}, 1);
                    }
                    FlxTween.tween(glitchProd, {alpha: 0}, 1);
                case 17:
                    skipIntro();
            }
        }
    }

    function createCoolText(textArray:Array<String>, ?offset:Float = 0)
    {
        for (i in 0...textArray.length)
        {
            var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
            money.screenCenter(X);
            money.y += (i * 60) + 200 + offset;
            if (textGroup != null) {
                textGroup.add(money);
            }
        }
    }
    
    function addMoreText(text:String, ?offset:Float = 0)
    {
        if(textGroup != null) {
            var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
            coolText.screenCenter(X);
            coolText.y += (textGroup.length * 60) + 200 + offset;
            textGroup.add(coolText);
        }
    }
    
    function deleteCoolText()
    {
        while (textGroup.members.length > 0){
            textGroup.remove(textGroup.members[0], true).destroy();
        }
    }

    function skipIntro():Void
    {
        if (!skippedIntro)
        {
            if(camZoom != null) camZoom.cancel();
            FlxG.camera.zoom = 1;
            
            remove(glitchProd);
            remove(impStudios);
            remove(blackScreen);
            remove(textGroup);
    
            FlxG.camera.flash(FlxColor.WHITE, 2);

            FlxTween.tween(logoBl, {y: 25}, 2, {ease: FlxEase.cubeInOut});
            FlxTween.tween(menuOptions, {y: 0}, 2, {ease: FlxEase.cubeInOut});
                
            skippedIntro = true;
        }
    }

    var skippedIntro:Bool = false;
    // Mouse functions
    function onMouseUp(e)
    {
        if (hasSelected)
			return;

        #if mobile
		mouseHolding = false;

		if (mouseSwipe < -0.65)
			return changeItem(-1);
		else if (mouseSwipe > 0.65)
			return changeItem(1);

		mouseSwipe = 0;
		#end

        if(menuOptions != null && menuOptions.members.length > 0)
		for (txt in menuOptions){
			if (FlxG.mouse.overlaps(txt) && !hasSelected && skippedIntro)
                goTo(txt.ID);
				// trace(txt.ID);
		}
    }

    function onMouseMove(bread)
    {
        if(skippedIntro)
        {
            #if mobile
            if (mouseHolding && !hasSelected)
                mouseSwipe = (mouseHoldStartX - FlxG.mouse.x) / FlxG.width;
            else
                mouseSwipe = 0;
            
            #else
            for (txt in menuOptions) {
                if (FlxG.mouse.overlaps(txt) && !hasSelected)
                {
                    Mouse.cursor = BUTTON;
                    return;
                }
            }
    
            Mouse.cursor = MouseCursor.AUTO;
            #end
        }
    }

    #if mobile
	var mouseHolding:Bool = false;
	var mouseHoldStartX:Float;
	var mouseSwipe:Float = 0;

	function onMouseDown(e)
	{
		mouseHolding = true;
		mouseHoldStartX = FlxG.mouse.x;
	}
    #end
}