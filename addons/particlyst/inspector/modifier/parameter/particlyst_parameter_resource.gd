@tool
#class_name ParameterResource
extends "particlyst_parameter_base.gd"

var value_resource_picker: EditorResourcePicker

func _ready() -> void:
	super()
	if is_part_of_edited_scene():
		return
	
	value_resource_picker = EditorResourcePicker.new()
	value_resource_picker.size_flags_stretch_ratio = 2
	value_resource_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value_resource_picker.base_type = "Texture2D"
	value_resource_picker.resource_changed.connect(_on_value_resource_changed)
	value_resource_picker.resource_selected.connect(_on_value_resource_selected)
	add_child(value_resource_picker)
	_value_set(property_get())

func _value_set(p_value: Variant) -> void:
	super(p_value)
	value_resource_picker.edited_resource = p_value

func _on_value_resource_changed(p_res: Resource) -> void:
	_value_set(p_res)
	property_set(p_res)
	particlyst.generate()

func _on_value_resource_selected(p_res: Resource, p_inspect: bool) -> void:
	_value_set(p_res)
	property_set(p_res)
	#TODO
	#EditorInterface.edit_resource(p_res)
	#EditorInterface.inspect_object(p_res)
