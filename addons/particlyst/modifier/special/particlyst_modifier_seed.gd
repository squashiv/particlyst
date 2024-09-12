@tool
#class_name ParticlystModifierCustomSeed
extends "../particlyst_modifier_special.gd"

@export var custom := 0

func _validate_property(p_property: Dictionary) -> void:
	match p_property.name:
		&"custom":
			p_property.particlyst = true
			p_property.revert_value = 0

static func _get_name_prefix() -> String:
	return "Seed"

static func _get_base_type() -> String:
	return "Special"

func _get_code_defines() -> String:
	return """#if defined(RANDOM_SEED_SETUP)
#undef RANDOM_SEED_SETUP
#endif
#define RANDOM_SEED_SETUP(base) uint seed = hash(INDEX + uint(base) + uint(%s));""" % _name_uniform("custom_seed")

func _get_code_uniforms() -> String:
	return _declare_uniform("custom_seed", "int")

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	p_mat.set_shader_parameter(_name_uniform("custom_seed"), custom)
