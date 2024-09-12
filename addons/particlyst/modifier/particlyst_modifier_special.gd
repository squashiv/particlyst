@tool
#class_name ParticlystModifierSpecial
extends "particlyst_modifier.gd"

static func _get_icon_path() -> String:
	return "res://addons/particlyst/icon/particlyst_type_special.svg"

static func _get_default_property_type() -> ParticlystCommon.Property:
	return ParticlystCommon.Property.SPECIAL

static func _is_property_compatible(p_property: ParticlystCommon.Property) -> bool:
	return p_property == ParticlystCommon.Property.SPECIAL
