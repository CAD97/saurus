extends CharacterBody3D


@export var move_speed: float = 1.0

var move_intent: Vector2 = Vector2.ZERO


# Called during the physics processing step of the main loop.
func _physics_process(delta: float) -> void:
	move_intent = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	if not is_on_floor():
		move_intent = Vector2.ZERO
	velocity.x = move_intent.x * move_speed
	velocity.z = move_intent.y * move_speed
	velocity += get_gravity() * delta
	move_and_slide()
	
	if global_position.y < -20:
		global_position = Vector3(0, 20, 0)
