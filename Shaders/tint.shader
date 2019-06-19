shader_type canvas_item;

uniform float saturation = 0.8;

void fragment() {
  vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
  c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, saturation);

  COLOR.rgb = c;
}