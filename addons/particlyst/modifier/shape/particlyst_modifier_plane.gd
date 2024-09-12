@tool
#class_name ParticlystModifierPlane
extends "../particlyst_modifier_shape.gd"

const FUNC = """vec3 shape_plane(inout uint p_seed, vec2 p_size, float p_hollowness, out vec3 p_dir) {
	vec2 axis = random_axis_vec2(p_seed);
	vec2 hollowness = axis * (p_hollowness * 0.5 + 0.5);
	vec2 p = rand_from_seed_vec2(p_seed);
	p = mix(p, vec2(1), hollowness) * 2.0 - 1.0;
	float sig = round(rand_from_seed(p_seed)) * 2.0 - 1.0;
	p *= p_size * sig;
	p_dir = vec3(axis.x, 0, axis.y) * sig;
	return vec3(p.x, 0, p.y);
}"""

@export_custom(PROPERTY_HINT_LINK, "suffix:m") var size := Vector2.ONE

func _validate_property(p_property: Dictionary) -> void:
	super(p_property)
	match p_property.name:
		&"size":
			p_property.particlyst = true
			p_property.revert_value = Vector2.ONE

static func _get_name_prefix() -> String:
	return "Plane"

static func _get_base_type() -> String:
	return "Shape"

static func _get_icon_path() -> String:
	return "res://addons/particlyst/icon/particlyst_shape_plane.svg"

func _get_code_uniforms() -> String:
	return super() + NEW_LINE + _declare_uniform("size", "vec2")

func _get_code_function_names() -> Array[StringName]:
	return [&"shape_plane"]

func _get_code_functions(p_func_name: StringName) -> String:
	return FUNC

func _get_code_body() -> String:
	return super() % _make_operation("shape_plane(seed, %s, %s, %s)" % [_name_uniform("size"), _name_uniform("hollowness"), _name_local_var("dir")])

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	super(p_mat)
	p_mat.set_shader_parameter(_name_uniform("size"), size * 0.5)

func _get_gizmo_lines() -> PackedVector3Array:
	var outer_size := size * 0.5
	var inner_size := Vector2.ZERO.lerp(outer_size, hollowness * 0.01)
	return PackedVector3Array([
		Vector3(-outer_size.x, 0, -outer_size.y),
		Vector3(outer_size.x, 0, -outer_size.y),
		Vector3(outer_size.x, 0, -outer_size.y),
		Vector3(outer_size.x, 0, outer_size.y),
		Vector3(outer_size.x, 0, outer_size.y),
		Vector3(-outer_size.x, 0, outer_size.y),
		Vector3(-outer_size.x, 0, outer_size.y),
		Vector3(-outer_size.x, 0, -outer_size.y),
		#hollow
		Vector3(-inner_size.x, 0, -inner_size.y),
		Vector3(inner_size.x, 0, -inner_size.y),
		Vector3(inner_size.x, 0, -inner_size.y),
		Vector3(inner_size.x, 0, inner_size.y),
		Vector3(inner_size.x, 0, inner_size.y),
		Vector3(-inner_size.x, 0, inner_size.y),
		Vector3(-inner_size.x, 0, inner_size.y),
		Vector3(-inner_size.x, 0, -inner_size.y)
	])
