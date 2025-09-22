@tool
class_name MaxAspectContainer
extends MarginContainer
## A container that restricts the aspect of its child by adding a margin.


## If the layout width:height ratio exceeds this value, adds horizontal margins
## to keep the content at the specified aspect ratio. A value of 0 means no cap.
@export var max_width_ratio := 0.0
## If the layout height:width ratio exceeds this value, adds vertical margins
## to keep the content at the specified aspect ratio. A value of 0 means no cap.
@export var max_height_ratio := 0.0

@export_group("Alignment", "alignment_")
@export var alignment_width: HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER
@export var alignment_height: VerticalAlignment = VERTICAL_ALIGNMENT_CENTER


var _margin_left := 1_000_000_000:
	set(value):
		if value == _margin_left: return
		_margin_left = value
		add_theme_constant_override(&"margin_left", value)
var _margin_right := 1_000_000_000:
	set(value):
		if value == _margin_right: return
		_margin_right = value
		add_theme_constant_override(&"margin_right", value)
var _margin_top := 1_000_000_000:
	set(value):
		if value == _margin_top: return
		_margin_top = value
		add_theme_constant_override(&"margin_top", value)
var _margin_bottom := 1_000_000_000:
	set(value):
		if value == _margin_bottom: return
		_margin_bottom = value
		add_theme_constant_override(&"margin_bottom", value)


func _init() -> void:
	resized.connect(_on_resized)
	_on_resized()


func _on_resized():
	var margins := Rect2i(0, 0, 0, 0)
	if max_width_ratio > 0.0 and size.x/size.y > max_width_ratio:
		var margin = size.x - size.y*max_width_ratio
		match alignment_width:
			HORIZONTAL_ALIGNMENT_LEFT:
				margins.size.x = int(margin)
			HORIZONTAL_ALIGNMENT_RIGHT:
				margins.position.x = int(margin)
			HORIZONTAL_ALIGNMENT_CENTER:
				margins.position.x = int(margin / 2)
				margins.size.x = int(margin / 2)
	if max_height_ratio > 0.0 and size.y/size.x > max_height_ratio:
		var margin = size.y - size.x*max_height_ratio
		match alignment_height:
			VERTICAL_ALIGNMENT_TOP:
				margins.size.y = int(margin)
			VERTICAL_ALIGNMENT_BOTTOM:
				margins.position.y = int(margin)
			VERTICAL_ALIGNMENT_CENTER:
				margins.position.y = int(margin / 2)
				margins.size.y = int(margin / 2)
	
	_margin_left = margins.position.x
	_margin_right = margins.size.x
	_margin_top = margins.position.y
	_margin_bottom = margins.size.y
