@tool
#class_name ParticlystModifierSphere
extends "../particlyst_modifier_shape.gd"

const FUNC = """vec3 shape_sphere(inout uint p_seed, float p_radius, float p_hollowness, out vec3 p_dir) {
	float phi = rand_from_seed(p_seed) * TAU;
	float costheta = rand_from_seed(p_seed) * 2.0 - 1.0;
	float u = rand_from_seed(p_seed);
	float theta = acos(costheta);
	float r = mix(p_radius * pow(u, 0.333333), p_radius, p_hollowness);
	p_dir = vec3(
		sin(theta) * cos(phi),
		sin(theta) * sin(phi),
		cos(theta)
	);
	return p_dir * r;
}"""

@export_range(0, 10, 0.01, "suffix:m") var radius := 1.0

func _validate_property(p_property: Dictionary) -> void:
	super(p_property)
	match p_property.name:
		&"radius":
			p_property.particlyst = true
			p_property.revert_value = 1.0

static func _get_name_prefix() -> String:
	return "Sphere"

static func _get_base_type() -> String:
	return "Shape"

static func _get_icon_path() -> String:
	return "res://addons/particlyst/icon/particlyst_shape_sphere.svg"

func _get_code_uniforms() -> String:
	return super() + NEW_LINE + _declare_uniform("radius", "float")

func _get_code_function_names() -> Array[StringName]:
	return [&"shape_sphere"]

func _get_code_functions(p_func_name: StringName) -> String:
	return FUNC

func _get_code_body() -> String:
	return super() % _make_operation("shape_sphere(seed, %s, %s, %s)" % [_name_uniform("radius"), _name_uniform("hollowness"), _name_local_var("dir")])

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	super(p_mat)
	p_mat.set_shader_parameter(_name_uniform("radius"), radius)

func _get_gizmo_lines() -> PackedVector3Array:
	var lines := _make_gizmo_circle() * Transform3D.IDENTITY.scaled(Vector3(radius, radius, radius))
	lines += lines * Transform3D.IDENTITY.scaled(Vector3.ZERO.lerp(Vector3.ONE, hollowness * 0.01))
	return lines + lines * Transform3D.IDENTITY.rotated(Vector3(1, 0, 0), deg_to_rad(90)) + lines * Transform3D.IDENTITY.rotated(Vector3(0, 0, 1), deg_to_rad(90))
