package;//yes I know there are better ways to create this hx but my 2 of iq get here o0o

#if desktop
import Discord.DiscordClient;
#end

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.sound.FlxSound;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.tile.FlxGraphicsShader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import openfl.filters.BitmapFilter;
import flixel.FlxBasic;
import openfl.filters.BitmapFilter;

using StringTools;

class Credits extends MusicBeatState
{
    private var camGame:FlxCamera;
    var debugKeys:Array<FlxKey>;

    // facun por q *sobs
	//jason ayuda pls, como mejoro esto :(
    var t1:FlxText;
    var t2:FlxText;
    var t3:FlxText;
    var t4:FlxText;
    var t5:FlxText;
    var t6:FlxText;
    var t7:FlxText;
    var t8:FlxText;
    var t9:FlxText;
    var t10:FlxText;
    var t11:FlxText;
    var t12:FlxText;
    var t13:FlxText;
    var t14:FlxText;
    var t15:FlxText;
    var t16:FlxText;
    var t17:FlxText;
    var t18:FlxText;
    var t19:FlxText;
    var t20:FlxText;
    var t21:FlxText;
    var t22:FlxText;
    var t23:FlxText;
    var t24:FlxText;
    var t25:FlxText;
    var t26:FlxText;
    var t27:FlxText;
    var t28:FlxText;
    var t29:FlxText;
    var t30:FlxText;
    var t31:FlxText;
    var t32:FlxText;
    var t33:FlxText;
    var t34:FlxText;
    var t35:FlxText;
    var t36:FlxText;
    var t37:FlxText;
    var t38:FlxText;
    var t39:FlxText;
    var t40:FlxText;
    var t41:FlxText;
    var t42:FlxText;
    var t43:FlxText;
    var t44:FlxText;
    var escape:FlxText;

    var sound:FlxSound;


    override function create() 
    {
        FlxG.sound.playMusic(Paths.music('Credits_Circus'), 1);

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

        var logobg:BGSprite = new BGSprite('logo_menu');
		logobg.setGraphicSize(Std.int(logobg.width * 0.85));
		logobg.y = 20;
		logobg.x = 570;
		add(logobg);

        camGame = new FlxCamera();

        FlxG.cameras.reset(camGame);

        escape = new FlxText(FlxG.width - 800, 
            'Press back to return to the main menu',
            20);
            escape.y = 655;
            escape.x = 800;
            escape.alpha = 0.7;
            escape.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER);
            add(escape);

        t1 = new FlxText(FlxG.width - 800, 
        "OWNERS",
        20);
        t1.y = 955;
        t1.x = 120;
        t1.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t1);

        t2 = new FlxText(FlxG.width - 800, 
        "raiperstyle123",
        20);
        t2.y = 1055;
        t2.x = 120;
        t2.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t2);

        t3 = new FlxText(FlxG.width - 800, 
        "murther_soy",
        20);
        t3.y = 1105;
        t3.x = 120;
        t3.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t3);

        t4 = new FlxText(FlxG.width - 800, 
        "MUSICIAN",
        20);
        t4.y = 1255;
        t4.x = 120;
        t4.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t4);

        t5 = new FlxText(FlxG.width - 800, 
        "END_SELLA",
        20);
        t5.y = 1355;
        t5.x = 120;
        t5.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t5);

        t6 = new FlxText(FlxG.width - 800, 
        "ARTISTS",
        20);
        t6.y = 1505;
        t6.x = 120;
        t6.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t6);

        t7 = new FlxText(FlxG.width - 800, 
        "donchetosj",
        20);
        t7.y = 1605;
        t7.x = 120;
        t7.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t7);

        t8 = new FlxText(FlxG.width - 800, 
        "effy8924",
        20);
        t8.y = 1655;
        t8.x = 120;
        t8.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t8);

        t9 = new FlxText(FlxG.width - 800, 
        "CODERS",
        20);
        t9.y = 1805;
        t9.x = 120;
        t9.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t9);

        t10 = new FlxText(FlxG.width - 800, 
        "arm4gedon",
        20);
        t10.y = 1905;
        t10.x = 120;
        t10.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t10);

        t11 = new FlxText(FlxG.width - 800, 
        "facunMax",
        20);
        t11.y = 1955;
        t11.x = 120;
        t11.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t11);

        t12 = new FlxText(FlxG.width - 800, 
        "CHARTER",
        20);
        t12.y = 2105;
        t12.x = 120;
        t12.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t12);

        t13 = new FlxText(FlxG.width - 800, 
        "nightmarexonix",
        20);
        t13.y = 2205;
        t13.x = 120;
        t13.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t13);

        t14 = new FlxText(FlxG.width - 800, 
        "CHROMATIC SCALER",
        20);
        t14.y = 2355;
        t14.x = 120;
        t14.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t14);

        t15 = new FlxText(FlxG.width - 800, 
        "yina_tilin",
        20);
        t15.y = 2455;
        t15.x = 120;
        t15.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER);
        add(t15);
            
        
        FlxTween.tween(t1, { y:-4750}, 65);
        FlxTween.tween(t2, { y:-4650}, 65);
        FlxTween.tween(t3, { y:-4600}, 65);
        FlxTween.tween(t4, { y:-4450}, 65);
        FlxTween.tween(t5, { y:-4350}, 65);
        FlxTween.tween(t6, { y:-4200}, 65);
        FlxTween.tween(t7, { y:-4100}, 65);
        FlxTween.tween(t8, { y:-4050}, 65);
        FlxTween.tween(t9, { y:-3900}, 65);
        FlxTween.tween(t10, { y:-3800}, 65);
        FlxTween.tween(t11, { y:-3750}, 65);
        FlxTween.tween(t12, { y:-3600}, 65);
        FlxTween.tween(t13, { y:-3500}, 65);
        FlxTween.tween(t14, { y:-3350}, 65);
        FlxTween.tween(t15, { y:-3250}, 65);


        super.create();
    }

    var selectedSomethin:Bool = false;

    override function update(elapsed:Float)
    {
        if (!selectedSomethin)
        {    
            if (controls.BACK)
			    {
				    selectedSomethin = true;
				    FlxG.sound.play(Paths.sound('cancelMenu'));
                    MusicBeatState.switchState(new MainMenuState());
                    FlxG.sound.playMusic(Paths.music('Menu'));
			    }
        } 
        
        super.update(elapsed); 
    }   
}
