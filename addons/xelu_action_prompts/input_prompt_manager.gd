@tool
extends Node


const XBOX_INPUT_TEXTURES_SETTING := &"addons/xelu_action_prompts/input_textures/xbox"
const NSW_INPUT_TEXTURES_SETTING := &"addons/xelu_action_prompts/input_textures/nintendo_switch"
const PS5_INPUT_TEXTURES_SETTING := &"addons/xelu_action_prompts/input_textures/playstation_5"
const KEY_INPUT_TEXTURES_SETTING := &"addons/xelu_action_prompts/input_textures/keyboard"
const MOUSE_INPUT_TEXTURES_SETTING := &"addons/xelu_action_prompts/input_textures/mouse"
const JOY_AXIS_DETECTION_DEADZONE_SETTING := &"addons/xelu_action_prompts/joy_axis_detection_deadzone"
const DEFAULT_TO_JOYPAD_SETTING := &"addons/xelu_action_prompts/default_prompt_kind"

const FALLBACK_JOY_KIND := JoyKind.XBOX


signal textures_changed()


var joy_kind_override := JoyKind.AUTO
var joy_kind := JoyKind.XBOX:
	get:
		if joy_kind_override: return joy_kind_override
		return joy_kind
	set(value):
		var prev = joy_kind
		joy_kind = value if value else FALLBACK_JOY_KIND
		if use_joypad and joy_kind != prev:
			textures_changed.emit()

var use_joypad: bool = _get_setting(DEFAULT_TO_JOYPAD_SETTING, 0) != 0:
	set(value):
		var prev = use_joypad
		use_joypad = prev
		if use_joypad != prev:
			textures_changed.emit()


var _xbox_input_textures: JoyInputTextures
var _nsw_input_textures: JoyInputTextures
var _ps5_input_textures: JoyInputTextures
var _key_input_textures: KeyInputTextures
var _mouse_input_textures: MouseInputTextures
var _joy_axis_detection_deadzone: float


var _action_prompt_cache: Dictionary[StringName, Dictionary] = {}


func _ready() -> void:
	_reload_input_textures()


func _enter_tree() -> void:
	if Engine.is_editor_hint():
		ProjectSettings.settings_changed.connect(_reload_input_textures, CONNECT_DEFERRED)


func _exit_tree() -> void:
	if Engine.is_editor_hint():
		ProjectSettings.settings_changed.disconnect(_reload_input_textures)


func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	if event is InputEventKey or event is InputEventMouse:
		use_joypad = false
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if event is InputEventJoypadMotion and event.axis_value <= _joy_axis_detection_deadzone: return
		var device = Input.get_joy_name(event.device)
		if device.find("Xbox") != -1:
			joy_kind = JoyKind.XBOX
		elif device.find("DualShock") != -1 or device.find("PS") != -1:
			joy_kind = JoyKind.PS5
		elif device.find("Nintendo") != -1:
			joy_kind = JoyKind.NSW
		else:
			joy_kind = JoyKind.AUTO


func get_texture_for_action(action: StringName) -> Texture2D:
	var prompts := _load_action_prompts(action)
	if use_joypad and joy_kind in prompts:
		return prompts[joy_kind]
	if KIND_KEY in prompts:
		return prompts[KIND_KEY]
	if KIND_MOUSE in prompts:
		return prompts[KIND_MOUSE]
	return null


func get_texture_for_joy_button(button: JoyButton, get_override := JoyKind.AUTO) -> Texture2D:
	var kind := get_override if get_override else joy_kind
	var textures: JoyInputTextures
	match kind:
		JoyKind.XBOX: textures = _xbox_input_textures
		JoyKind.NSW: textures = _nsw_input_textures
		JoyKind.PS5: textures = _ps5_input_textures
	return textures.buttons[button]


func get_texture_for_key(key: Key) -> Texture2D:
	return _key_input_textures.keys[key]


func get_texture_for_mouse_button(button: MouseButton) -> Texture2D:
	return _mouse_input_textures.buttons[button]


static func _action_get_events(action: StringName) -> Array[InputEvent]:
	if Engine.is_editor_hint():
		const DEFAULT := { "events": [] }
		var out: Array[InputEvent] = []
		for event in ProjectSettings.get_setting("input/%s" % action, DEFAULT).events:
			out.append(event as InputEvent)
		return out
	else:
		return InputMap.action_get_events(action)


func _load_action_prompts(action: StringName) -> Dictionary[int, Texture2D]:
	if action in _action_prompt_cache: return _action_prompt_cache[action]

	var prompts: Dictionary[int, Texture2D]
	for event in _action_get_events(action):
		if event is InputEventKey:
			var key_event := event as InputEventKey
			if KIND_KEY not in prompts:
				var key := key_event.keycode if key_event.keycode else key_event.physical_keycode
				if key in _key_input_textures.keys:
					prompts[KIND_KEY] = _key_input_textures.keys[key]
				else:
					push_error("Missing texture for keyboard %s" % key_event.as_text())
		if event is InputEventMouseButton:
			var mouse_event := event as InputEventMouseButton
			if KIND_MOUSE not in prompts:
				if mouse_event.button_index in _mouse_input_textures.buttons:
					prompts[KIND_MOUSE] = _mouse_input_textures.buttons[mouse_event.button_index]
				else:
					push_error("Missing texture for mouse button %s" % mouse_event.as_text())
		if event is InputEventJoypadButton:
			var joypad_event := event as InputEventJoypadButton
			if JoyKind.XBOX not in prompts:
				if joypad_event.button_index in _xbox_input_textures.buttons:
					prompts[JoyKind.XBOX] = _xbox_input_textures.buttons[joypad_event.button_index]
				else:
					push_warning("Missing texture for Xbox %s" % joypad_event.as_text())
			if JoyKind.NSW not in prompts:
				if joypad_event.button_index in _nsw_input_textures.buttons:
					prompts[JoyKind.NSW] = _nsw_input_textures.buttons[joypad_event.button_index]
				else:
					push_warning("Missing texture for Switch %s" % joypad_event.as_text())
			if JoyKind.PS5 not in prompts:
				if joypad_event.button_index in _ps5_input_textures.buttons:
					prompts[JoyKind.PS5] = _ps5_input_textures.buttons[joypad_event.button_index]
				else:
					push_warning("Missing texture for PS5 %s" % joypad_event.as_text())
		if event is InputEventJoypadMotion:
			var joypad_event := event as InputEventJoypadMotion
			if joypad_event.axis_value > _joy_axis_detection_deadzone:
				if JoyKind.XBOX not in prompts:
					if joypad_event.axis in _xbox_input_textures.axis:
						prompts[JoyKind.XBOX] = _xbox_input_textures.axis[joypad_event.axis]
					else:
						push_warning("Missing texture for Xbox %s" % joypad_event.as_text())
				if JoyKind.NSW not in prompts:
					if joypad_event.axis in _nsw_input_textures.axis:
						prompts[JoyKind.NSW] = _nsw_input_textures.axis[joypad_event.axis]
					else:
						push_warning("Missing texture for Switch %s" % joypad_event.as_text())
				if JoyKind.PS5 not in prompts:
					if joypad_event.axis in _ps5_input_textures.axis:
						prompts[JoyKind.PS5] = _ps5_input_textures.axis[joypad_event.axis]
					else:
						push_warning("Missing texture for PS5 %s" % joypad_event.as_text())
	return prompts


func _reload_input_textures() -> void:
	if Engine.is_editor_hint():
		_action_prompt_cache.clear()
		if _xbox_input_textures: _xbox_input_textures.textures_changed.disconnect(_emit_textures_changed)
		if _nsw_input_textures: _nsw_input_textures.textures_changed.disconnect(_emit_textures_changed)
		if _ps5_input_textures: _ps5_input_textures.textures_changed.disconnect(_emit_textures_changed)
		if _key_input_textures: _key_input_textures.textures_changed.disconnect(_emit_textures_changed)
		if _mouse_input_textures: _mouse_input_textures.textures_changed.disconnect(_emit_textures_changed)

	_xbox_input_textures = load(_get_setting(XBOX_INPUT_TEXTURES_SETTING, "uid://bp1osd4fx24mp")) as JoyInputTextures
	assert(_xbox_input_textures, "%s must be an instance of JoyInputTextures" % XBOX_INPUT_TEXTURES_SETTING)
	_nsw_input_textures = load(_get_setting(NSW_INPUT_TEXTURES_SETTING, "uid://dhi5p1hf0iph4")) as JoyInputTextures
	assert(_nsw_input_textures, "%s must be an instance of JoyInputTextures" % NSW_INPUT_TEXTURES_SETTING)
	_ps5_input_textures = load(_get_setting(PS5_INPUT_TEXTURES_SETTING, "uid://b3grbkyv41fgl")) as JoyInputTextures
	assert(_ps5_input_textures, "%s must be an instance of JoyInputTextures" % PS5_INPUT_TEXTURES_SETTING)
	_key_input_textures = load(_get_setting(KEY_INPUT_TEXTURES_SETTING, "uid://dix1ktdccjcyh")) as KeyInputTextures
	assert(_key_input_textures, "%s must be an instance of KeyInputTextures" % KEY_INPUT_TEXTURES_SETTING)
	_mouse_input_textures = load(_get_setting(MOUSE_INPUT_TEXTURES_SETTING, "uid://dyucu1rsu2w8r")) as MouseInputTextures
	assert(_mouse_input_textures, "%s must be an instance of MouseInputTextures" % MOUSE_INPUT_TEXTURES_SETTING)
	_joy_axis_detection_deadzone = _get_setting(JOY_AXIS_DETECTION_DEADZONE_SETTING, 0.2)

	if Engine.is_editor_hint():
		_xbox_input_textures.textures_changed.connect(_emit_textures_changed, CONNECT_DEFERRED)
		_nsw_input_textures.textures_changed.connect(_emit_textures_changed, CONNECT_DEFERRED)
		_ps5_input_textures.textures_changed.connect(_emit_textures_changed, CONNECT_DEFERRED)
		_key_input_textures.textures_changed.connect(_emit_textures_changed, CONNECT_DEFERRED)
		_mouse_input_textures.textures_changed.connect(_emit_textures_changed, CONNECT_DEFERRED)

	_emit_textures_changed()


func _get_setting(config: StringName, default):
	return ProjectSettings.get_setting_with_override(config) if ProjectSettings.has_setting(config) else default


func _emit_textures_changed() -> void:
	textures_changed.emit()


const KIND_MOUSE := -2
const KIND_KEY := -1
enum JoyKind {
	AUTO = 0,
	XBOX,
	NSW,
	PS5,
}

enum InputKind {
	KBM = 1,
	JOY,
}
