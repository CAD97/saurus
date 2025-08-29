extends CharacterBody3D


@export var move_speed: float = 1.0


# Called during the physics processing step of the main loop.
func _physics_process(_delta: float):
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	var intent = dir * self.move_speed
	self.velocity = Vector3(intent.x, self.velocity.y, intent.y)
	self.move_and_slide()
