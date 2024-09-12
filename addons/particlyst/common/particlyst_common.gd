@tool
#class_name ParticlystCommon
extends RefCounted

const PROPERTY_DEFINITIONS = {
	Property.COLOR: {
		"type": Property.COLOR,
		"name_shader": "COLOR",
		"name_gd": "Color",
		"type_shader": "vec4",
		"type_gd": TYPE_COLOR,
		"hint_shader": " : source_color",
		"hint_texture_shader": " : source_color, filter_linear",
		"hint_gd": PROPERTY_HINT_NONE,
		"hint_string_gd": "",
		"default_gd": Color.WHITE,
		"default_min_gd": Color.BLACK,
		"default_max_gd": Color.WHITE,
		"default_operation_gd": Operation.MULTIPLY,
		"texture_swizzle_shader": "",
		"icon_path": "res://addons/particlyst/icon/particlyst_type_color.svg"
	},
	Property.ALPHA: {
		"type": Property.ALPHA,
		"name_shader": "ALPHA",
		"name_gd": "Alpha",
		"type_shader": "float",
		"type_gd": TYPE_FLOAT,
		"hint_shader": "",
		"hint_texture_shader": " : filter_linear",
		"hint_gd": PROPERTY_HINT_NONE,
		"hint_string_gd": "",
		"default_gd": 1.0,
		"default_min_gd": 0.0,
		"default_max_gd": 1.0,
		"default_operation_gd": Operation.MULTIPLY,
		"texture_swizzle_shader": ".r",
		"range_min": 0.0,
		"range_max": 1.0,
		"icon_path": "res://addons/particlyst/icon/particlyst_type_float.svg"
	},
	Property.POSITION: {
		"type": Property.POSITION,
		"name_shader": "POSITION",
		"name_gd": "Position",
		"type_shader": "vec3",
		"type_gd": TYPE_VECTOR3,
		"hint_shader": "",
		"hint_texture_shader": " : hint_default_black, filter_linear",
		"hint_gd": PROPERTY_HINT_LINK,
		"hint_string_gd": "suffix:m",
		"default_gd": Vector3.ZERO,
		"default_min_gd": Vector3.ONE * -10.0,
		"default_max_gd": Vector3.ONE * 10.0,
		"default_operation_gd": Operation.ADD,
		"texture_swizzle_shader": ".xyz",
		"range_min": -10.0,
		"range_max": 10.0,
		"icon_path": "res://addons/particlyst/icon/particlyst_type_vector3.svg"
	},
	Property.ROTATION: {
		"type": Property.ROTATION,
		"name_shader": "ROTATION",
		"name_gd": "Rotation",
		"type_shader": "vec3",
		"type_gd": TYPE_VECTOR3,
		"hint_shader": "",
		"hint_texture_shader": " : hint_default_black, filter_linear",
		"hint_gd": PROPERTY_HINT_LINK,
		"hint_string_gd": "suffix:°",
		"default_gd": Vector3.ZERO,
		"default_min_gd": Vector3.ONE * -360,
		"default_max_gd": Vector3.ONE * 360,
		"default_operation_gd": Operation.ADD,
		"texture_swizzle_shader": ".xyz",
		"range_min": -360.0,
		"range_max": 360.0,
		"icon_path": "res://addons/particlyst/icon/particlyst_type_vector3.svg"
	},
	Property.SCALE: {
		"type": Property.SCALE,
		"name_shader": "SCALE",
		"name_gd": "Scale",
		"type_shader": "vec3",
		"type_gd": TYPE_VECTOR3,
		"hint_shader": "",
		"hint_texture_shader": " : hint_default_white, filter_linear",
		"hint_gd": PROPERTY_HINT_LINK,
		"hint_string_gd": "",
		"default_gd": Vector3.ONE,
		"default_min_gd": Vector3.ZERO,
		"default_max_gd": Vector3.ONE,
		"default_operation_gd": Operation.MULTIPLY,
		"texture_swizzle_shader": ".xyz",
		"range_min": 0.0,
		"range_max": 10.0,
		"icon_path": "res://addons/particlyst/icon/particlyst_type_vector3.svg"
	},
	Property.VELOCITY: {
		"type": Property.VELOCITY,
		"name_shader": "VELOCITY",
		"name_gd": "Velocity",
		"type_shader": "vec3",
		"type_gd": TYPE_VECTOR3,
		"hint_shader": "",
		"hint_texture_shader": " : hint_default_black, filter_linear",
		"hint_gd": PROPERTY_HINT_LINK,
		"hint_string_gd": "suffix:m/s",
		"default_gd": Vector3.ONE,
		"default_min_gd": Vector3.ONE * -10.0,
		"default_max_gd": Vector3.ONE * 10.0,
		"default_operation_gd": Operation.ADD,
		"texture_swizzle_shader": ".xyz",
		"range_min": -10.0,
		"range_max": 10.0,
		"icon_path": "res://addons/particlyst/icon/particlyst_type_vector3.svg"
	},
	Property.CUSTOM: {
		"type": Property.CUSTOM,
		"name_shader": "CUSTOM",
		"name_gd": "Custom",
		"type_shader": "vec4",
		"type_gd": TYPE_VECTOR4,
		"hint_shader": "",
		"hint_texture_shader": " : hint_default_black, filter_linear",
		"hint_gd": PROPERTY_HINT_LINK,
		"hint_string_gd": "",
		"default_gd": Vector4.ZERO,
		"default_min_gd": Vector4.ZERO * 0.0,
		"default_max_gd": Vector4.ZERO * 1.0,
		"default_operation_gd": Operation.ADD,
		"texture_swizzle_shader": "",
		"range_min": 0.0,
		"range_max": 1.0,
		"icon_path": "res://addons/particlyst/icon/particlyst_type_vector4.svg"
	},
	Property.SPECIAL: {
		"type": Property.SPECIAL,
		"name_shader": "SPECIAL",
		"name_gd": "Special",
		"type_shader": "vec4",
		"type_gd": TYPE_VECTOR4,
		"hint_shader": "",
		"hint_texture_shader": " : hint_default_black, filter_linear",
		"hint_gd": PROPERTY_HINT_LINK,
		"hint_string_gd": "",
		"default_gd": Vector4.ZERO,
		"default_min_gd": Vector4.ZERO,
		"default_max_gd": Vector4.ONE,
		"default_operation_gd": -1,
		"texture_swizzle_shader": "",
		"range_min": 0.0,
		"range_max": 1.0,
		"icon_path": "res://addons/particlyst/icon/particlyst_type_special.svg"
	}
}

enum Stage { # TODO pre start post start etc. stages
	ALL,
	DEFINES,
	UNIFORMS,
	FUNCTIONS,
	START,
	PROCESS
}

enum Property {
	COLOR,
	ALPHA,
	POSITION,
	ROTATION,
	SCALE,
	VELOCITY,
	CUSTOM,
	SPECIAL
}

enum Operation {
	MULTIPLY,
	DIVIDE,
	ADD,
	SUBTRACT,
	SET,
	POWER,
	MIN,
	MAX
}

enum Source {
	LIFETIME,
	RANDOM,
	SPEED
}

static func make_operation(p_operation: Operation, p_target_prop: String, p_modifier_prop: String) -> String:
	match p_operation:
		0:
			return p_target_prop + " *= " + p_modifier_prop + ";"
		1:
			return p_target_prop + " /= " + p_modifier_prop + ";"
		2:
			return p_target_prop + " += " + p_modifier_prop + ";"
		3:
			return p_target_prop + " -= " + p_modifier_prop + ";"
		4:
			return p_target_prop + " = " + p_modifier_prop + ";"
		5:
			return p_target_prop + " = pow(" + p_target_prop + ", " + p_modifier_prop + ");"
		6:
			return p_target_prop + " = min(" + p_target_prop + ", " + p_modifier_prop + ");"
		7:
			return p_target_prop + " = max(" + p_target_prop + ", " + p_modifier_prop + ");"
		_:
			return p_target_prop + " *= " + p_modifier_prop + ";"

static func make_source(p_source: Source) -> String:
	match p_source:
		Source.LIFETIME:
			return "PARTICLE_AGE_PERCENT"
		Source.RANDOM:
			return "rand_from_seed(seed)"
		Source.SPEED:
			return "length(VELOCITY)"
		_:
			return "PARTICLE_AGE_PERCENT"

# https://github.com/godotengine/godot/issues/17708
static func fset(p_flag: int, p_value: int) -> int:
	return p_flag | p_value

static func fclear(p_flag: int, p_value: int) -> int:
	return p_flag & ~p_value

static func ftest(p_flag: int, p_value: int) -> bool:
	return (p_flag & p_value) == p_value

static func ftoggle(p_flag: int, p_value: int) -> int:
	return p_flag ^ p_value
