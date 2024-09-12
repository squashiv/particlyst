@tool
#class_name ParticlystModifierValue
extends "particlyst_modifier.gd"

static func _get_icon_path() -> String:
	return "res://addons/particlyst/icon/particlyst_type_variant.svg"

static func _is_property_compatible(p_property: ParticlystCommon.Property) -> bool:
	return p_property != ParticlystCommon.Property.SPECIAL
