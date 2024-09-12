@tool
#class_name ParticlystModifierTypeOption
extends OptionButton

const ParticlystCommon = preload("res://addons/particlyst/common/particlyst_common.gd")
const ParticlystModifier = preload("res://addons/particlyst/modifier/particlyst_modifier.gd")

static var scripts: Array[Script]

func _ready() -> void:
	if is_part_of_edited_scene():
		return
	
	if scripts.is_empty():
		for path in ["res://addons/particlyst/modifier/"]:
			discover_modifiers_recursive(path)

func set_modifier(p_modifier: ParticlystModifier) -> void:
	for script in scripts:
		if p_modifier != null and not script._is_property_compatible(p_modifier.def.type):
			continue
		add_icon_item(load(script._get_icon_path()), script._get_name_prefix())
		set_item_metadata(-1, script)

func discover_modifiers_recursive(p_path: String) -> void:
	var dir := DirAccess.open(p_path)
	dir.list_dir_begin()
	var path_root := dir.get_current_dir() + "/"
	
	while true:
		var file := dir.get_next()
		if file == "":
			break
		if dir.current_is_dir():
			discover_modifiers_recursive(path_root + file)
			continue
		if not file.ends_with(".gd") and not file.ends_with(".gdc"):
			continue
		
		var full_path := path_root + file
		var script := load(full_path) as Script
		if not script or not script.can_instantiate():
			prints("Particlyst error", discover_modifiers_recursive)
			continue
		
		if script._get_base_type() == "":
			continue
		
		scripts.append(script)
	
	dir.list_dir_end()

func find_selected_idx(p_script: Script) -> int:
	for i in item_count:
		if get_item_metadata(i) == p_script:
			return i
	return -1
