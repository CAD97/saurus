extends CharacterBody3D


var GRAVITY: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")

@export var move_speed: float = 1.0


# Called during the physics processing step of the main loop.
func _physics_process(delta: float):
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	var intent = dir * self.move_speed
	self.velocity = Vector3(intent.x, self.velocity.y, intent.y)
	self.velocity += GRAVITY * delta
	self.move_and_slide()
	
	if self.global_position.y < -20:
		self.global_position = Vector3(0, 20, 0)
