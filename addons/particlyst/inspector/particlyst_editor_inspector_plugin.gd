@tool
#class_name ParticlystEditorInspectorPlugin
extends EditorInspectorPlugin

const ParticlystEditorProperty = preload("particlyst_editor_property.gd")
const ParticlystModifier = preload("res://addons/particlyst/modifier/particlyst_modifier.gd")

var gpu_particles: GPUParticles3D

func _can_handle(p_object: Object) -> bool:
	return p_object is GPUParticles3D or p_object is ParticlystProcessMaterial3D or p_object is ParticlystModifier 

func _parse_property(p_object: Object, p_type: Variant.Type, p_name: String, p_hint_type: PropertyHint, p_hint_string: String, p_usage_flags: int, p_wide: bool) -> bool:
	if p_object is Node:
		gpu_particles = p_object as GPUParticles3D
		return false
	
	var particlyst := p_object as ParticlystProcessMaterial3D
	if particlyst == null:
		return false
	
	if p_name == &"modifiers":
		var editor_property := ParticlystEditorProperty.new()
		editor_property.gpu_particles = gpu_particles
		editor_property.particlyst = particlyst
		add_property_editor("modifiers", editor_property, false, "")
	
	return true
