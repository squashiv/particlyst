@tool
#class_name ParticlystModifierShape
extends "particlyst_modifier.gd"

@export_range(0, 100, 0.1, "suffix:%") var hollowness := 0.0
@export var on_start := true
@export var as_velocity := false

func _validate_property(p_property: Dictionary) -> void:
	match p_property.name:
		&"hollowness":
			p_property.particlyst = true
			p_property.revert_value = 0.0
		&"on_start":
			p_property.particlyst = true
			p_property.revert_value = true
			if def.type != ParticlystCommon.Property.POSITION:
				ParticlystCommon.fclear(p_property.usage, PROPERTY_USAGE_EDITOR)
		&"as_velocity":
			p_property.particlyst = true
			p_property.revert_value = false

static func _get_name_prefix() -> String:
	return "Shape"

static func _get_icon_path() -> String:
	return "res://addons/particlyst/icon/particlyst_type_vector3.svg"

static func _get_default_property_type() -> ParticlystCommon.Property:
	return ParticlystCommon.Property.POSITION

static func _is_property_compatible(p_property: ParticlystCommon.Property) -> bool:
	return ParticlystCommon.PROPERTY_DEFINITIONS[p_property].type_gd == TYPE_VECTOR3

func _is_on_start() -> bool:
	return on_start

func _get_code_uniforms() -> String:
	return _declare_uniform("hollowness", "float")

func _get_code_body() -> String:
	var code := _declare_local_var("dir", "vec3") + NEW_LINE
	code += "%s"
	if as_velocity:
		code += NEW_LINE + "VELOCITY += %s;" % _name_local_var("dir")
	return code

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	p_mat.set_shader_parameter(_name_uniform("hollowness"), hollowness * 0.01)

func _has_gizmo() -> bool:
	return true
