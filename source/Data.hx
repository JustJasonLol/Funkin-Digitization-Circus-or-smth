import flixel.FlxG;

class Data {
    public static var freeplay = false;
    public static var firstTime = true;

    public static function save() {
        FlxG.save.data.freeplay = freeplay;
        FlxG.save.data.firstTime = firstTime;
        FlxG.save.flush();
    }
    
    public static function load() {
        if (FlxG.save.data.freeplay != null) freeplay = FlxG.save.data.freeplay;
        if (FlxG.save.data.firstTime != null) freeplay = FlxG.save.data.firstTime;
    }
}