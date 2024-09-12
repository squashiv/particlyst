@tool
#class_name ParticlystModifierApplyRotation
extends "../particlyst_modifier_special.gd"

static func _get_name_prefix() -> String:
	return "Apply Rotation"

static func _get_base_type() -> String:
	return "Special"

func _get_code_body() -> String:
	return "TRANSFORM = apply_rotation(TRANSFORM, radians(ROTATION));\n\tROTATION = vec3(0);"
