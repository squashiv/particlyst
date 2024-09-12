@tool
@icon("icon/particlyst.svg")
class_name ParticlystProcessMaterial3D
extends ShaderMaterial

#region Signals
#endregion

#region Constants
const ParticlystCommon = preload("res://addons/particlyst/common/particlyst_common.gd")
const ParticlystModifier = preload("modifier/particlyst_modifier.gd")
const NEW_LINE = "\n"
const TAB = "\t"
#endregion

#region Variables
@export var modifiers: Array[ParticlystModifier]
#endregion

#region Public functions
func add_modifier(p_modifier: ParticlystModifier) -> void:
	modifiers.append(p_modifier)

func remove_modifier(p_modifier: ParticlystModifier) -> void:
	modifiers.erase(p_modifier)

func move_modifier(p_old_index: int, p_new_index: int) -> void:
	var modifier: Variant = modifiers.pop_at(p_old_index)
	modifiers.insert(p_new_index, modifier)

func replace_modifier(p_from: ParticlystModifier, p_to: ParticlystModifier) -> void:
	modifiers[modifiers.find(p_from)] = p_to

func generate() -> void:
	var included_func_names: Array[StringName]
	
	if shader == null:
		shader = Shader.new()
	shader.code = TEMPLATE.format([
		NEW_LINE + _get_code(ParticlystCommon.Stage.DEFINES),
		NEW_LINE + _get_code(ParticlystCommon.Stage.UNIFORMS),
		NEW_LINE + _get_code(ParticlystCommon.Stage.FUNCTIONS),
		NEW_LINE + _get_code(ParticlystCommon.Stage.START),
		NEW_LINE + _get_code(ParticlystCommon.Stage.PROCESS)
	])
	
	for modifier in modifiers:
		modifier._set_uniforms(self)
#endregion

#region Private functions
func _get_shader_mode() -> Shader.Mode:
	return Shader.Mode.MODE_PARTICLES

func _get_shader_rid() -> RID:
	return shader.get_rid() if shader != null else RID()

func _get_code(p_stage: ParticlystCommon.Stage) -> String:
	var code := ""
	for modifier in modifiers:
		if modifier == null:
			continue
		if not modifier.enabled:
			continue
		var code_line := ""
		match p_stage:
			ParticlystCommon.Stage.DEFINES:
				code_line = modifier._get_code_defines() + NEW_LINE
			ParticlystCommon.Stage.UNIFORMS:
				code_line = modifier._get_code_uniforms() + NEW_LINE
			ParticlystCommon.Stage.FUNCTIONS:
				var func_names: Array[StringName]
				for func_name in modifier._get_code_function_names():
					if not func_names.has(func_name):
						code_line += modifier._get_code_functions(func_name) + NEW_LINE
						func_names.append(func_name)
			ParticlystCommon.Stage.START:
				if modifier._is_on_start():
					code_line = TAB + modifier.get_code_body() + NEW_LINE
			ParticlystCommon.Stage.PROCESS:
				if not modifier._is_on_start():
					code_line = TAB + modifier.get_code_body() + NEW_LINE
			_:
				code_line = ""
				prints("Particlyst error", _get_code)
		if code_line.length() > 4:
			code += code_line
	code = code.trim_suffix(NEW_LINE)
	return code
#endregion

const TEMPLATE = """shader_type particles;
render_mode disable_force, disable_velocity;

// RANDOM
uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}

uint rand_from_seed_uint(inout uint seed) {
	int k;
	int s = int(seed);
	if (s == 0)
	s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0)
		s += 2147483647;
	seed = uint(s);
	return seed % uint(65536);
}

float rand_from_seed(inout uint seed) {
	return float(rand_from_seed_uint(seed)) / 65535.0;
}

float rand_from_seed_float(inout uint seed) {
	return rand_from_seed(seed);
}

vec2 rand_from_seed_vec2(inout uint seed) {
	return vec2(rand_from_seed(seed), rand_from_seed(seed));
}

vec3 rand_from_seed_vec3(inout uint seed) {
	return vec3(rand_from_seed(seed), rand_from_seed(seed), rand_from_seed(seed));
}

vec4 rand_from_seed_vec4(inout uint seed) {
	return vec4(rand_from_seed(seed), rand_from_seed(seed), rand_from_seed(seed), rand_from_seed(seed));
}

float randf_range(inout uint seed, in float from, in float to) {
	return rand_from_seed(seed) * (to - from) + from;
}

vec2 random_axis_vec2(inout uint p_seed) {
	uint r = rand_from_seed_uint(p_seed);
	return vec2(
		float(r % uint(2) == uint(0)),
		float(r % uint(2) == uint(1))
	);
}

vec3 random_axis_vec3(inout uint p_seed) {
	uint r = rand_from_seed_uint(p_seed);
	return vec3(
		float(r % uint(3) == uint(0)),
		float(r % uint(3) == uint(1)),
		float(r % uint(3) == uint(2))
	);
}

vec4 random_axis_vec4(inout uint p_seed) {
	uint r = rand_from_seed_uint(p_seed);
	return vec4(
		float(r % uint(4) == uint(0)),
		float(r % uint(4) == uint(1)),
		float(r % uint(4) == uint(2)),
		float(r % uint(4) == uint(3))
	);
}
// RANDOM

// TRANSFORM
mat4 rotation_matrix(vec3 axis, float angle) {
	float s = sin(angle);
	float c = cos(angle);
	float oc = 1.0 - c;
	return mat4(
		vec4(oc * axis.x * axis.x + c, oc * axis.x * axis.y - axis.z * s, oc * axis.z * axis.x + axis.y * s, 0),
		vec4(oc * axis.x * axis.y + axis.z * s, oc * axis.y * axis.y + c, oc * axis.y * axis.z - axis.x * s, 0),
		vec4(oc * axis.z * axis.x - axis.y * s, oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c, 0),
		vec4(0, 0, 0, 1)
	);
}

mat4 scale_matrix(vec3 p_scale) {
	return mat4(
		vec4(p_scale.x, 0, 0, 0),
		vec4(0, p_scale.y, 0, 0),
		vec4(0, 0, p_scale.z, 0),
		vec4(0, 0, 0, 1)
	);
}

mat4 apply_rotation(mat4 p_transform, vec3 p_euler_angles) {
	p_transform *= rotation_matrix(vec3(1, 0, 0), p_euler_angles.x);
	p_transform *= rotation_matrix(vec3(0, 1, 0), p_euler_angles.y);
	p_transform *= rotation_matrix(vec3(0, 0, 1), p_euler_angles.z);
	return p_transform;
}
// TRANSFORM

#define ACCUM_VELOCITY USERDATA1.xyz
#define PARTICLE_AGE USERDATA1.w
#define START_VELOCITY USERDATA4.xyz

// USER DEFINES{0}

uniform float lifetime_randomness : hint_range(0, 1) = 0;
uniform float inherit_emitter_velocity_start : hint_range(-2, 2) = 0;
uniform float inherit_emitter_velocity_update : hint_range(-2, 2) = 0;

// USER UNIFORMS{1}

// USER FUNCTIONS{2}

void start() {
#if defined(RANDOM_SEED_SETUP)
	RANDOM_SEED_SETUP(573)
#else
	uint seed = hash(NUMBER + uint(573) + RANDOM_SEED);
#endif
	
	if (rand_from_seed(seed) > AMOUNT_RATIO) {
		ACTIVE = false;
	}

	ACCUM_VELOCITY = vec3(0);
	PARTICLE_AGE = 0.0;
	START_VELOCITY = vec3(0);
	COLOR = vec4(1);
	vec3 POSITION = vec3(0);
	vec3 ROTATION = vec3(0);
	vec3 SCALE = vec3(1);
	VELOCITY = vec3(0);
	TRANSFORM = mat4(1);
	CUSTOM = vec4(1);
	
	// USER START{3}
	
	VELOCITY += EMITTER_VELOCITY * inherit_emitter_velocity_start;
	
	START_VELOCITY += VELOCITY;
	
	TRANSFORM[3].xyz = POSITION;
	TRANSFORM = EMISSION_TRANSFORM * TRANSFORM;
	ACCUM_VELOCITY += TRANSFORM[3].xyz;
	
	TRANSFORM = mat4(1);
}

void process() {
#if defined(RANDOM_SEED_SETUP)
	RANDOM_SEED_SETUP(430)
#else
	uint seed = hash(NUMBER + uint(430) + RANDOM_SEED);
#endif
	
	PARTICLE_AGE += DELTA;
	COLOR = vec4(1);
	float ALPHA = 1.0;
	vec3 POSITION = vec3(0);
	vec3 ROTATION = vec3(0);
	vec3 SCALE = vec3(1);
	VELOCITY = vec3(0);
	TRANSFORM = mat4(1);
	CUSTOM = vec4(1);
	
#if defined(PARTICLE_AGE_PERCENT_SETUP)
	PARTICLE_AGE_PERCENT_SETUP
#else
	float PARTICLE_AGE_PERCENT = PARTICLE_AGE / LIFETIME;
#endif
	
	// USER PROCESS{4}
	
	COLOR.a *= ALPHA;
	
	VELOCITY += START_VELOCITY;
	
	VELOCITY += EMITTER_VELOCITY * inherit_emitter_velocity_update;
	ACCUM_VELOCITY += VELOCITY * DELTA;
	POSITION += ACCUM_VELOCITY;
	
	TRANSFORM = apply_rotation(TRANSFORM, radians(ROTATION));
	TRANSFORM *= scale_matrix(SCALE);
	TRANSFORM[3].xyz = POSITION;
	
	if (PARTICLE_AGE_PERCENT > 1.0) {
		ACTIVE = false;
	}
}"""
