@tool
#class_name ParticlystModifierUniform
extends "../particlyst_modifier_value.gd"

@export_storage var value: Variant

func _validate_property(p_property: Dictionary) -> void:
	match p_property.name:
		&"value":
			p_property.particlyst = true
			p_property.type = def.type_gd
			p_property.is_variant = true
			p_property.usage = ParticlystCommon.fset(p_property.usage, PROPERTY_USAGE_EDITOR)
			p_property.revert_value = def.default_gd

static func _get_name_prefix() -> String:
	return "Uniform"

static func _get_base_type() -> String:
	return "Value"

func _get_code_uniforms() -> String:
	return _declare_uniform("value")

func _get_code_body() -> String:
	return _make_operation(_name_uniform("value"))

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	p_mat.set_shader_parameter(_name_uniform("value"), value)
