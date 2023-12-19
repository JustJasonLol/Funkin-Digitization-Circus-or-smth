import flixel.FlxG;

class Data {
    public static var freeplay = false;
    public static var secondTime = false;

    public static function save() {
        FlxG.save.data.freeplay = freeplay;
        FlxG.save.data.secondTime = secondTime;
        FlxG.save.flush();
    }

    public static function lock() {
        freeplay = false;
        secondTime = false;

        save();
    }
    
    public static function load() {
        if (FlxG.save.data.freeplay != null) freeplay = FlxG.save.data.freeplay;
        if (FlxG.save.data.secondTime != null) secondTime = FlxG.save.data.secondTime;
    }
}