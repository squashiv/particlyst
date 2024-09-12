@tool
#class_name ParticlystModifierBlend
extends "../particlyst_modifier_value.gd"

@export_storage var value_a: Variant
@export_storage var value_b: Variant
@export var blend_source: ParticlystCommon.Source
@export var trans: Tween.TransitionType
@export var ease: Tween.EaseType
@export var ping_pong := true
@export var spacing := Vector2.ZERO
@export var curve_tex: CurveTexture

func _validate_property(p_property: Dictionary) -> void:
	match p_property.name:
		&"value_a":
			p_property.particlyst = true
			p_property.type = def.type_gd
			p_property.is_variant = true
			p_property.usage = ParticlystCommon.fset(p_property.usage, PROPERTY_USAGE_EDITOR)
			p_property.revert_value = def.default_gd
		&"value_b":
			p_property.particlyst = true
			p_property.type = def.type_gd
			p_property.is_variant = true
			p_property.usage = ParticlystCommon.fset(p_property.usage, PROPERTY_USAGE_EDITOR)
			p_property.revert_value = def.default_gd
		&"blend_source":
			p_property.particlyst = true
			p_property.revert_value = 0
		&"trans":
			p_property.particlyst = true
			p_property.revert_value = 0
			p_property.generate = true
		&"ease":
			p_property.particlyst = true
			p_property.revert_value = 0
			p_property.generate = false
			if trans == 0:
				p_property.usage = ParticlystCommon.fclear(p_property.usage, PROPERTY_USAGE_EDITOR)
		&"ping_pong":
			p_property.particlyst = true
			p_property.revert_value = true
			p_property.generate = false
			if trans == 0:
				p_property.usage = ParticlystCommon.fclear(p_property.usage, PROPERTY_USAGE_EDITOR)
		&"spacing":
			p_property.particlyst = true
			p_property.revert_value = Vector2.ZERO
			p_property.hint = PROPERTY_HINT_RANGE
			p_property.hint_string = "0.0,0.8,0.01"
			p_property.call_on_set = _make_curve_tex
			if trans == 0 or ping_pong == false:
				p_property.usage = ParticlystCommon.fclear(p_property.usage, PROPERTY_USAGE_EDITOR)
		&"curve_tex":
			p_property.particlyst = true
			if trans == 0:
				p_property.usage = ParticlystCommon.fclear(p_property.usage, PROPERTY_USAGE_EDITOR)

static func _get_name_prefix() -> String:
	return "Blend"

static func _get_base_type() -> String:
	return "Value"

func _get_code_uniforms() -> String:
	var code := _declare_uniform("value_a") + NEW_LINE + _declare_uniform("value_b")
	if trans != 0:
		code += NEW_LINE + _declare_uniform_texture("curve_tex", false)
	return code

func _get_code_body() -> String:
	var source_code := ParticlystCommon.make_source(blend_source)
	if trans != 0:
		_make_curve_tex()
		source_code = _sample_texture("curve_tex", source_code)
	return _make_operation("mix(%s, %s, %s)" % [_name_uniform("value_a"), _name_uniform("value_b"), source_code])

func _set_uniforms(p_mat: ShaderMaterial) -> void:
	p_mat.set_shader_parameter(_name_uniform("value_a"), value_a)
	p_mat.set_shader_parameter(_name_uniform("value_b"), value_b)
	if trans != 0:
		p_mat.set_shader_parameter(_name_uniform("curve_tex"), curve_tex)

func _make_curve_tex() -> void:
	if get_meta(&"_curve_gen_hash", -1) == [trans, ease, ping_pong, spacing].hash():
		return
	
	if curve_tex == null:
		curve_tex = CurveTexture.new()
	if curve_tex.curve == null:
		curve_tex.curve = Curve.new()
	
	curve_tex.curve.clear_points()
	if ping_pong:
		for i in 64:
			var value: Variant = Tween.interpolate_value(0.0, 1.0, i / 63.0, 1.0, trans, ease)
			curve_tex.curve.add_point(Vector2(i / 127.0 * (1.0 - spacing.x), value))
			curve_tex.curve.add_point(Vector2(0.5 + lerpf((0.5 - i / 127.0), 0.5, spacing.y), value))
	else:
		for i in 128:
			curve_tex.curve.add_point(Vector2(i / 127.0, Tween.interpolate_value(0.0, 1.0, i / 127.0, 1.0, trans, ease)))
	curve_tex.curve.bake()
	
	set_meta(&"_curve_gen_hash", [trans, ease, ping_pong, spacing].hash())
