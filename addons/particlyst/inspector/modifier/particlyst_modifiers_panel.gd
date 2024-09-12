@tool
#class_name ParticlystModifiersPanel
extends Container

const MODIFIER_PANEL = preload("particlyst_modifier_panel.tscn")
const ParticlystModifierPanel = preload("particlyst_modifier_panel.gd")
const ParticlystModifier = preload("res://addons/particlyst/modifier/particlyst_modifier.gd")
const ParticlystModifierTypeOption = preload("res://addons/particlyst/inspector/modifier/particlyst_modifier_type_option.gd")
const ParticlystModifierUniform = preload("res://addons/particlyst/modifier/value/particlyst_modifier_uniform.gd")

var gpu_particles: GPUParticles3D
var particlyst: ParticlystProcessMaterial3D

@onready var modifiers_co: Control = %ModifiersCo
@onready var add_modifier_option_button: ParticlystModifierTypeOption = %AddModifierOptionButton

func _ready() -> void:
	if is_part_of_edited_scene():
		return
	
	add_modifier_option_button.set_modifier(null)
	add_modifier_option_button.selected = 0
	
	for modifier in particlyst.modifiers:
		var modifier_panel := MODIFIER_PANEL.instantiate()
		modifier_panel.gpu_particles = gpu_particles
		modifier_panel.particlyst = particlyst
		modifier_panel.modifier = modifier
		modifiers_co.add_child(modifier_panel)

func _on_add_modifier_button_pressed() -> void:
	particlyst.add_modifier(ParticlystModifierPanel.instance_modifier(ParticlystModifierUniform))
	particlyst.generate()

func _on_add_modifier_option_button_item_selected(p_index: int) -> void:
	particlyst.add_modifier(ParticlystModifierPanel.instance_modifier(add_modifier_option_button.get_selected_metadata()))
	add_modifier_option_button.selected = 0
	particlyst.generate()

func _on_modifiers_co_child_moved(p_last_index: int, p_new_index: int) -> void:
	particlyst.move_modifier(p_last_index, p_new_index)
	particlyst.generate()
