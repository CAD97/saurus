extends Node3D


@export var follow_nodes: Array[Node3D]
@export var follow_strength: float = 1
@export var follow_slack: float = 0.05


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if follow_nodes.size() > 0:
		var target_pos = Vector3()
		for node in follow_nodes:
			target_pos += node.global_position
		target_pos /= follow_nodes.size()
		var pos_diff = target_pos - self.global_position
		if pos_diff.length_squared() > follow_slack * follow_slack:
			self.position += pos_diff * self.follow_strength * delta
