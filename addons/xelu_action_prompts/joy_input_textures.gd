@icon("uid://cgjubwsmvks88") # editor/Joypad.svg
class_name JoyInputTextures
extends Resource


signal textures_changed()


@export var buttons: Dictionary[JoyButton, Texture2D]:
	set(value):
		buttons = value
		textures_changed.emit()

@export var axis: Dictionary[JoyAxis, Texture2D]:
	set(value):
		axis = value
		textures_changed.emit()
