@tool
#class_name ParameterVector
extends "particlyst_parameter_base.gd"

var value_sliders: Array[EditorSpinSlider]
var vec_size := 0
var vec_dummy: Variant

@onready var vector_co: Control = %VectorCo
@onready var link_button: CheckBox = %LinkButton

func _ready() -> void:
	super()
	if is_part_of_edited_scene():
		return
	
	vec_dummy = property.revert_value
	match typeof(vec_dummy):
		TYPE_VECTOR2, TYPE_VECTOR2I:
			vec_size = 2
		TYPE_VECTOR3, TYPE_VECTOR3I:
			vec_size = 3
		TYPE_VECTOR4, TYPE_VECTOR4I:
			vec_size = 4
	
	for i in vec_size:
		value_sliders.append(instance_slider(modifier.def.type_gd))
		value_sliders[-1].value_changed.connect(_on_value_slider_value_changed)
		vector_co.add_child(value_sliders[-1])
	
	_value_set(property_get())
	
	link_button.set_pressed_no_signal(modifier.get_meta(&"_sliders_shared", link_button.button_pressed))
	_on_link_button_toggled(link_button.button_pressed)

func _value_set(p_value: Variant) -> void:
	super(p_value)
	for i in vec_size:
		value_sliders[i].set_value_no_signal(p_value[i])

func _on_value_slider_value_changed(p_value: float) -> void:
	for i in vec_size:
		vec_dummy[i] = value_sliders[i].value
	_value_set(vec_dummy)
	property_set(vec_dummy)

func _on_link_button_toggled(p_toggled_on: bool) -> void:
	for slider in value_sliders:
		if p_toggled_on:
			for other_slider in value_sliders:
				if slider != other_slider:
					slider.share(other_slider)
		else:
			slider.unshare()
	modifier.set_meta(&"_sliders_shared", p_toggled_on)
