@tool
extends EditorPlugin


const AUTOLOAD := "InputPromptManager"
const InputPromptManager := preload("uid://cjlt0awvd271e")


const SETTINGS := [
	{
		"initial_value": "uid://dhi5p1hf0iph4", # nsw/input_textures.tres
		"property_info": {
			"name": InputPromptManager.NSW_INPUT_TEXTURES_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.tres,*.res",
		},
	},
	{
		"initial_value": "uid://b3grbkyv41fgl", # ps5/input_textures.tres
		"property_info": {
			"name": InputPromptManager.PS5_INPUT_TEXTURES_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.tres,*.res",
		},
	},
	{
		"initial_value": "uid://bp1osd4fx24mp", # xbox/input_textures.tres
		"property_info": {
			"name": InputPromptManager.XBOX_INPUT_TEXTURES_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.tres,*.res",
		},
	},
	{
		"initial_value": "uid://dix1ktdccjcyh", # key/input_textures.tres
		"property_info": {
			"name": InputPromptManager.KEY_INPUT_TEXTURES_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.tres,*.res",
		},
	},
	{
		"initial_value": "uid://dyucu1rsu2w8r", # mouse/input_textures.tres
		"property_info": {
			"name": InputPromptManager.MOUSE_INPUT_TEXTURES_SETTING,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.tres,*.res",
		},
	},
	{
		"initial_value": 0.2,
		"property_info": {
			"name": InputPromptManager.JOY_AXIS_DETECTION_DEADZONE_SETTING,
			"type": TYPE_FLOAT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,1",
		},
	},
	{
		"initial_value": false,
		"property_info": {
			"name": InputPromptManager.DEFAULT_TO_JOYPAD_SETTING,
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "Keyboard/Mouse,Joypad",
		},
	},
]


func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD, "input_prompt_manager.gd")

	for setting in SETTINGS:
		var property_name = setting.property_info.name
		if not ProjectSettings.has_setting(property_name):
			ProjectSettings.set_setting(property_name, setting.initial_value)
			ProjectSettings.set_initial_value(property_name, setting.initial_value)
			ProjectSettings.add_property_info(setting.property_info)


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD)
