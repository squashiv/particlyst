@tool
#class_name ParticlystModifierLifetime
extends "../particlyst_modifier_special.gd"

@export_range(0, 100, 0.1, "suffix:%") var randomness := 0.0

func _validate_property(p_property: Dictionary) -> void:
	match p_property.name:
		&"randomness":
			p_property.particlyst = true
			p_property.revert_value = 0.0

static func _get_name_prefix() -> String:
	return "Lifetime"

static func _get_base_type() -> String:
	return "Special"

func _get_code_defines() -> String:
	return """#if defined(PARTICLE_AGE_PERCENT_SETUP)
#undef PARTICLE_AGE_PERCENT_SETUP
#endif
#define PARTICLE_AGE_PERCENT_SETUP float PARTICLE_AGE_PERCENT = PARTICLE_AGE / (LIFETIME * (1.0 - %s * rand_from_seed(seed)));""" % _name_uniform("lifetime_randomness")

func _get_code_uniforms() -> String:
	return _declare_uniform("lifetime_randomness", "float")

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	p_mat.set_shader_parameter(_name_uniform("lifetime_randomness"), randomness * 0.01)
