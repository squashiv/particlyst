@tool
#class_name ParticlystModifierPanel
extends Container

#region Constants
const ParticlystCommon = preload("res://addons/particlyst/common/particlyst_common.gd")
const ParameterBase = preload("parameter/particlyst_parameter_base.gd")
const ParticlystModifier = preload("res://addons/particlyst/modifier/particlyst_modifier.gd")
const TYPE_ENUM_TO_SCENE = {
	TYPE_BOOL: preload("parameter/particlyst_parameter_bool.tscn"),
	TYPE_INT: null,
	TYPE_FLOAT: preload("parameter/particlyst_parameter_scalar.tscn"),
	TYPE_VECTOR2: preload("parameter/particlyst_parameter_vector.tscn"),
	TYPE_VECTOR3: preload("parameter/particlyst_parameter_vector.tscn"),
	TYPE_VECTOR4: preload("parameter/particlyst_parameter_vector.tscn"),
	TYPE_COLOR: preload("parameter/particlyst_parameter_color.tscn"),
	TYPE_OBJECT: null,
}
const ParticlystModifierTypeOption = preload("res://addons/particlyst/inspector/modifier/particlyst_modifier_type_option.gd")
#endregion

#region Variables
var gpu_particles: GPUParticles3D
var particlyst: ParticlystProcessMaterial3D
var modifier: ParticlystModifier

@onready var expand_check_box: CheckBox = %ExpandCheckBox
@onready var target_property_option_button: OptionButton = %TargetPropertyOptionButton
@onready var operation_option_button: OptionButton = %OperationOptionButton
@onready var modifier_type_option_button: ParticlystModifierTypeOption = %ModifierTypeOptionButton
@onready var enabled_check_box: CheckBox = %EnabledCheckBox
@onready var remove_button: Button = %RemoveButton
@onready var properties_co: Control = %PropertiesCo
@onready var drag_control: Control = %DragControl
#endregion

#region Virtual functions
func _ready() -> void:
	if is_part_of_edited_scene():
		return
	
	for i in ParticlystCommon.PROPERTY_DEFINITIONS.keys():
		var def := ParticlystCommon.PROPERTY_DEFINITIONS[i] as Dictionary
		if modifier._is_property_compatible(def.type):
			target_property_option_button.add_icon_item(load(def.icon_path), def.name_gd, def.type)
	
	_ready_initial_control_values()
	instance_properties()

func _ready_initial_control_values() -> void:
	expand_check_box.set_pressed_no_signal(modifier.get_meta(&"_expanded", false))
	target_property_option_button.selected = target_property_option_button.get_item_index(modifier.target_property)
	if modifier.operation == -1:
		operation_option_button.visible = false
	else:
		operation_option_button.selected = modifier.operation
	modifier_type_option_button.set_modifier(modifier)
	modifier_type_option_button.selected = modifier_type_option_button.find_selected_idx(modifier.get_script())
	enabled_check_box.set_pressed_no_signal(modifier.enabled)
	#for i in target_property_option_button.item_count:
		#target_property_option_button.set_item_disabled(i, not modifier._is_property_compatible(target_property_option_button.get_item_id(i)))
	properties_co.visible = expand_check_box.button_pressed

func _get_drag_data(p_at_position: Vector2) -> Variant:
	var drag_control_position := drag_control.global_position - global_position
	var drag_rect := Rect2(drag_control_position, drag_control.size)
	if drag_rect.has_point(p_at_position):
		return self
	return null
#endregion

#region Callback functions
func _on_expand_check_box_toggled(p_toggled_on: bool) -> void:
	properties_co.visible = p_toggled_on
	modifier.set_meta(&"_expanded", p_toggled_on)
	instance_properties()
	if gpu_particles != null:
		gpu_particles.update_gizmos()

func _on_target_property_option_button_item_selected(p_index: int) -> void:
	modifier.target_property = target_property_option_button.get_selected_id()
	modifier.operation = modifier.def.default_operation_gd
	modifier.initialize()
	particlyst.generate()

func _on_operation_option_button_item_selected(p_index: int) -> void:
	modifier.operation = p_index
	particlyst.generate()

func _on_modifier_type_option_button_item_selected(p_index: int) -> void:
	particlyst.replace_modifier(modifier, instance_modifier(modifier_type_option_button.get_selected_metadata(), modifier))
	particlyst.generate()

func _on_enabled_check_box_toggled(p_toggled_on: bool) -> void:
	modifier.enabled = p_toggled_on
	particlyst.generate()

func _on_remove_button_pressed() -> void:
	particlyst.remove_modifier(modifier)
	particlyst.generate()
#endregion

#region Public functions
func instance_properties() -> void:
	if not properties_co.visible:
		return
	if properties_co.get_child_count() > 1:
		return
	
	for property in modifier.get_property_list():
		modifier._validate_property(property)
		if not property.has(&"particlyst"):
			continue
		if not ParticlystCommon.ftest(property.usage, PROPERTY_USAGE_EDITOR):
			continue
		
		var parameter: ParameterBase
		
		parameter = instance_parameter(property)
		
		parameter.gpu_particles = gpu_particles
		parameter.particlyst = particlyst
		parameter.modifier = modifier
		parameter.property = property
		properties_co.add_child(parameter)

func instance_parameter(p_property: Dictionary) -> ParameterBase:
	if p_property.type == TYPE_OBJECT:
		if p_property.class_name == &"CurveTexture":
			return preload("parameter/particlyst_parameter_texture_display.tscn").instantiate()
		else:
			return preload("parameter/particlyst_parameter_resource.tscn").instantiate()
	elif p_property.type == TYPE_INT:
		if ParticlystCommon.ftest(p_property.hint, PROPERTY_HINT_ENUM):
			return preload("parameter/particlyst_parameter_enum.tscn").instantiate()
		else:
			return preload("parameter/particlyst_parameter_scalar.tscn").instantiate()
	else:
		return (TYPE_ENUM_TO_SCENE[p_property.type] as PackedScene).instantiate()

static func instance_modifier(p_script: Script, p_from: ParticlystModifier = null) -> ParticlystModifier:
	var modifier = p_script.new()
	
	modifier.target_property = p_script._get_default_property_type()
	modifier.operation = modifier.def.default_operation_gd
	
	if p_from != null:
		modifier.enabled = p_from.enabled
		modifier.target_property = p_from.target_property
		modifier.operation = p_from.operation
		modifier.set_meta(&"_expanded", p_from.get_meta(&"_expanded", false))
	
	modifier.initialize()
	
	return modifier
#endregion
