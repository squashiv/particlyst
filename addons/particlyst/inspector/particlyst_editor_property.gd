@tool
#class_name ParticlystEditorProperty
extends EditorProperty

const MODIFIERS_PANEL = preload("modifier/particlyst_modifiers_panel.tscn")

var gpu_particles: GPUParticles3D
var particlyst: ParticlystProcessMaterial3D

func _ready() -> void:
	var modifier_stack_panel := MODIFIERS_PANEL.instantiate()
	modifier_stack_panel.gpu_particles = gpu_particles
	modifier_stack_panel.particlyst = particlyst
	add_child(modifier_stack_panel)
	set_bottom_editor(modifier_stack_panel)
	if gpu_particles != null:
		gpu_particles.update_gizmos()
