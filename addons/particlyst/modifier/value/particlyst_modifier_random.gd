@tool
#class_name ParticlystModifierRandom
extends "../particlyst_modifier_value.gd"

@export_storage var value_min: Variant
@export_storage var value_max: Variant
@export var uniform := true

func _validate_property(p_property: Dictionary) -> void:
	match p_property.name:
		&"value_min":
			p_property.particlyst = true
			p_property.type = def.type_gd
			p_property.is_variant = true
			p_property.usage = ParticlystCommon.fset(p_property.usage, PROPERTY_USAGE_EDITOR)
			p_property.revert_value = def.default_gd
		&"value_max":
			p_property.particlyst = true
			p_property.type = def.type_gd
			p_property.is_variant = true
			p_property.usage = ParticlystCommon.fset(p_property.usage, PROPERTY_USAGE_EDITOR)
			p_property.revert_value = def.default_gd
		&"uniform":
			p_property.particlyst = true
			p_property.revert_value = true

static func _get_name_prefix() -> String:
	return "Random"

static func _get_base_type() -> String:
	return "Value"

func _get_code_uniforms() -> String:
	return _declare_uniform("value_min") + NEW_LINE + _declare_uniform("value_max")

func _get_code_body() -> String:
	return _make_operation("mix(%s, %s, rand_from_seed%s(seed))" % [_name_uniform("value_min"), _name_uniform("value_max"), "" if uniform else "_" + def.type_shader])

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	p_mat.set_shader_parameter(_name_uniform("value_min"), value_min)
	p_mat.set_shader_parameter(_name_uniform("value_max"), value_max)
