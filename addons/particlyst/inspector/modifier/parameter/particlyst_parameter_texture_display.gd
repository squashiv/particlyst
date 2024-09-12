@tool
#class_name ParameterTextureDisplay
extends "particlyst_parameter_base.gd"

@onready var curve: Control = %Curve

func _ready() -> void:
	super()
	if is_part_of_edited_scene():
		return
	
	(curve.material as ShaderMaterial).set_shader_parameter(&"curve_tex", property_get())
