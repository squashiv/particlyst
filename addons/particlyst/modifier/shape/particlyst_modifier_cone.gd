@tool
#class_name ParticlystModifierCone
extends "../particlyst_modifier_shape.gd"

const FUNC = """vec3 shape_cone(inout uint p_seed, float p_radius, float p_height, float p_angle, float p_hollowness, out vec3 p_dir) {
	float angle = rand_from_seed(p_seed) * TAU;
	float height_ratio = rand_from_seed(p_seed);
	float radius = mix(p_radius, p_angle, height_ratio) * pow(mix(rand_from_seed(p_seed), 1.0, p_hollowness), 0.333333);
	p_dir = vec3(
		cos(angle),
		0,
		sin(angle)
	);
	return vec3(
		p_dir.x * radius,
		p_height * height_ratio,
		p_dir.z * radius
	);
}"""

@export_range(0, 10, 0.01, "suffix:m") var radius := 1.0
@export_range(0, 10, 0.01, "suffix:m") var height := 1.0
@export_range(0, 10, 0.01, "suffix:m") var angle := 1.0

func _validate_property(p_property: Dictionary) -> void:
	super(p_property)
	match p_property.name:
		&"radius":
			p_property.particlyst = true
			p_property.revert_value = 1.0
		&"height":
			p_property.particlyst = true
			p_property.revert_value = 1.0
		&"angle":
			p_property.particlyst = true
			p_property.revert_value = 1.0

static func _get_name_prefix() -> String:
	return "Cone"

static func _get_base_type() -> String:
	return "Shape"

static func _get_icon_path() -> String:
	return "res://addons/particlyst/icon/particlyst_shape_cone.svg"

func _get_code_uniforms() -> String:
	return super() + NEW_LINE + _declare_uniform("radius", "float") + NEW_LINE + _declare_uniform("height", "float") + NEW_LINE + _declare_uniform("angle", "float") + NEW_LINE

func _get_code_function_names() -> Array[StringName]:
	return [&"shape_cone"]

func _get_code_functions(p_func_name: StringName) -> String:
	return FUNC

func _get_code_body() -> String:
	return super() % _make_operation("shape_cone(seed, %s, %s, %s, %s, %s)" % [_name_uniform("radius"), _name_uniform("height"), _name_uniform("angle"), _name_uniform("hollowness"), _name_local_var("dir")])

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	super(p_mat)
	p_mat.set_shader_parameter(_name_uniform("radius"), radius)
	p_mat.set_shader_parameter(_name_uniform("height"), height)
	p_mat.set_shader_parameter(_name_uniform("angle"), angle)

func _get_gizmo_lines() -> PackedVector3Array:
	var lines: PackedVector3Array
	var circle := _make_gizmo_circle()
	var top := Vector3(angle, height, angle)
	var bottom := Vector3(radius, 0, radius)
	lines += circle * Transform3D.IDENTITY.scaled(Vector3.ONE * radius)
	lines += circle * Transform3D.IDENTITY.scaled(Vector3.ONE * angle) * Transform3D.IDENTITY.translated(Vector3.DOWN * height)
	lines.append(Vector3(1, 1, 0) * top)
	lines.append(Vector3(1, 1, 0) * bottom)
	lines.append(Vector3(-1, 1, 0) * top)
	lines.append(Vector3(-1, 1, 0) * bottom)
	lines.append(Vector3(0, 1, 1) * top)
	lines.append(Vector3(0, 1, 1) * bottom)
	lines.append(Vector3(0, 1, -1) * top)
	lines.append(Vector3(0, 1, -1) * bottom)
	return lines
