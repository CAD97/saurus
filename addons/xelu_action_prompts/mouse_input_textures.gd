@tool
@icon("uid://31xmn4yivubs")
class_name MouseInputTextures
extends Resource


signal textures_changed()


@export var buttons: Dictionary[MouseButton, Texture2D]:
	set(value):
		buttons = value
		textures_changed.emit()
