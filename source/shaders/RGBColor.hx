package shaders;

import flixel.system.FlxAssets.FlxShader;

class RGBColor{

    public var shader(default, null):RGBShader = new RGBShader();
	// public var red(default, set):Float = 1;
	// public var green(default, set):Float = 1;
	// public var blue(default, set):Float = 1;

    public function new(red:Float = 1, green:Float = 1, blue:Float = 1)
    {
        shader.red.value = [red];
        shader.green.value = [green];
        shader.blue.value = [blue];

        // shader.red.value = [CoolUtil.boundTo(red, 0, 1)];
        // shader.green.value = [CoolUtil.boundTo(green, 0, 1)];
        // shader.blue.value = [CoolUtil.boundTo(blue, 0, 1)];
    }

    // private function set_red(val:Float)
    // {
    //     red = CoolUtil.boundTo(val, 0, 1);
    //     shader.red.value = [red];
    //     return red;
    // }

    // private function set_green(val:Float)
    // {
    //     green = CoolUtil.boundTo(val, 0, 1);
    //     shader.green.value = [green];
    //     return green;
    // }

    // private function set_blue(val:Float)
    // {
    //     blue = CoolUtil.boundTo(val, 0, 1);
    //     shader.blue.value = [blue];
    //     return blue;
    // }
}

class RGBShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        // uniform float hue;
        // uniform float saturation;
        // uniform float value;

        uniform float red;
        uniform float green;
        uniform float blue;

        void main()
		{
            //vec2 uv = fragCoord/iResolution.xy;
            vec4 tex0 = flixel_texture2D(bitmap, openfl_TextureCoordv);
            
            // float H = hue * 3.0;
            // float S = saturation;
            // float V = value;
            
            // 2 or 3 components of hue_term can be calculated on the CPU if prefered to remove the min/abs/sub here
            //vec3 hue_term = 1.0 - min(abs(vec3(hue) - vec3(0,2.0,1.0)), 1.0);
            //hue_term.x = 1.0 - dot(hue_term.yz, vec2(1));
            //vec3 res = vec3(dot(tex0.xyz, hue_term.xyz), dot(tex0.xyz, hue_term.zxy), dot(tex0.xyz, hue_term.yzx));
            //res = mix(vec3(dot(res, vec3(0.2, 0.5, 0.3))), res, S);
            //res = res * V;
            //gl_FragColor = vec4(res, tex0.w);

            gl_FragColor = vec4(tex0.rgb,tex0.a) * vec4(red, green, blue, 1.0);
        }

    ')
    public function new()
    {
        super();
    }
}