@tool
#class_name ParameterEnum
extends "particlyst_parameter_base.gd"

@onready var value_option_button: OptionButton = %ValueOptionButton

func _ready() -> void:
	super()
	if is_part_of_edited_scene():
		return
	
	for e in hint_string.split(","):
		var split := e.split(":")
		value_option_button.add_item(split[0], split[1].to_int())
	_value_set(property_get())

func _value_set(p_value: Variant) -> void:
	super(p_value)
	value_option_button.selected = p_value

func _on_value_option_button_item_selected(p_index: int) -> void:
	_value_set(p_index)
	property_set(p_index)

func property_set(p_value: Variant) -> void:
	super(p_value)
	particlyst.generate()
