extends Control


## Emitted when the left mouse button is clicked on this Control.
signal mouse_clicked()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			accept_event()
			mouse_clicked.emit()
