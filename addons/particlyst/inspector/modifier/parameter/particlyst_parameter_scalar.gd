@tool
#class_name ParameterScalar
extends "particlyst_parameter_base.gd"

var value_slider: EditorSpinSlider

func _ready() -> void:
	super()
	if is_part_of_edited_scene():
		return
	
	value_slider = instance_slider(typeof(property_get()))
	value_slider.size_flags_stretch_ratio = 2.0
	value_slider.value_changed.connect(_on_value_slider_value_changed)
	add_child(value_slider)
	_value_set(property_get())

func _value_set(p_value: Variant) -> void:
	super(p_value)
	value_slider.set_value_no_signal(p_value)

func _on_value_slider_value_changed(p_value: float) -> void:
	_value_set(p_value)
	property_set(p_value)
