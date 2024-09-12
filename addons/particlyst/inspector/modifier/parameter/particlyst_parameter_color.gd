@tool
#class_name ParameterColor
extends "particlyst_parameter_base.gd"

@onready var value_color_picker_button: ColorPickerButton = %ValueColorPickerButton

func _ready() -> void:
	super()
	if is_part_of_edited_scene():
		return
	
	value_color_picker_button.get_picker().color_mode = ColorPicker.MODE_OKHSL
	value_color_picker_button.get_picker().picker_shape = ColorPicker.SHAPE_OKHSL_CIRCLE
	_value_set(property_get())

func _on_value_color_picker_button_color_changed(p_color: Color) -> void:
	_value_set(p_color)
	property_set(p_color)

func _value_set(p_value: Variant) -> void:
	super(p_value)
	value_color_picker_button.color = p_value
