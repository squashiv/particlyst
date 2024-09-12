@tool
#class_name ParameterBool
extends "particlyst_parameter_base.gd"

@onready var value_check_box: CheckBox = %ValueCheckBox

func _ready() -> void:
	super()
	if is_part_of_edited_scene():
		return
	
	_value_set(property_get())

func _value_set(p_value: Variant) -> void:
	super(p_value)
	value_check_box.set_pressed_no_signal(p_value)

func _on_value_check_box_toggled(p_toggled_on: bool) -> void:
	_value_set(p_toggled_on)
	property_set(p_toggled_on)

func property_set(p_value: Variant) -> void:
	super(p_value)
	particlyst.generate()
