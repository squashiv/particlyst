@tool
#class_name ParticlystGizmoPlugin
extends EditorNode3DGizmoPlugin

func _init() -> void:
	create_material("main", Color(1, 1, 1, 0.05))

func _get_gizmo_name() -> String:
	return "ParticlystShape"

func _has_gizmo(p_for_node_3d: Node3D) -> bool:
	return p_for_node_3d is GPUParticles3D

func _redraw(p_gizmo: EditorNode3DGizmo) -> void:
	p_gizmo.clear()
	
	var particlyst := (p_gizmo.get_node_3d() as GPUParticles3D).process_material as ParticlystProcessMaterial3D
	if particlyst == null:
		return
	
	for modifier in particlyst.modifiers:
		if modifier.enabled and modifier.get_meta(&"_expanded", false) and modifier._has_gizmo():
			p_gizmo.add_lines(modifier._get_gizmo_lines(), get_material("main", p_gizmo))
