@tool
@icon("uid://byn3ehcneub0d")
class_name ActionPromptIcon
extends TextureRect


@export_custom(PROPERTY_HINT_INPUT_NAME, "show_builtin,loose_mode") var action := &"ui_accept":
	set(value):
		action = value
		_reload_icon()


func _ready() -> void:
	_reload_icon()


func _enter_tree() -> void:
	InputPromptManager.textures_changed.connect(_reload_icon)


func _exit_tree() -> void:
	InputPromptManager.textures_changed.disconnect(_reload_icon)


func _validate_property(property: Dictionary) -> void:
	match property.name:
		&"texture":
			property.usage |= PROPERTY_USAGE_READ_ONLY


func _reload_icon() -> void:
	texture = InputPromptManager.get_texture_for_action(action)
