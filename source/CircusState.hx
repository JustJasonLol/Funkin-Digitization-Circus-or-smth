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
    static var background:FlxSprite;
    static var bars:FlxSprite;
    static var watermarks:FlxSprite;

    static var blackScreen:FlxSprite;
    static var textGroup:FlxTypedGroup<Alphabet>;
    static var impStudios:FlxSprite;
    static var glitchProd:FlxSprite;
    static var gooseworx:FlxSprite;

    var camZoom:FlxTween;
    
    public static var menuOptions:FlxTypedSpriteGroup<FlxSprite>;
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

    var randomtexts:Array<Array<String>> = [
        ["You should check HBF", 'NOW'],
        ["Awesome text", "Awesome text"],
        ['XDDCC', 'My Beloved'],
        ["Imp", 'ortant studios'],
        ['Kaufmo haters', 'DNI *vine boom*']
    ];

    var lastlines:Array<String> = [
        "boi!",
        "lol",
        "yay!",
        "let's go!",
        "brah",
        "bruh"
    ];

    // line 324
    var onFreeplay = false;

    static public function load()
    {
        background = new FlxSprite(0, 0).loadGraphic(Paths.image('title/bg'));
        background.scale.set(.5, .5);
		background.updateHitbox();
		background.screenCenter();

        bars = new FlxSprite(0, 0).loadGraphic(Paths.image('title/bars'));
        bars.scale.set(.5, .5);
		bars.updateHitbox();
		bars.screenCenter();

        watermarks = new FlxSprite(0, 0).loadGraphic(Paths.image('title/watermark'));
        watermarks.scale.set(.48, .48);
		watermarks.updateHitbox();
		watermarks.screenCenter();

        logoBl = new FlxSprite(0, 0).loadGraphic(Paths.image('title/logo'));
        logoBl.scale.set(.5, .5);
		logoBl.scrollFactor.set();
        logoBl.updateHitbox();
		logoBl.screenCenter();

        // if(FlxG.sound.music == null)
            MusicBeatState.playMenuMusic(0);

        loaded = true;

        menuOptions = new FlxTypedSpriteGroup<FlxSprite>(0,FlxG.height);

        for(i in 0...options.length)
        {
            var opt:FlxSprite = new FlxSprite(0, 425 + 80*i).loadGraphic(Paths.image('title/${options[i].toLowerCase()}'));
            opt.screenCenter(X);
            opt.ID = i;
            menuOptions.add(opt);
        }

        menuOptions.forEach(h -> h.scale.set(.5, .5));

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

        gooseworx = new FlxSprite(0, FlxG.height * 0.425).loadGraphic(Paths.image('gooseworx'));
		gooseworx.alpha = 0;
		gooseworx.updateHitbox();
		gooseworx.screenCenter(X);
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
        gooseworx = null;
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

        #if discord_rpc
        DiscordClient.changePresence('In the Main Menu', null);
        #end

        currentRandom = FlxG.random.int(0, randomtexts.length);

        add(background);
        add(bars);
        add(watermarks);
        add(logoBl);
        add(menuOptions);
        add(blackScreen);
        add(textGroup);
        add(impStudios);
        add(glitchProd);
        add(gooseworx);

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

    var scale = .55;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.Q) MusicBeatState.switchState(new Thanks());

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

        if (logoBl != null)
        {
            logoBl.scale.x = FlxMath.lerp(logoBl.scale.x, .5, CoolUtil.boundTo(elapsed * 4.8, 0, 1));
            logoBl.scale.y = FlxMath.lerp(logoBl.scale.y, .5, CoolUtil.boundTo(elapsed * 4.8, 0, 1));
        }

        menuOptions.forEach(function(txt:FlxSprite){
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
                    txt.scale.x = FlxMath.lerp(txt.scale.x, .5, CoolUtil.boundTo(elapsed * 5.4, 0, 1));
                    txt.scale.y = FlxMath.lerp(txt.scale.y, .5, CoolUtil.boundTo(elapsed * 5.4, 0, 1));
                }
            }
            
            txt.updateHitbox();
        });

        if(hasSelected)
        {
            menuOptions.members[selectedID].scale.x = FlxMath.lerp(menuOptions.members[selectedID].scale.x, scale, CoolUtil.boundTo(elapsed * 5.4, 0, 1));
            menuOptions.members[selectedID].scale.y = FlxMath.lerp(menuOptions.members[selectedID].scale.y, scale, CoolUtil.boundTo(elapsed * 5.4, 0, 1));
        }

        if(!skippedIntro)
        {
            if(canBounce) FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, CoolUtil.boundTo(elapsed * 4.8, 0, 1));
        }
        else
        {
            canBounce = false;
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
            
        menuOptions.forEach(function(spr:FlxSprite)
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
					    menuOptions.forEach(function(spr:FlxSprite)
					    {
						    switch (daChoice)
						    {
                                case 'Play':
                                    // Nevermind that's stupid lmao
                                    try
                                    {
                                        if (!Data.freeplay)
                                        {
                                            PlayState.storyPlaylist = ['Welcome', 'Buffon'];
                                            PlayState.isStoryMode = true;

                                            PlayState.difficulty = 1;
                                
                                            PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), PlayState.storyPlaylist[0].toLowerCase());
                                            PlayState.campaignScore = 0;
                                            PlayState.campaignMisses = 0;

                                            FlxG.camera.fade();
                                            @:privateAccess
                                                FlxG.camera._fxFadeComplete = () -> {
                                                    LoadingState.loadAndSwitchState(new PlayState());
                                                };
                                        } else // honestly i think we should make like freeplay and main menu together.
                                            MusicBeatState.switchState(new FreeplayButCircusEditionYay());
                                    }
                                    catch(e:Dynamic)
                                    {
                                        trace('ERROR! $e');
                                        return;
                                    }
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
                        menuOptions.forEach(function(spr:FlxSprite)
					    {
						    switch (daChoice)
						    {
                                case 'Play':
                                    try
                                        {
                                            if (!Data.freeplay)
                                            {
                                                PlayState.storyPlaylist = ['Welcome', 'Buffon'];
                                                PlayState.isStoryMode = true;
    
                                                PlayState.difficulty = 1;
                                    
                                                PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), PlayState.storyPlaylist[0].toLowerCase());
                                                PlayState.campaignScore = 0;
                                                PlayState.campaignMisses = 0;
    
                                                FlxG.camera.fade();
                                                @:privateAccess
                                                    FlxG.camera._fxFadeComplete = () -> {
                                                        LoadingState.loadAndSwitchState(new PlayState());
                                                    };
                                            } else
                                                MusicBeatState.switchState(new FreeplayButCircusEditionYay());
                                        }
                                        catch(e:Dynamic)
                                        {
                                            trace('ERROR! $e');
                                            return;
                                        }
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

    var canBounce:Bool = false;
	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
    var currentRandom:Int = 0;
    override function beatHit()
    {
        super.beatHit();

        if (logoBl != null && curBeat % 2 == 0) logoBl.scale.set(.57, .57);

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
                    if (!skippedIntro) FlxG.camera.zoom = 0.75;
                    if (!skippedIntro) camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 5);
					createCoolText(['','','','','','','','PRESENTS']);
                    FlxTween.tween(impStudios, {alpha: 1}, 2);
                    for(text in textGroup.members)
                    {
                        text.alpha = 0;
                        FlxTween.tween(text, {alpha: 1}, 2);
                    }
					//FlxG.sound.music.fadeIn(4, 0, 0.7);
                case 3:
                    for(text in textGroup.members)
                    {
                        FlxTween.tween(text, {alpha: 0}, 1);
                    }
                    FlxTween.tween(impStudios, {alpha: 0}, 1);
                case 5:
                    deleteCoolText();
                    if(camZoom != null) camZoom.cancel();
                    if (!skippedIntro) FlxG.camera.zoom = 0.75;
                    if (!skippedIntro) camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 5);
                    createCoolText(['Based on the series from']);
                    for(text in textGroup.members)
                    {
                        text.alpha = 0;
                        FlxTween.tween(text, {alpha: 1}, 2);
                    }
                    FlxTween.tween(glitchProd, {alpha: 1}, 2);
                case 7:
                    for(text in textGroup.members)
                    {
                        FlxTween.tween(text, {alpha: 0}, 1);
                    }
                    FlxTween.tween(glitchProd, {alpha: 0}, 1);

                case 9:
                    deleteCoolText();
                    if(camZoom != null) camZoom.cancel();
                    if (!skippedIntro) FlxG.camera.zoom = 0.75;
                    if (!skippedIntro) camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 5);
                    createCoolText(['And the mind of']);
                    for(text in textGroup.members)
                    {
                        text.alpha = 0;
                        FlxTween.tween(text, {alpha: 1}, 2);
                    }
                    FlxTween.tween(gooseworx, {alpha: 1}, 2);

                case 11:
                    for(text in textGroup.members)
                    {
                        FlxTween.tween(text, {alpha: 0}, 1);
                    }
                    FlxTween.tween(gooseworx, {alpha: 0}, 1);

                case 13:
                    canBounce = true;
                    if(camZoom != null) camZoom.cancel();
                    if (!skippedIntro) FlxG.camera.zoom = 1.05;
                    createCoolText([randomtexts[currentRandom][0]]);
                case 14:
                    if (!skippedIntro) FlxG.camera.zoom = 1.05;
                    addMoreText(randomtexts[currentRandom][1]);
                case 14.5:
                    deleteCoolText();
                case 15:
                    createCoolText(['Funkin']);
                    if (!skippedIntro) FlxG.camera.zoom = 1.05;
                case 15.5:
                    addMoreText('Digitization');
                    if (!skippedIntro) FlxG.camera.zoom = 1.05;
                case 16:
                    addMoreText('Circus');
                    if (!skippedIntro) FlxG.camera.zoom = 1.05;
                case 16.5:
                    addMoreText('');
                    addMoreText(lastlines[currentRandom]);
                    if (!skippedIntro) FlxG.camera.zoom = 1.05;
                case 17:
                if (!skippedIntro)
                {
                    FlxG.camera.visible = true;
                    if (ClientPrefs.flashing) FlxG.camera.flash();
                }
                skipIntro();

                // case 19:
                    // addMoreText(randomtexts[currentRandom][1]);
                // case 21: if (!skippedIntro)
                // {
                //     FlxG.camera.visible = true;
                //     if (ClientPrefs.flashing) FlxG.camera.flash();
                // }
                // skipIntro();
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
            canBounce = false;
            if(camZoom != null) camZoom.cancel();
            FlxG.camera.zoom = 1;
            
            remove(gooseworx);
            remove(glitchProd);
            remove(impStudios);
            remove(blackScreen);
            remove(textGroup);
    
            FlxG.camera.flash(FlxColor.WHITE, 2);

            FlxTween.tween(logoBl, {y: -24}, 2, {ease: FlxEase.cubeInOut});
            FlxTween.tween(menuOptions, {y: -13}, 2, {ease: FlxEase.cubeInOut});
                
            skippedIntro = true;
        }
    }

    var skippedIntro:Bool = false;
    // Mouse functions
    function onMouseUp(e)
    {
        if (hasSelected)
			return;

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
            for (txt in menuOptions) {
                if (FlxG.mouse.overlaps(txt) && !hasSelected)
                {
                    Mouse.cursor = BUTTON;
                    return;
                }
            }
    
            Mouse.cursor = MouseCursor.AUTO;
        }
    }
}