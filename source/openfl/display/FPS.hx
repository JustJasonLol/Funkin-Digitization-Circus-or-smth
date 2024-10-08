package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.math.FlxMath;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end

#if openfl
import openfl.system.System;
#end
import cpp.vm.Gc;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Float;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;

		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		var textFormat = new TextFormat(null, 12, color);
		var fontPath = '_sans';
		if (Assets.exists(fontPath, openfl.utils.AssetType.FONT)){
			embedFonts = true;
			textFormat.size = 14;
			textFormat.font = Assets.getFont(fontPath).fontName;
		}else{
			embedFonts = false;
			textFormat.font = "_sans";
		}
		defaultTextFormat = textFormat;

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		var memPeak = .0;
		var mem = FlxMath.roundDecimal(System.totalMemory / 1000000, 1) + 100;
		currentFPS = Math.ffloor((currentCount + cacheCount)* 0.5);
		if (currentFPS > ClientPrefs.framerate)
			currentFPS = ClientPrefs.framerate;
		if (mem >= memPeak) memPeak = mem;

		if (currentCount != cacheCount /*&& visible*/)
		{
			text = 'FPS: $currentFPS\nMemory: ${FlxMath.roundDecimal(System.totalMemory / 1000000, 1) + 100} mb / $memPeak mb';
			
			var memoryMegas:Float = 0;
			/*
			#if (openfl && !final)
			memoryMegas = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));
			text += "\nMemory: " + memoryMegas + " MB";
			#end

			text += "\nState: " + Type.getClassName(Type.getClass(FlxG.state));
			text += "\nSubstate: " + Type.getClassName(Type.getClass(FlxG.state.subState));
			*/

			textColor = 0xFFFFFFFF;
			if (currentFPS <= ClientPrefs.framerate * 0.5 || memoryMegas > 3000)
				textColor = 0xFFFF0000;

			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end
		}

		cacheCount = currentCount;
	}
}
