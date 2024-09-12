@tool
#class_name ParticlystModifierBox
extends "../particlyst_modifier_shape.gd"

const FUNC = """vec3 shape_box(inout uint p_seed, vec3 p_size, float p_hollowness, out vec3 p_dir) {
	vec3 axis = random_axis_vec3(p_seed);
	vec3 hollowness = axis * (p_hollowness * 0.5 + 0.5);
	vec3 p = rand_from_seed_vec3(p_seed);
	p = mix(p, vec3(1), hollowness) * 2.0 - 1.0;
	float sig = round(rand_from_seed(p_seed)) * 2.0 - 1.0;
	p *= p_size * sig;
	p_dir = axis * sig;
	return p;
}"""

@export_custom(PROPERTY_HINT_LINK, "suffix:m") var size := Vector3.ONE

func _validate_property(p_property: Dictionary) -> void:
	super(p_property)
	match p_property.name:
		&"size":
			p_property.particlyst = true
			p_property.revert_value = Vector3.ONE

static func _get_name_prefix() -> String:
	return "Box"

static func _get_base_type() -> String:
	return "Shape"

static func _get_icon_path() -> String:
	return "res://addons/particlyst/icon/particlyst_shape_box.svg"

func _get_code_uniforms() -> String:
	return super() + NEW_LINE + _declare_uniform("size", "vec3")

func _get_code_function_names() -> Array[StringName]:
	return [&"shape_box"]

func _get_code_functions(p_func_name: StringName) -> String:
	return FUNC

func _get_code_body() -> String:
	return super() % _make_operation("shape_box(seed, %s, %s, %s)" % [_name_uniform("size"), _name_uniform("hollowness"), _name_local_var("dir")])

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	super(p_mat)
	p_mat.set_shader_parameter(_name_uniform("size"), size * 0.5)

func _get_gizmo_lines() -> PackedVector3Array:
	return PackedVector3Array([
		Vector3(-1, -1, -1), Vector3(1, -1, -1), Vector3(1, -1, -1), Vector3(1, 1, -1),
		Vector3(1, 1, -1), Vector3(-1, 1, -1), Vector3(-1, 1, -1), Vector3(-1, -1, -1),
		Vector3(-1, -1, 1), Vector3(1, -1, 1), Vector3(1, -1, 1), Vector3(1, 1, 1),
		Vector3(1, 1, 1), Vector3(-1, 1, 1), Vector3(-1, 1, 1), Vector3(-1, -1, 1),
		Vector3(-1, -1, -1), Vector3(-1, -1, 1), Vector3(1, -1, -1), Vector3(1, -1, 1),
		Vector3(1, 1, -1), Vector3(1, 1, 1), Vector3(-1, 1, -1), Vector3(-1, 1, 1)
	]) * Transform3D.IDENTITY.scaled(size * 0.5) + PackedVector3Array([
		Vector3(-1, -1, -1), Vector3(1, -1, -1), Vector3(1, -1, -1), Vector3(1, 1, -1),
		Vector3(1, 1, -1), Vector3(-1, 1, -1), Vector3(-1, 1, -1), Vector3(-1, -1, -1),
		Vector3(-1, -1, 1), Vector3(1, -1, 1), Vector3(1, -1, 1), Vector3(1, 1, 1),
		Vector3(1, 1, 1), Vector3(-1, 1, 1), Vector3(-1, 1, 1), Vector3(-1, -1, 1),
		Vector3(-1, -1, -1), Vector3(-1, -1, 1), Vector3(1, -1, -1), Vector3(1, -1, 1),
		Vector3(1, 1, -1), Vector3(1, 1, 1), Vector3(-1, 1, -1), Vector3(-1, 1, 1)
	]) * Transform3D.IDENTITY.scaled(Vector3.ZERO.lerp(size * 0.5, hollowness * 0.01))
