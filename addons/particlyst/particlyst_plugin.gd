@tool
extends EditorPlugin

const ParticlystEditorInspectorPlugin = preload("inspector/particlyst_editor_inspector_plugin.gd")
const ParticlystGizmoPlugin = preload("res://addons/particlyst/particlyst_gizmo_plugin.gd")

var editor_inspector_plugin := ParticlystEditorInspectorPlugin.new()
var editor_gizmo_plugin := ParticlystGizmoPlugin.new()

func _enter_tree() -> void:
	add_inspector_plugin(editor_inspector_plugin)
	add_node_3d_gizmo_plugin(editor_gizmo_plugin)

func _exit_tree() -> void:
	remove_inspector_plugin(editor_inspector_plugin)
	remove_node_3d_gizmo_plugin(editor_gizmo_plugin)
