@tool
#class_name ParticlystModifier
extends Resource

#region Constants
const ParticlystCommon = preload("res://addons/particlyst/common/particlyst_common.gd")
const NEW_LINE = "\n"
const TAB = "\t"
#endregion

#region Variables
@export_storage var enabled := true
@export_storage var target_property: ParticlystCommon.Property = -1
@export_storage var operation: ParticlystCommon.Operation = -1

var def: Dictionary:
	get:
		return ParticlystCommon.PROPERTY_DEFINITIONS[target_property]
#endregion

#region Public functions
func initialize() -> void:
	for property in get_property_list():
		_validate_property(property)
		if property.has(&"particlyst") and property.has(&"revert_value"):
			set(property.name, property.revert_value)
	resource_scene_unique_id = generate_scene_unique_id()

static func _get_name_prefix() -> String:
	return "Modifier"

static func _get_base_type() -> String:
	return ""

static func _get_icon_path() -> String:
	return "res://addons/particlyst/icon/particlyst_type_variant.svg"

static func _get_default_property_type() -> ParticlystCommon.Property:
	return ParticlystCommon.Property.COLOR

static func _is_property_compatible(p_property: ParticlystCommon.Property) -> bool:
	return true

func _validate_property(p_property: Dictionary) -> void:
	return

func _is_on_start() -> bool:
	return false

func _get_code_defines() -> String:
	return ""

func _get_code_uniforms() -> String:
	return ""

func _get_code_function_names() -> Array[StringName]:
	return []

func _get_code_functions(p_func_name: StringName) -> String:
	return ""

func get_code_body() -> String:
	return _get_code_body()

func _get_code_body() -> String:
	return ""

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	pass

func _has_gizmo() -> bool:
	return false

func _get_gizmo_lines() -> PackedVector3Array:
	return PackedVector3Array()
#endregion

#region Private functions
func _make_operation(p_code: String) -> String:
	return ParticlystCommon.make_operation(operation, def.name_shader, p_code)

func _name_uniform(p_name_suffix: String) -> String:
	return "u_%s_%s" % [resource_scene_unique_id, p_name_suffix]

func _declare_uniform(p_name_suffix: String, p_custom_type := "") -> String:
	if p_custom_type.is_empty():
		return "uniform %s %s%s;" % [def.type_shader, _name_uniform(p_name_suffix), def.hint_shader]
	elif p_custom_type == &"sampler2D":
		return "uniform %s %s%s;" % ["sampler2D", _name_uniform(p_name_suffix), def.hint_texture_shader]
	else:
		return "uniform %s %s;" % [p_custom_type, _name_uniform(p_name_suffix)]

func _declare_uniform_texture(p_name_suffix: String, p_repeat: bool) -> String:
	return "uniform %s %s%s;" % ["sampler2D", _name_uniform(p_name_suffix), def.hint_texture_shader + (", repeat_enable" if p_repeat else ", repeat_disable")]

func _sample_texture(p_texture: String, p_uv: String, p_swizzle: String = def.texture_swizzle_shader) -> String:
	return "texture(%s, vec2(%s))%s" % [_name_uniform(p_texture), p_uv, p_swizzle]

func _declare_local_var(p_name_suffix: String, p_type: String) -> String:
	return "%s %s;" % [p_type, _name_local_var(p_name_suffix)]

func _name_local_var(p_name_suffix: String) -> String:
	return "l_%s_%s" % [resource_scene_unique_id, p_name_suffix]

func _make_gizmo_circle() -> PackedVector3Array:
	var lines: PackedVector3Array
	for i in 64:
		var p1 := Vector2.from_angle(i / 63.0 * TAU)
		var p2 := Vector2.from_angle((i + 1) / 63.0 * TAU)
		lines.append(Vector3(p1.x, 0, p1.y))
		lines.append(Vector3(p2.x, 0, p2.y))
	return lines
#endregion
