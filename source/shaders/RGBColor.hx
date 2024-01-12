package shaders;

import flixel.system.FlxAssets.FlxShader;

class RGBColor{

    public var shader(default, null):RGBShader = new RGBShader();
	private var red(default, set):Float = 1;
	private var green(default, set):Float = 1;
	private var blue(default, set):Float = 1;

    public function new(red:Float = 1, green:Float = 1, blue:Float = 1)
    {
        this.red = red;
        this.green = green;
        this.blue = blue;
        shader.red.value = [red];
        shader.green.value = [green];
        shader.blue.value = [blue];

        // shader.red.value = [CoolUtil.boundTo(red, 0, 1)];
        // shader.green.value = [CoolUtil.boundTo(green, 0, 1)];
        // shader.blue.value = [CoolUtil.boundTo(blue, 0, 1)];
    }

    public function changeColor(r:Float = 1, g:Float = 1, b:Float = 1)
    {
        this.red = r;
        this.green = g;
        this.blue = b;
    }

    private function set_red(val:Float)
    {
        this.red = CoolUtil.boundTo(val, 0, 1);
        shader.red.value = [this.red];
        return this.red;
    }

    private function set_green(val:Float)
    {
        this.green = CoolUtil.boundTo(val, 0, 1);
        shader.green.value = [this.green];
        return this.green;
    }

    private function set_blue(val:Float)
    {
        this.blue = CoolUtil.boundTo(val, 0, 1);
        shader.blue.value = [this.blue];
        return this.blue;
    }
}

class RGBShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        uniform float red;
        uniform float green;
        uniform float blue;

        void main()
		{
            vec4 tex0 = flixel_texture2D(bitmap, openfl_TextureCoordv);
            gl_FragColor = vec4(tex0.rgb,tex0.a) * vec4(red, green, blue, 1.0);
        }

    ')
    public function new()
    {
        super();
    }
}