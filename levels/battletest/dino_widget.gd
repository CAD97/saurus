class_name DinoWidget extends Control

signal lmb_clicked()

@export_group("Tween", "_tween_")
@export var _tween_trans: Tween.TransitionType
@export var _tween_duration: float = 1.0

var dino: DinoDef:
	set(value):
		dino = value
		%Sprite.texture = dino.sprite

var _tween: Tween:
	set(value):
		if _tween: _tween.kill()
		_tween = value
var _is_lead := true


func _ready() -> void:
	display_lead()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			lmb_clicked.emit()
			_is_lead = not _is_lead
			if _is_lead:
				display_lead()
			else:
				display_rear()


func display_lead() -> void:
	_display_pos(%LeadPos.position)

func display_rear() -> void:
	_display_pos(%RearPos.position)


func _display_pos(pos: Vector2) -> void:
	if _tween: _tween.kill()
	_tween = create_tween()
	(_tween.tween_property(%Sprite, ^"position", pos, _tween_duration)
			.from_current()
			.set_trans(_tween_trans)
			.set_ease(Tween.EASE_OUT))
