@tool
#class_name ParticlystModifierTexture
extends "../particlyst_modifier_value.gd"

@export var texture: Texture2D
@export var uv_scale := Vector2.ONE
@export var uv_repeat := false
@export var uv_source_x: ParticlystCommon.Source
@export var uv_source_y: ParticlystCommon.Source

func _validate_property(p_property: Dictionary) -> void:
	match p_property.name:
		&"texture":
			p_property.particlyst = true
			p_property.revert_value = null
		&"uv_repeat":
			p_property.particlyst = true
			p_property.revert_value = false
		&"uv_scale":
			p_property.particlyst = true
			p_property.revert_value = Vector2.ONE
		&"uv_source_x":
			p_property.particlyst = true
			p_property.revert_value = 0
		&"uv_source_y":
			p_property.particlyst = true
			p_property.revert_value = 0

static func _get_name_prefix() -> String:
	return "Texture"

static func _get_base_type() -> String:
	return "Value"

func _get_code_uniforms() -> String:
	return _declare_uniform_texture("texture", uv_repeat) + NEW_LINE + _declare_uniform("uv_scale", "vec2")

func _get_code_body() -> String:
	return _make_operation(_sample_texture("texture", "vec2(%s, %s) * %s" % [ParticlystCommon.make_source(uv_source_x), ParticlystCommon.make_source(uv_source_y), _name_uniform("uv_scale")]))

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	p_mat.set_shader_parameter(_name_uniform("texture"), texture)
	p_mat.set_shader_parameter(_name_uniform("uv_scale"), uv_scale)
