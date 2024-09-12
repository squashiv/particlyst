@tool
#class_name ParameterBase
extends Container

#region Constants
const ParticlystCommon = preload("res://addons/particlyst/common/particlyst_common.gd")
const ParticlystModifier = preload("res://addons/particlyst/modifier/particlyst_modifier.gd")
#endregion

#region Variables
var gpu_particles: GPUParticles3D
var particlyst: ParticlystProcessMaterial3D
var modifier: ParticlystModifier
var property: Dictionary
var hint: PropertyHint
var hint_string: String
var call_on_set_func: Callable

@onready var name_label: Label = %NameLabel
@onready var revert_button: Button = %RevertButton
#endregion

#region Virtual functions
func _ready() -> void:
	if is_part_of_edited_scene():
		return
	
	name = property.name
	name_label.text = name.replace("_", " ").capitalize()
	hint = property.hint
	hint_string = property.hint_string
	revert_button.pressed.connect(_on_revert_button_pressed)
	if property.has(&"call_on_set"):
		call_on_set_func = property.get(&"call_on_set")

func _value_set(p_value: Variant) -> void:
	check_revert_button()
#endregion

#region Callback functions
func _on_revert_button_pressed() -> void:
	_value_set(property.revert_value)
	property_set(property.revert_value)
#endregion

func check_revert_button() -> void:
	revert_button.visible = property.revert_value != property_get()

func property_get() -> Variant:
	return modifier[property.name]

func property_set(p_value: Variant) -> void:
	modifier.set(property.name, p_value)
	modifier._set_uniforms(particlyst)
	check_revert_button()
	if gpu_particles != null:
		gpu_particles.update_gizmos()
	if call_on_set_func.is_valid():
		call_on_set_func.call()

func instance_slider(p_type: Variant.Type) -> EditorSpinSlider:
	var slider := EditorSpinSlider.new()
	
	slider.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if p_type == TYPE_INT:
		slider.step = 1
	else:
		slider.step = 0.001
	#slider.allow_greater = true
	#slider.allow_lesser = true
	
	if property.get(&"is_variant", false):
		slider.min_value = modifier.def.range_min
		slider.max_value = modifier.def.range_max
		slider.suffix = (modifier.def.hint_string_gd as String).trim_prefix("suffix:")
	elif ParticlystCommon.ftest(property.hint, PROPERTY_HINT_RANGE):
		var hints := hint_string.split(",")
		if hints.size() > 0:
			slider.min_value = hints[0].to_float()
		if hints.size() > 1:
			slider.max_value = hints[1].to_float()
		if hints.size() > 2:
			slider.step = hints[2].to_float()
		if hints.size() > 3:
			slider.suffix = hints[3].trim_prefix("suffix:")
	
	return slider
