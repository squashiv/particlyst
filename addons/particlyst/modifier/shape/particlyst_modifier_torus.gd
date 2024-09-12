@tool
#class_name ParticlystModifierTorus
extends "../particlyst_modifier_shape.gd"

const FUNC = """vec3 shape_torus(inout uint p_seed, float p_radius, float p_thickness, float p_hollowness) {
	float theta = rand_from_seed(p_seed) * TAU;
	float phi = rand_from_seed(p_seed) * TAU;
	float tube_radius = p_thickness * 0.5;
	float random_radius = mix(sqrt(rand_from_seed(p_seed)), 1.0, p_hollowness) * tube_radius;
	float x = (p_radius + random_radius * cos(phi)) * cos(theta);
	float y = random_radius * sin(phi);
	float z = (p_radius + random_radius * cos(phi)) * sin(theta);
	return vec3(x, y, z);
}"""

@export_range(0, 10, 0.01, "suffix:m") var radius := 1.0
@export_range(0, 10, 0.01, "suffix:m") var thickness := 0.5

func _validate_property(p_property: Dictionary) -> void:
	super(p_property)
	match p_property.name:
		&"radius":
			p_property.particlyst = true
			p_property.revert_value = 1.0
		&"thickness":
			p_property.particlyst = true
			p_property.revert_value = 0.5

static func _get_name_prefix() -> String:
	return "Torus"

static func _get_base_type() -> String:
	return "Shape"

static func _get_icon_path() -> String:
	return "res://addons/particlyst/icon/particlyst_shape_torus.svg"

func _get_code_uniforms() -> String:
	return super() + NEW_LINE + _declare_uniform("radius", "float") + NEW_LINE + _declare_uniform("thickness", "float")

func _get_code_function_names() -> Array[StringName]:
	return [&"shape_torus"]

func _get_code_functions(p_func_name: StringName) -> String:
	return FUNC

func _get_code_body() -> String:
	return super() % _make_operation("shape_torus(seed, %s, %s, %s)" % [_name_uniform("radius"), _name_uniform("thickness"), _name_uniform("hollowness")])

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	super(p_mat)
	p_mat.set_shader_parameter(_name_uniform("radius"), radius)
	p_mat.set_shader_parameter(_name_uniform("thickness"), thickness)

func _get_gizmo_lines() -> PackedVector3Array:
	var lines: PackedVector3Array
	var circle := _make_gizmo_circle()
	var r := Vector3.ONE * radius
	var hr := Vector3.ONE * thickness * 0.5
	lines += circle * Transform3D.IDENTITY.scaled(r) * Transform3D.IDENTITY.translated(Vector3.UP * thickness * 0.5)
	lines += circle * Transform3D.IDENTITY.scaled(r) * Transform3D.IDENTITY.translated(Vector3.DOWN * thickness * 0.5)
	lines += circle * Transform3D.IDENTITY.scaled(r + hr)
	lines += circle * Transform3D.IDENTITY.scaled(r - hr)
	lines += circle * Transform3D.IDENTITY.scaled(Vector3.ONE * thickness * 0.5).rotated(Vector3.RIGHT, deg_to_rad(90)) * Transform3D.IDENTITY.translated(Vector3.LEFT * r)
	lines += circle * Transform3D.IDENTITY.scaled(Vector3.ONE * thickness * 0.5).rotated(Vector3.RIGHT, deg_to_rad(90)) * Transform3D.IDENTITY.translated(Vector3.RIGHT * r)
	lines += circle * Transform3D.IDENTITY.scaled(Vector3.ONE * thickness * 0.5).rotated(Vector3.FORWARD, deg_to_rad(90)) * Transform3D.IDENTITY.translated(Vector3.FORWARD * r)
	lines += circle * Transform3D.IDENTITY.scaled(Vector3.ONE * thickness * 0.5).rotated(Vector3.BACK, deg_to_rad(90)) * Transform3D.IDENTITY.translated(Vector3.BACK * r)
	
	var ir := Vector3.ZERO.lerp(r, hollowness * 0.01)
	var ihr := Vector3.ZERO.lerp(hr, hollowness * 0.01)
	var ithickness := lerpf(0, thickness, hollowness * 0.01)
	
	lines += circle * Transform3D.IDENTITY.scaled(r) * Transform3D.IDENTITY.translated(Vector3.UP * ithickness * 0.5)
	lines += circle * Transform3D.IDENTITY.scaled(r) * Transform3D.IDENTITY.translated(Vector3.DOWN * ithickness * 0.5)
	lines += circle * Transform3D.IDENTITY.scaled(r + ihr)
	lines += circle * Transform3D.IDENTITY.scaled(r - ihr)
	lines += circle * Transform3D.IDENTITY.scaled(Vector3.ONE * ithickness * 0.5).rotated(Vector3.RIGHT, deg_to_rad(90)) * Transform3D.IDENTITY.translated(Vector3.LEFT * r)
	lines += circle * Transform3D.IDENTITY.scaled(Vector3.ONE * ithickness * 0.5).rotated(Vector3.RIGHT, deg_to_rad(90)) * Transform3D.IDENTITY.translated(Vector3.RIGHT * r)
	lines += circle * Transform3D.IDENTITY.scaled(Vector3.ONE * ithickness * 0.5).rotated(Vector3.FORWARD, deg_to_rad(90)) * Transform3D.IDENTITY.translated(Vector3.FORWARD * r)
	lines += circle * Transform3D.IDENTITY.scaled(Vector3.ONE * ithickness * 0.5).rotated(Vector3.BACK, deg_to_rad(90)) * Transform3D.IDENTITY.translated(Vector3.BACK * r)
	return lines
