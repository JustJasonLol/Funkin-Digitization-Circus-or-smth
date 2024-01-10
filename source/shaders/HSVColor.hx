package shaders;

import flixel.system.FlxAssets.FlxShader;

class HSVColor{

    public var shader(default, null):HSVShader = new HSVShader();
	public var hue(default, set):Float = 0;
	public var saturation(default, set):Float = 1;
	public var value(default, set):Float = 1;

    public function new()
    {
        shader.hue.value = [hue];
        shader.saturation.value = [saturation];
        shader.value.value = [value];
    }

    private function set_hue(val:Float)
    {
        hue = CoolUtil.boundTo(val, 0, 1);
        shader.hue.value = [hue];
        return hue;
    }

    private function set_saturation(val:Float)
    {
        saturation = CoolUtil.boundTo(val, 0, 1);
        shader.saturation.value = [saturation];
        return saturation;
    }

    private function set_value(val:Float)
    {
        value = CoolUtil.boundTo(val, 0, 1);
        shader.value.value = [value];
        return value;
    }
}

class HSVShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        uniform float hue;
        uniform float saturation;
        uniform float value;

        void main()
		{
            vec2 uv = fragCoord/iResolution.xy;
            vec4 tex0 = texture(iChannel0, uv);
            
            float H = hue * 3.0;
            float S = saturation;
            float V = value;
            
            // 2 or 3 components of hue_term can be calculated on the CPU if prefered to remove the min/abs/sub here
            vec3 hue_term = 1.0 - min(abs(vec3(hue) - vec3(0,2.0,1.0)), 1.0);
            hue_term.x = 1.0 - dot(hue_term.yz, vec2(1));
            vec3 res = vec3(dot(tex0.xyz, hue_term.xyz), dot(tex0.xyz, hue_term.zxy), dot(tex0.xyz, hue_term.yzx));
            res = mix(vec3(dot(res, vec3(0.2, 0.5, 0.3))), res, S);
            res = res * V;
            fragColor = vec4(res, tex0.w);
        }

    ')
    public function new()
    {
        super();
    }
}