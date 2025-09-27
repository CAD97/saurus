@tool
@icon("uid://draqlrm1w627y") # editor/KeyboardPhysical.svg
class_name KeyInputTextures
extends Resource


signal textures_changed()


@export_dir var texture_dir: String:
	set(value):
		if Engine.is_editor_hint():
			texture_dir = value
			_load_from_dir(texture_dir)
			textures_changed.emit()


@export var keys: Dictionary[Key, Texture2D]


func _validate_property(property: Dictionary) -> void:
	match property.name:
		&"texture_dir":
			property.usage |= PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED
		&"keys":
			property.usage |= PROPERTY_USAGE_READ_ONLY


func _load_from_dir(dir: String):
	keys.clear()
	if not dir: return

	for file in ResourceLoader.list_directory(dir):
		var basename = file.get_basename()
		var key := OS.find_keycode_from_string(basename)
		if key:
			# NB: building a dict from code doesn't preserve insertion order,
			#     so there's no way to sort this set for better editor display
			keys[key] = ResourceLoader.load("%s/%s" % [dir, file], "Texture2D")
